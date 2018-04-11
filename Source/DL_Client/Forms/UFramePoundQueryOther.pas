{*******************************************************************************
  作者: juner11212436@163.com 2018-04-08
  描述: 矿山外运称重查询
*******************************************************************************}
unit UFramePoundQueryOther;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxCheckBox, cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxDropDownEdit;

type
  TfFramePoundQueryOther = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCus: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N3: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Check1: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    N4: TMenuItem;
    N5: TMenuItem;
    EditPID: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N6: TMenuItem;
    chkTime: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    N12: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure chkTimePropertiesChange(Sender: TObject);
    procedure N12Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FJBWhere: string;
    //交班查询
    FPreFix: string;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure AfterInitFormData; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    function DeleteDirectory(nDir :String): boolean;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ShellAPI, ULibFun, UMgrControl, UDataModule, USysBusiness, UFormDateFilter,
  UFormWait, USysConst, USysDB, UFormBase;

class function TfFramePoundQueryOther.FrameID: integer;
begin
  Result := cFI_FramePoundQueryOther;
end;

procedure TfFramePoundQueryOther.OnCreateFrame;
var nStr: string;
begin
  inherited;
  FPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FPreFix := Fields[0].AsString;
  end;

  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFramePoundQueryOther.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFramePoundQueryOther.InitFormDataSQL(const nWhere: string): string;
begin
  FEnableBackDB := True;
  //启用备份数据库

  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

//  Result := 'Select pl.*,(P_MValue-P_PValue) As P_NetWeight,' +
//            'ABS((P_MValue-P_PValue)-P_LimValue) As P_Wucha From $PL pl';
  Result := 'Select pl.*,bl.*,so.*,(P_MValue-P_PValue) As P_NetWeight,' +
            'case when (pl.P_PDate IS not null) and (pl.P_PDate IS not null)'+
            ' then (case when pl.P_PDate > pl.P_MDate then pl.P_PDate else'+
            ' pl.P_MDate end) else null end as P_NetDate,'+
            'ABS((P_MValue-P_PValue)-P_LimValue) As P_Wucha From $PL pl' +
            ' Left Join $BL bl On ((bl.L_ID=pl.P_Bill) or (bl.L_ID=pl.P_OrderBak) )'+
            ' Left Join $SO so On so.O_Order=bl.L_ZhiKa';
  //xxxxx

  if FJBWhere = '' then
  begin
    if chkTime.ItemIndex = 0 then
      Result := Result + ' Where (P_PDate >=''$S'' and P_PDate<''$E'') '
    else
      Result := Result + ' Where (P_MDate >=''$S'' and P_MDate<''$E'') ';
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  Result := Result + ' And so.O_Order like ''%%' + FPreFix + '%%''' ;

  if Check1.Checked then
       Result := MacroValue(Result, [MI('$PL', sTable_PoundBak),
       MI('$BL', sTable_Bill),
       MI('$SO', sTable_SalesOrder)])
  else Result := MacroValue(Result, [MI('$PL', sTable_PoundLog),
       MI('$BL', sTable_Bill),
       MI('$SO', sTable_SalesOrder)]);

  Result := MacroValue(Result, [MI('$S', Date2Str(FStart)),
            MI('$E', Date2Str(FEnd+1))]);
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

procedure TfFramePoundQueryOther.AfterInitFormData;
begin
  FJBWhere := '';
end;

//Desc: 日期筛选
procedure TfFramePoundQueryOther.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFramePoundQueryOther.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditPID then
  begin
    EditPID.Text := Trim(EditPID.Text);
    if EditPID.Text = '' then Exit;

    if Length(EditPID.Text) <= 3 then
    begin
      FWhere := 'P_ID like ''%%%s%%''';
      FWhere := Format(FWhere, [EditPID.Text]);
    end else
    begin
      FWhere := '';
      FJBWhere := 'P_ID like ''%%%s%%''';
      FJBWhere := Format(FJBWhere, [EditPID.Text]);
    end;
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'P_Truck like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'P_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFramePoundQueryOther.Check1Click(Sender: TObject);
begin
  BtnRefresh.Click;
end;

//------------------------------------------------------------------------------
//Desc: 权限控制
procedure TfFramePoundQueryOther.PMenu1Popup(Sender: TObject);
begin
  N3.Enabled := BtnPrint.Enabled and (not Check1.Checked);
end;

