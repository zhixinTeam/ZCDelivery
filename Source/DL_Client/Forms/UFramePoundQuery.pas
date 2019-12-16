{*******************************************************************************
  作者: dmzn@163.com 2012-03-31
  描述: 称重查询
*******************************************************************************}
unit UFramePoundQuery;

{$I Link.inc}
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
  TfFramePoundQuery = class(TfFrameNormal)
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
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    chkTime: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    N12: TMenuItem;
    N14: TMenuItem;
    N13: TMenuItem;
    N15: TMenuItem;
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
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure chkTimePropertiesChange(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
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
  UFormWait, USysConst, USysDB, UFormBase, UBusinessPacker, USysPopedom;

class function TfFramePoundQuery.FrameID: integer;
begin
  Result := cFI_FramePoundQuery;
end;

procedure TfFramePoundQuery.OnCreateFrame;
var nStr: string;
begin
  inherited;
  {$IFDEF SyncDataByDataBase}
  N6.Visible := True;
  N9.Visible := True;
  N10.Visible := True;
  N11.Visible := True;
  N12.Visible := True;
  N13.Visible := False;
  N14.Visible := False;
  N15.Visible := False;
  {$ELSE}
  N6.Visible := False;
  N9.Visible := False;
  N10.Visible := False;
  N11.Visible := False;
  N12.Visible := False;
  N13.Visible := True;
  N14.Visible := True;
  {$ENDIF}

  {$IFDEF UseWXERP}
  N6.Visible  := True;
  N9.Visible  := True;
  N10.Visible := True;
  N11.Visible := True;
  N12.Visible := False;
  N13.Visible := False;
  N14.Visible := False;
  N15.Visible := False;
  N9.Caption  := '磅单上传';
  N10.Caption := '磅单勘误';
  {$ENDIF}
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

procedure TfFramePoundQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

function TfFramePoundQuery.InitFormDataSQL(const nWhere: string): string;
begin
  {$IFDEF SyncDataByWSDL}
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then
  begin
    N15.Visible := True;
  end
  else
  begin
    N15.Visible := False;
  end;
  {$ENDIF}

  FEnableBackDB := True;
  //启用备份数据库

  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

//  Result := 'Select pl.*,(P_MValue-P_PValue) As P_NetWeight,' +
//            'ABS((P_MValue-P_PValue)-P_LimValue) As P_Wucha From $PL pl';
  Result := 'Select pl.*,bl.*,so.*,od.*,po.*,(P_MValue-P_PValue - isnull(P_KZValue,0)) As P_NetWeight,' +
            'case when (pl.P_PDate IS not null) and (pl.P_PDate IS not null)'+
            ' then (case when pl.P_PDate > pl.P_MDate then pl.P_PDate else'+
            ' pl.P_MDate end) else null end as P_NetDate,'+
            ' case when pl.P_Type = ''P'' then pl.P_BDAX else null end as P_BDAXView,'+
            'ABS((P_MValue-P_PValue)-P_LimValue) As P_Wucha From $PL pl' +
            ' Left Join $BL bl On ((bl.L_ID=pl.P_Bill) or (bl.L_ID=pl.P_OrderBak) )'+
            ' Left Join $SO so On so.O_Order=bl.L_ZhiKa'+
            ' Left Join $OD od On ((od.D_ID=pl.P_Order) or (od.D_ID=pl.P_OrderBak) )'+
            ' Left Join $PO po On po.O_ID=od.D_OID';
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

  if Check1.Checked then
       Result := MacroValue(Result, [MI('$PL', sTable_PoundBak),
       MI('$BL', sTable_Bill),
       MI('$SO', sTable_SalesOrder),
       MI('$OD', sTable_OrderDtl),
       MI('$PO', sTable_Order)])
  else Result := MacroValue(Result, [MI('$PL', sTable_PoundLog),
       MI('$BL', sTable_Bill),
       MI('$SO', sTable_SalesOrder),
       MI('$OD', sTable_OrderDtl),
       MI('$PO', sTable_Order)]);

  Result := MacroValue(Result, [MI('$S', Date2Str(FStart)),
            MI('$E', Date2Str(FEnd+1))]);
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
end;

procedure TfFramePoundQuery.AfterInitFormData;
begin
  FJBWhere := '';
end;

//Desc: 日期筛选
procedure TfFramePoundQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFramePoundQuery.EditTruckPropertiesButtonClick(Sender: TObject;
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

procedure TfFramePoundQuery.Check1Click(Sender: TObject);
begin
  BtnRefresh.Click;
end;

//------------------------------------------------------------------------------
//Desc: 权限控制
procedure TfFramePoundQuery.PMenu1Popup(Sender: TObject);
begin
  N3.Enabled := BtnPrint.Enabled and (not Check1.Checked);
end;

//Desc: 打印磅单
procedure TfFramePoundQuery.N3Click(Sender: TObject);
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
procedure TfFramePoundQuery.N2Click(Sender: TObject);
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
procedure TfFramePoundQuery.BtnDelClick(Sender: TObject);
var nIdx: Integer;
    nStr,nID,nP,nInStr: string;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint);
    Exit;
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;
  nStr := Format('确定要删除编号为[ %s ]的过磅单吗?', [nID]);
  if not QueryDlg(nStr, sAsk) then Exit;

  {$IFDEF SyncDataByWSDL}
  nList := TStringList.Create;
  nList.Values['ID'] := SQLQuery.FieldByName('P_ID').AsString;
  nList.Values['Delete'] := sFlag_Yes;

  nInStr := PackerEncodeStr(nList.Text);
  try
    if SQLQuery.FieldByName('P_Type').AsString = sFlag_Sale then
    begin
      nStr := '销售单据请在发货明细进行删除';
      ShowMsg(nStr, sHint);
      Exit;
    //xxxxx
    end
    else
    begin
      if SQLQuery.FieldByName('P_PoundIdx').AsInteger > 0  then//备品备件
      begin
        if not SyncHhOtherOrderDataWSDL(nInStr) then
        begin
          ShowMsg('作废失败',sHint);
          Exit;
        end;
      end
      else
      begin
        nStr := 'Select O_IfNeiDao From %s a , %s b' +
        ' where a.O_ID = b.D_OID and  b.D_ID = ''%s''';
        //xxxxx

        nStr := Format(nStr, [sTable_Order, sTable_OrderDtl,
                              SQLQuery.FieldByName('P_OrderBak').AsString]);

        with FDM.QueryTemp(nStr) do
        begin
          if RecordCount < 1 then
          begin
            nStr := Format('未找到磅单[ %s ]对应的采购单据,无法作废', [nID]);
            ShowMsg(nStr, sHint);
            Exit;
          end;
          if Fields[0].AsString = sFlag_Yes then
          begin
            if not SyncHhNdOrderDataWSDL(nInStr) then
            begin
              ShowMsg('作废失败',sHint);
              Exit;
            end;
          end
          else
          begin
            if not SyncHhOrderDataWSDL(nInStr) then
            begin
              ShowMsg('作废失败',sHint);
              Exit;
            end;
          end;
        end;
      end;
    end;
  finally
    nList.Free;
  end;
  {$ENDIF}

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
procedure TfFramePoundQuery.N4Click(Sender: TObject);
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

procedure TfFramePoundQuery.N9Click(Sender: TObject);
var nPID, nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nPID := SQLQuery.FieldByName('P_ID').AsString;
    nStr := Format('确认上传编号为[ %s ]的过磅单吗?', [nPID]);
    if not QueryDlg(nStr, sHint) then Exit;

    if SQLQuery.FieldByName('P_BDAX').AsString = '1' then
    begin
      nStr := Format('过磅单[ %s ]已经上传成功,禁止上传', [nPID]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    {$IFNDEF UseWXERP}
      if SQLQuery.FieldByName('P_Type').AsString = sFlag_Sale then
      begin
        nStr := '销售单据请在发货明细进行上传';
        ShowMsg(nStr, sHint);
        Exit;
      //xxxxx
      end
      else
      begin
        if SQLQuery.FieldByName('P_PoundIdx').AsInteger > 0  then//备品备件
        begin
          if not SyncHhOtherOrderData(nPID) then
          begin
            ShowMsg('上传失败',sHint);
            Exit;
          end;
        end
        else
        begin
          nStr := 'Select O_IfNeiDao From %s a , %s b' +
          ' where a.O_ID = b.D_OID and  b.D_ID = ''%s''';
          //xxxxx

          nStr := Format(nStr, [sTable_Order, sTable_OrderDtl,
                                SQLQuery.FieldByName('P_OrderBak').AsString]);

          with FDM.QueryTemp(nStr) do
          begin
            if RecordCount < 1 then
            begin
              nStr := Format('未找到磅单[ %s ]对应的采购单据,无法上传', [nPID]);
              ShowMsg(nStr, sHint);
              Exit;
            end;
            if Fields[0].AsString = sFlag_Yes then
            begin
              if not SyncHhNdOrderData(nPID) then
              begin
                ShowMsg('上传失败',sHint);
                Exit;
              end;
            end
            else
            begin
              if not SyncHhOrderData(nPID) then
              begin
                ShowMsg('上传失败',sHint);
                Exit;
              end;
            end;
          end;
        end;
      end;
    {$ELSE}
      GetLoginToken(gSysParam.FWXZhangHu,gSysParam.FWXMiMa);
      if not SyncWXPoundKW(nPID) then
      begin
        ShowMsg('上传失败',sHint);
        Exit;
      end;
    {$ENDIF}
    ShowMsg('上传成功',sHint);
    InitFormData('');
  end;
end;

function TfFramePoundQuery.DeleteDirectory(nDir :String): boolean;
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

procedure TfFramePoundQuery.N10Click(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要勘误的记录', sHint);
    Exit;
  end;
  {$IFNDEF UseWXERP}
  if SQLQuery.FieldByName('P_Type').AsString = sFlag_Sale then
  begin
    nStr := '销售单据请在提货查询进行勘误';
    ShowMsg(nStr, sHint);
    Exit;
  //xxxxx
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;

  nList := TStringList.Create;
  try
    nList.Add(nID);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;
    if SQLQuery.FieldByName('P_PoundIdx').AsInteger > 0 then
      CreateBaseFormItem(cFI_FormPoundKwOther, '', @nP)
    else
      CreateBaseFormItem(cFI_FormPoundKw, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;

  finally
    nList.Free;
  end;
  {$ELSE}
    nID := SQLQuery.FieldByName('P_ID').AsString;

    nList := TStringList.Create;
    try
      nList.Add(nID);

      nP.FCommand := cCmd_EditData;
      nP.FParamA := nList.Text;

      CreateBaseFormItem(cFI_FormPound_WxKw, '', @nP);

      if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
      begin
        InitFormData(FWhere);
      end;

    finally
      nList.Free;
    end;
  {$ENDIF}

end;

procedure TfFramePoundQuery.chkTimePropertiesChange(Sender: TObject);
begin
  InitFormData('');
end;

procedure TfFramePoundQuery.N12Click(Sender: TObject);
var nStr,nID,nPreFix,nOrder: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要勘误的记录', sHint);
    Exit;
  end;

  nPreFix := 'WY';
  nStr := 'Select B_Prefix From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nPreFix := Fields[0].AsString;
  end;

  nOrder := '';
  nStr := 'Select L_ZhiKa From %s ' +
          'Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, SQLQuery.FieldByName('P_OrderBak').AsString]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nOrder := Fields[0].AsString;
  end;

  if Pos(nPreFix,nOrder) <= 0 then
  begin
    ShowMsg('所选记录非矿山外运磅单', sHint);
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

procedure TfFramePoundQuery.N14Click(Sender: TObject);
var nPID, nStr, nInStr: string;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nPID := SQLQuery.FieldByName('P_ID').AsString;
    nStr := Format('确认上传编号为[ %s ]的过磅单吗?', [nPID]);
    if not QueryDlg(nStr, sHint) then Exit;

    nList := TStringList.Create;
    nList.Values['ID'] := SQLQuery.FieldByName('P_ID').AsString;
    nInStr := PackerEncodeStr(nList.Text);
    try
      if SQLQuery.FieldByName('P_Type').AsString = sFlag_Sale then
      begin
        nStr := '销售单据请在发货明细进行上传';
        ShowMsg(nStr, sHint);
        Exit;
      //xxxxx
      end
      else
      begin
        if SQLQuery.FieldByName('P_PoundIdx').AsInteger > 0  then//备品备件
        begin
          if not SyncHhOtherOrderDataWSDL(nInStr) then
          begin
            ShowMsg('上传失败',sHint);
            Exit;
          end;
        end
        else
        begin
          nStr := 'Select O_IfNeiDao From %s a , %s b' +
          ' where a.O_ID = b.D_OID and  b.D_ID = ''%s''';
          //xxxxx

          nStr := Format(nStr, [sTable_Order, sTable_OrderDtl,
                                SQLQuery.FieldByName('P_OrderBak').AsString]);

          with FDM.QueryTemp(nStr) do
          begin
            if RecordCount < 1 then
            begin
              nStr := Format('未找到磅单[ %s ]对应的采购单据,无法上传', [nPID]);
              ShowMsg(nStr, sHint);
              Exit;
            end;
            if Fields[0].AsString = sFlag_Yes then
            begin
              if not SyncHhNdOrderDataWSDL(nInStr) then
              begin
                ShowMsg('上传失败',sHint);
                Exit;
              end;
            end
            else
            begin
              if not SyncHhOrderDataWSDL(nInStr) then
              begin
                ShowMsg('上传失败',sHint);
                Exit;
              end;
            end;
          end;
        end;
      end;
      ShowMsg('上传成功',sHint);
      InitFormData('');
    finally
      nList.Free;
    end;
  end;
end;

procedure TfFramePoundQuery.N15Click(Sender: TObject);
var nStr,nID: string;
    nList: TStrings;
    nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要勘误的记录', sHint);
    Exit;
  end;

  if SQLQuery.FieldByName('P_Type').AsString = sFlag_Sale then
  begin
    nStr := '销售单据请在提货查询进行勘误';
    ShowMsg(nStr, sHint);
    Exit;
  //xxxxx
  end;

  nID := SQLQuery.FieldByName('P_ID').AsString;

  nList := TStringList.Create;
  try
    nList.Add(nID);

    nP.FCommand := cCmd_EditData;
    nP.FParamA := nList.Text;

    if SQLQuery.FieldByName('P_PoundIdx').AsInteger > 0 then
      CreateBaseFormItem(cFI_FormPoundKwOther, '', @nP)
    else
      CreateBaseFormItem(cFI_FormPoundKw, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  finally
    nList.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePoundQuery, TfFramePoundQuery.FrameID);
end.
