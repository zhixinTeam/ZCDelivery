{*******************************************************************************
  作者: juner11212436@163.com 2018/03/15
  描述: 磅单勘误
*******************************************************************************}
unit UFormPoundKw;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormPoundKw = class(TfFormNormal)
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditID: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditProvider: TcxTextEdit;
    dxlytmLayout1Item3: TdxLayoutItem;
    editMemo: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    EditModel: TcxTextEdit;
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
    EditShip: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditYear: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditKD: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FCardData, FListA: TStrings;

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
  UDataModule, USysBusiness, USysDB, USysGrid, USysConst,DateUtils;


class function TfFormPoundKw.CreateForm(const nPopedom: string;
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

  try
    CreateBaseFormItem(cFI_FormGetPOrderBase, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then
    begin
      nStr := '';
    end
    else
      nStr := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormPoundKw.Create(Application) do
  try
    Caption := '磅单勘误';

    FListA.Text := nModifyStr;
    FCardData.Text := PackerDecodeStr(nStr);
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

class function TfFormPoundKw.FormID: integer;
begin
  Result := cFI_FormPoundKw;
end;

procedure TfFormPoundKw.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  FCardData := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormPoundKw.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
  FCardData.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormPoundKw.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  with FCardData do
  begin
    EditID.Text       := Values['SQ_ID'];
    EditProvider.Text := Values['SQ_ProName'];
    EditMate.Text     := Values['SQ_StockName'];
    EditModel.Text    := Values['SQ_Model'];
    EditYear.Text     := Values['SQ_Year'];
    EditKD.Text       := Values['SQ_KD'];
    editMemo.Text     := Values['SQ_Memo'];
  end;
  for nIdx := 0 to FListA.Count - 1 do
  begin
    nStr := 'select * From %s a, %s b, %s c'+
    ' where a.D_OID=b.O_ID and a.D_ID=c.P_OrderBak and c.P_ID = ''%s'' ';

    nStr := Format(nStr,[sTable_OrderDtl,sTable_Order,sTable_PoundLog,FListA.Strings[nIdx]]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
        Continue;

      with ListQuery.Items.Add do
      begin
        Caption := FieldByName('P_ID').AsString;
        SubItems.Add(FieldByName('P_Truck').AsString);
        SubItems.Add(FieldByName('P_MName').AsString);
        SubItems.Add(FieldByName('P_BID').AsString);
        SubItems.Add(FieldByName('P_PValue').AsString);
        SubItems.Add(FieldByName('P_MValue').AsString);
        SubItems.Add(FieldByName('P_Model').AsString);
        SubItems.Add(FieldByName('P_Ship').AsString);
        SubItems.Add(FieldByName('P_Year').AsString);
        SubItems.Add(FieldByName('P_KD').AsString);
        ImageIndex := cItemIconIndex;
      end;
      EditTruck.Text := FieldByName('P_Truck').AsString;
      EditShip.Text := FieldByName('P_Ship').AsString;
      EditPValue.Text := FieldByName('P_PValue').AsString;
      EditMValue.Text := FieldByName('P_MValue').AsString;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
  BtnOK.Enabled := ListQuery.Items.Count>0;
end;

//Desc: 保存
procedure TfFormPoundKw.BtnOKClick(Sender: TObject);
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

    if Length(EditID.Text) > 0 then//更换订单
    begin

      nSQL := 'Update %s Set P_MID=''%s'', P_MName=''%s'',P_CusID=''%s'','+
              ' P_CusName=''%s'',P_PValue=''%s'',P_MValue=''%s'','+
              ' P_BID=''%s'',P_Model=''%s'','+
              ' P_Ship=''%s'',P_Year=''%s'',P_KD=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_ID=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog, FCardData.Values['SQ_StockNo'],
                                          FCardData.Values['SQ_StockName'],
                                          FCardData.Values['SQ_ProID'],
                                          FCardData.Values['SQ_ProName'],
                                          EditPValue.Text,
                                          EditMValue.Text,
                                          EditID.Text,
                                          EditModel.Text,
                                          EditShip.Text,
                                          EditYear.Text,
                                          EditKD.Text,
                                          gSysParam.FUserID,
                                          sField_SQLServer_Now,
                                          Trim(EditTruck.Text),
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end
    else
    begin

      nSQL := 'Update %s Set P_PValue=''%s'',P_MValue=''%s'',P_Ship=''%s'','+
              ' P_KwMan=''%s'',P_KwDate=%s,P_Truck=''%s'' Where P_ID=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,EditPValue.Text,
                                            EditMValue.Text,
                                            EditShip.Text,
                                            gSysParam.FUserID,
                                            sField_SQLServer_Now,
                                            Trim(EditTruck.Text),
                                            FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;

    if chkReSync.Checked then
    begin
      nSQL := 'Update %s Set P_BDAX = 0 Where P_ID=''%s''';
      nSQL := Format(nSQL, [sTable_PoundLog,FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;

  end;

  ModalResult := mrOK;
  if chkReSync.Checked then
    nStr := '勘误完成,请重新上传'
  else
    nStr := '勘误完成';
  ShowMsg(nStr, sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormPoundKw, TfFormPoundKw.FormID);
end.