//Desc: 打印磅单
procedure TfFramePoundQueryOther.N3Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if SQLQuery.FieldByName('P_PValue').AsFloat = 0 then
    begin
      ShowMsg('请先称量皮重', sHint); Exit;
    end;

    nStr := SQLQuery.FieldByName('P_ID').AsString;
    if SQLQuery.FieldByName('P_PoundIdx').AsInteger > 0 then
      PrintPoundOtherReport(nStr, False)
    else
      PrintPoundReport(nStr, False);
  end
end;

//Desc: 时间段查询
procedure TfFramePoundQueryOther.N2Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    case TComponent(Sender).Tag of
     10: FJBWhere := 'P_PDate>=''$S'' And P_PDate<''$E''';
     20: FJBWhere := 'P_MDate>=''$S'' And P_MDate<''$E''';
     30: FJBWhere := '(P_PDate>=''$S'' And P_PDate<''$E'') Or ' +
                     '(P_MDate>=''$S'' And P_MDate<''$E'')';
     //xxxxx
    end;

    FJBWhere := MacroValue(FJBWhere, [MI('$S', DateTime2Str(FTimeS)),
                MI('$E', DateTime2Str(FTimeE))]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//Desc: 删除榜单
procedure TfFramePoundQueryOther.BtnDelClick(Sender: TObject);
var nIdx: Integer;
    nStr,nID,nP: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;
  nStr := Format('确定要删除编号为[ %s ]的过磅单吗?', [nID]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := Format('Select * From %s Where 1<>1', [sTable_PoundLog]);
  //only for fields
  nP := '';

  with FDM.QueryTemp(nStr) do
  begin
    for nIdx:=0 to FieldCount - 1 do
    if (Fields[nIdx].DataType <> ftAutoInc) and
       (Pos('P_Del', Fields[nIdx].FieldName) < 1) then
      nP := nP + Fields[nIdx].FieldName + ',';
    //所有字段,不包括删除
    System.Delete(nP, Length(nP), 1);
  end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into $PB($FL,P_DelMan,P_DelDate) ' +
            'Select $FL,''$User'',$Now From $PL Where P_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$PB', sTable_PoundBak),
            MI('$FL', nP), MI('$User', gSysParam.FUserID),
            MI('$Now', sField_SQLServer_Now),
            MI('$PL', sTable_PoundLog), MI('$ID', nID)]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Delete From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nID]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('删除完毕', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除失败', sError);
  end;
end;

//Desc: 查看抓拍
procedure TfFramePoundQueryOther.N4Click(Sender: TObject);
var nStr,nID,nDir: string;
    nPic: TPicture;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要查看的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;
  nDir := gSysParam.FPicPath + nID + '\';

  DeleteDirectory(gSysParam.FPicPath + nID);
  if DirectoryExists(nDir) then
  begin
    ShellExecute(GetDesktopWindow, 'open', PChar(nDir), nil, nil, SW_SHOWNORMAL);
    Exit;
  end else ForceDirectories(nDir);

  nPic := nil;
  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Picture, nID]);

  ShowWaitForm(ParentForm, '读取图片', True);
  try
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('本次称重无抓拍', sHint);
        Exit;
      end;

      nPic := TPicture.Create;
      First;

      While not eof do
      begin
        nStr := nDir + Format('%s_%s.jpg', [FieldByName('P_ID').AsString,
                FieldByName('R_ID').AsString]);
        //xxxxx

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

function TfFramePoundQueryOther.DeleteDirectory(nDir :String): boolean;
var
f: TSHFILEOPSTRUCT;
begin
  FillChar(f, SizeOf(f), 0);
  with f do
  begin
    Wnd := 0;
    wFunc := FO_DELETE;
    pFrom := PChar(nDir+#0);
    pTo := PChar(nDir+#0);
    fFlags := FOF_ALLOWUNDO+FOF_NOCONFIRMATION+FOF_NOERRORUI;
  end;
  Result := (SHFileOperation(f) = 0);
end;

procedure TfFramePoundQueryOther.chkTimePropertiesChange(Sender: TObject);
begin
  InitFormData('');
end;

procedure TfFramePoundQueryOther.N12Click(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要勘误的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;

  nList := TStringList.Create;
  try
    nList.Add(nID);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;

    CreateBaseFormItem(cFI_FormSaleKwOther, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;

end;

initialization
  gControlManager.RegCtrl(TfFramePoundQueryOther, TfFramePoundQueryOther.FrameID);
end.
