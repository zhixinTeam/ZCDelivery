{*******************************************************************************
  作者: fendou116688@163.com 2015/8/8
  描述: 采购订单管理
*******************************************************************************}
unit UFramePurchaseOrder;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxCheckBox, dxLayoutcxEditAdapters;

type
  TfFramePurchaseOrder = class(TfFrameNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N6: TMenuItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Check1: TcxCheckBox;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    function GetVal(const nRow: Integer; const nField: string): string;
    //获取指定字段
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl,UDataModule, UFrameBase, UFormBase, USysBusiness,
  USysConst, USysDB, UFormDateFilter, UFormInputbox, ShellAPI, UFormWait,
  USysPopedom;

//------------------------------------------------------------------------------
class function TfFramePurchaseOrder.FrameID: integer;
begin
  Result := cFI_FrameOrder;
end;

procedure TfFramePurchaseOrder.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  InitDateRange(Name, FStart, FEnd);

  {$IFDEF SyncDataByDataBase}
  N9.Visible := True;
  N11.Visible := False;
  N12.Visible := False;
  {$ELSE}
  N9.Visible := False;
  {$ENDIF}
end;

procedure TfFramePurchaseOrder.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFramePurchaseOrder.InitFormDataSQL(const nWhere: string): string;
begin
  {$IFDEF SyncDataByWSDL}
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then
  begin
    N11.Visible := True;
    N12.Visible := True;
  end
  else
  begin
    N11.Visible := False;
    N12.Visible := False;
  end;
  {$ENDIF}
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select oo.* From $OO oo ' ;
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where (O_Date >=''$ST'' and O_Date<''$End'') '
  else Result := Result + ' Where (' + nWhere + ')';

  if Check1.Checked then
       Result := MacroValue(Result, [MI('$OO', sTable_OrderBak)])
  else Result := MacroValue(Result, [MI('$OO', sTable_Order)]);

  Result := MacroValue(Result, [MI('$OO', sTable_Order),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);

  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFramePurchaseOrder.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormOrder, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFramePurchaseOrder.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('O_ID').AsString;
  CreateBaseFormItem(cFI_FormOrder, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除
procedure TfFramePurchaseOrder.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('O_ID').AsString;
  if not QueryDlg('确定要删除编号为[ ' + nStr + ' ]的订单吗?', sAsk) then Exit;

  if DeleteOrder(nStr) then
  begin
    try
      SaveWebOrderDelMsg(nStr,sFlag_Provide);
    except
    end;
    //插入删除推送
    ShowMsg('已成功删除记录', sHint);
  end;

  InitFormData('');
end;

//Desc: 查看内容
procedure TfFramePurchaseOrder.cxView1DblClick(Sender: TObject);
begin
end;

//Desc: 日期筛选
procedure TfFramePurchaseOrder.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 获取nRow行nField字段的内容
function TfFramePurchaseOrder.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.ViewData.Rows[nRow].Values[
            cxView1.GetColumnByFieldName(nField).Index];
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

//Desc: 执行查询
procedure TfFramePurchaseOrder.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'oo.O_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'oo.O_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'O_ProPY like ''%%%s%%'' Or O_ProName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFramePurchaseOrder.N1Click(Sender: TObject);
var nOrderID, nTruck: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;
  nOrderID := SQLQuery.FieldByName('O_ID').AsString;
  nTruck   := SQLQuery.FieldByName('O_Truck').AsString;

  if SetOrderCard(nOrderID, nTruck, True) then
    ShowMsg('办理磁卡成功', sHint);
  //办理磁卡
end;

procedure TfFramePurchaseOrder.N2Click(Sender: TObject);
var nCard: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nCard := SQLQuery.FieldByName('O_Card').AsString;
  if LogoutOrderCard(nCard) then
    ShowMsg('注销磁卡成功', sHint);
  //办理磁卡
  InitFormData('');
end;

procedure TfFramePurchaseOrder.N3Click(Sender: TObject);
var
  nStr,nTruck,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('O_Truck').AsString;
    nTruck := nStr;
    if not ShowInputBox('请输入新的车牌号码:', '修改', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //无效或一致

    nStr := SQLQuery.FieldByName('O_ID').AsString;
    nSQL := 'select * from %s where D_OID=''%s'' ';
    nSQL := Format(nSQL,[sTable_OrderDtl,nStr]);
    with FDM.QueryTemp(nSQL) do
    begin
      if RecordCount > 0 then
      begin
        if (FieldByName('D_Status').AsString<>sFlag_TruckNone) and
          (FieldByName('D_Status').AsString<>sFlag_TruckIn) then
        begin
          ShowMsg('车辆已称重，禁止修改',sHint);
          Exit;
        end;
      end;
    end;
    if ChangeOrderTruckNo(nStr, nTruck) then
    begin
      nSQL := 'update %s set D_Truck=''%s'' where D_OID=''%s'' ';
      nSQL := Format(nSQL,[sTable_OrderDtl, nTruck, nStr]);
      with FDM.SqlTemp do
      begin
        Close;
        SQL.Text:=nSQL;
        Open;
      end;
      nStr := '修改车牌号[ %s -> %s ].';
      nStr := Format(nStr, [SQLQuery.FieldByName('O_Truck').AsString, nTruck]);
      FDM.WriteSysLog(sFlag_BillItem, SQLQuery.FieldByName('O_ID').AsString, nStr, False);

      InitFormData(FWhere);
      ShowMsg('车牌号修改成功', sHint);
    end;
  end;
end;

procedure TfFramePurchaseOrder.Check1Click(Sender: TObject);
begin
  inherited;
  InitFormData('');
end;

procedure TfFramePurchaseOrder.N4Click(Sender: TObject);
var nStr,nID,nDir: string;
    nPic: TPicture;
    nystdno,nTruckno,ndate:string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要查看的记录', sHint);
    Exit;
  end;
  nystdno := SQLQuery.FieldByName('O_YSTDno').AsString;
  nTruckno := SQLQuery.FieldByName('O_Truck').AsString;
  ndate := FormatDateTime('yyyymmdd',SQLQuery.FieldByName('O_date').AsDateTime);
  nDir := gSysParam.FPicPath + nystdno+'\'+ nTruckno + '\'+ ndate +'\';

  if not DirectoryExists(nDir) then
  begin
    ForceDirectories(nDir);
  end;

  nPic := nil;
  nStr := 'Select * From %s Where P_ID like ''%s%%'' and p_name=''%s''';
  nStr := Format(nStr, [sTable_Picture, nystdno, nTruckno]);
  ShowWaitForm(ParentForm, '读取图片', True);
  try
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('本次验收无抓拍', sHint);
        Exit;
      end;
      
      nPic := TPicture.Create;
      First;
      while not Eof do
      begin
        nStr := nDir + Format('%s_%s.jpg', [FieldByName('P_ID').AsString,
                FieldByName('R_ID').AsString]);
        if FileExists(nStr) then
        begin
          Next;
          Continue;
        end;
        FDM.LoadDBImage(FDM.SqlTemp, 'P_Picture', nPic);
        nPic.SaveToFile(nStr);
        Next;
      end;
    end;
    ShellExecute(GetDesktopWindow, 'open', PChar(nDir), nil, nil, SW_SHOWNORMAL);
    //open dir
  finally
    nPic.Free;
    CloseWaitForm;
    FDM.SqlTemp.Close;
  end;
end;

procedure TfFramePurchaseOrder.N7Click(Sender: TObject);
var
  nY_stockno,nStuckno,nStr:string;
  nTunnel:string;
  nY_valid:string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要查看的记录', sHint);
    Exit;
  end;

  nStuckno := SQLQuery.FieldByName('O_Stockno').AsString;

  if not InputQuery('提示','请输入验收通道',nTunnel) then Exit;
  if nTunnel='' then Exit;

//  nStr := 'select * from %s where y_id=''%s''';
//  nStr := Format(nStr,[sTable_YSLines,nTunnel]);
  with fdm.QuerySQL(nStr) do
  begin
    if recordcount=0 then
    begin
      ShowMsg('验收通道'+nTunnel+'不存在',sHint);
      Exit;
    end;

    nY_valid := FieldByName('Y_Valid').asstring;
    if nY_valid=sflag_no then
    begin
      ShowMsg('验收通道'+nTunnel+'已关闭',sHint);
      Exit;
    end;
    nY_stockno := FieldByName('Y_StockNo').asstring;
  end;

  if Pos(nStuckno,nY_stockno)=0 then
  begin
    ShowMsg('请更换验收通道',sHint);
    Exit;
  end;
  ShowMsg('验收成功',sHint);
end;

procedure TfFramePurchaseOrder.N9Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx := 0 to cxView1.DataController.RowCount - 1  do
    begin
      if GetVal(nIdx,'O_CType') <> sFlag_OrderCardG then
      begin
        ShowMsg('选择的记录中存在临时卡,请重新选择', sHint); Exit;
      end;

      nStr := GetVal(nIdx,'O_ID');
      if nStr = '' then
        Continue;

      nList.Add(nStr);
    end;

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    CreateBaseFormItem(cFI_FormModifyStock, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;
end;

procedure TfFramePurchaseOrder.N10Click(Sender: TObject);
var
  nStr,nTruck,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('O_Ship').AsString;
    nTruck := nStr;
    if not ShowInputBox('请输入新的船号:', '修改', nTruck, 15) then Exit;

    if (nTruck = '') or (nStr = nTruck) then Exit;
    //无效或一致

    nStr := SQLQuery.FieldByName('O_ID').AsString;
    nSQL := 'select top 1 * from %s where D_OID=''%s'' order by R_ID desc ';
    nSQL := Format(nSQL,[sTable_OrderDtl,nStr]);
    with FDM.QueryTemp(nSQL) do
    begin
      if RecordCount > 0 then
      begin
        if (FieldByName('D_Status').AsString=sFlag_TruckBFP) or
          (FieldByName('D_Status').AsString=sFlag_TruckBFM) then
        begin
          ShowMsg('车辆已称重，禁止修改',sHint);
          Exit;
        end;
      end;
    end;

    nSQL := 'update %s set O_Ship=''%s'' where O_ID=''%s'' ';
    nSQL := Format(nSQL,[sTable_Order, nTruck, nStr]);

    FDM.ExecuteSQL(nSQL);

    nStr := '修改船号[ %s -> %s ].';
    nStr := Format(nStr, [SQLQuery.FieldByName('O_Ship').AsString, nTruck]);
    FDM.WriteSysLog(sFlag_BillItem, SQLQuery.FieldByName('O_ID').AsString, nStr, False);

    InitFormData(FWhere);
    ShowMsg('船号修改成功', sHint);
  end;
end;

procedure TfFramePurchaseOrder.N12Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    for nIdx := 0 to cxView1.DataController.RowCount - 1  do
    begin
      if GetVal(nIdx,'O_CType') <> sFlag_OrderCardG then
      begin
        ShowMsg('选择的记录中存在临时卡,请重新选择', sHint); Exit;
      end;

      nStr := GetVal(nIdx,'O_ID');
      if nStr = '' then
        Continue;

      nList.Add(nStr);
    end;

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    CreateBaseFormItem(cFI_FormModifyStock, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;
end;

procedure TfFramePurchaseOrder.N11Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    nStr := SQLQuery.FieldByName('O_ID').AsString;

    nList.Add(nStr);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    CreateBaseFormItem(cFI_FormModifyStock, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePurchaseOrder, TfFramePurchaseOrder.FrameID);
end.
