{*******************************************************************************
  作者: dmzn@163.com 2016-10-21
  描述: 办理磁卡
*******************************************************************************}
unit UFrameOtherCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  IniFiles, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameOtherCard = class(TfFrameNormal)
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;                
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item1: TdxLayoutItem;
    EditID: TcxButtonEdit;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
//    procedure cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
//      ALevel: TcxGridLevel);
    procedure BtnRefreshClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FWhereUseDate: Boolean;
    FWhereProvide,FWhereOther: string;
    //查询条件
//    FActiveQuery: TADOQuery;
//    FActiveView: TcxGridDBTableView;
    //活动页面
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
//    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    procedure AfterInitFormData; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysBusiness, UBusinessConst, UFormBase, USysDataDict,
  USysConst, USysDB, USysGrid, UDataModule, UFormDateFilter, UForminputbox,
  ShellAPI, UFormWait;

//------------------------------------------------------------------------------
class function TfFrameOtherCard.FrameID: integer;
begin
  Result := cFI_FrameQPoundTemp;
end;

procedure TfFrameOtherCard.OnCreateFrame;
begin
  inherited;
  FWhereProvide := '';
  FWhereOther := '';

  FWhereUseDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameOtherCard.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameOtherCard.OnLoadGridConfig(const nIni: TIniFile);
begin
  if BtnAdd.Enabled then
       BtnAdd.Tag := 10
  else BtnAdd.Tag := 0;

  if BtnEdit.Enabled then
       BtnEdit.Tag := 10
  else BtnEdit.Tag := 0;

  if BtnDel.Enabled then
       BtnDel.Tag := 10
  else BtnDel.Tag := 0;
end;

procedure TfFrameOtherCard.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
var nStr: string;
begin
  nDefault := False;
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  //----------------------------------------------------------------------------
  nStr := 'Select co.*,isnull(O_bfmvalue,0)-isnull(O_bfpvalue,0) as O_NetWeight,C_Card,C_Status,C_Freeze,C_Memo From $CO co ' +
          ' Left Join $CD cd On cd.C_Card=co.O_Card ';
  //xxxxx

  if FWhereUseDate then
    nStr := nStr + 'Where (O_Date>=''$ST'' and O_Date <''$End'')';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$CO', sTable_CardOther),
          MI('$CD', sTable_Card),
          MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx

  if FWhereOther <> '' then
  begin
    if FWhereUseDate then
         nStr := nStr + ' And (' + FWhereOther + ')'
    else nStr := nStr + ' Where (' + FWhereOther + ')';
  end;

   if FWhereUseDate then
    FDM.QueryData(SQLQuery, nStr);

  //----------------------------------------------------------------------------
  if (FWhereProvide = '') and (FWhereOther = '') then Exit;
  //非条件查询时,不予切换
end;

procedure TfFrameOtherCard.AfterInitFormData;
begin
  FWhereUseDate := True;
end;

//Desc: 日期筛选
procedure TfFrameOtherCard.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 刷新
procedure TfFrameOtherCard.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  FWhereProvide := '';
  FWhereOther := '';
  InitFormData(FWhere);
end;

//Desc: 供应磁卡
procedure TfFrameOtherCard.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin

end;

//Desc: 临时磁卡
procedure TfFrameOtherCard.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(CFI_FormMakeCardOther, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    FWhereOther := '';
    InitFormData();
  end;
end;

//Desc 删除
procedure TfFrameOtherCard.BtnDelClick(Sender: TObject);
var nStr,nSQL,nCard: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nSQL := SQLQuery.FieldByName('O_Truck').AsString;
  nCard := SQLQuery.FieldByName('O_Card').AsString;

  nStr := '确定要删除车辆[ %s ]的磁卡吗?';
  nStr := Format(nStr, [nSQL]);
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nSQL := 'Delete From %s Where R_ID=%s';
    nSQL := Format(nSQL, [sTable_CardOther, SQLQuery.FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Update %s Set C_Status=''%s'',C_TruckNo='''' ' +
            ' Where C_Card=''%s''';
    nSQL := Format(nSQL, [sTable_Card, sFlag_CardIdle,  nCard]);
    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('删除操作成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

//Desc: 执行查询
procedure TfFrameOtherCard.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhereUseDate := False;
    FWhereProvide := 'cp.R_ID=' + EditID.Text;
    FWhereOther := 'co.R_ID =' + EditID.Text;
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhereProvide := 'P_Card like ''%' + EditCard.Text + '%''';
    FWhereOther := 'O_Card like ''%' + EditCard.Text + '%''';
    InitFormData(FWhere);
    cxGrid1.ActiveLevel := cxLevel1;
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhereProvide := 'P_Truck like ''%' + EditTruck.Text + '%''';
    FWhereOther := 'O_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//Desc: 冻结磁卡
procedure TfFrameOtherCard.N8Click(Sender: TObject);
begin
  FWhere := 'C_Freeze=''%s''';
  FWhere := Format(FWhere, [sFlag_Yes]);

  FWhereProvide := FWhere;
  FWhereOther := FWhere;
  InitFormData(FWhere);
end;

//------------------------------------------------------------------------------
//Desc: 控制菜单项
procedure TfFrameOtherCard.PMenu1Popup(Sender: TObject);
var nStr: string;
    i,nCount: integer;

begin
  nCount := PMenu1.Items.Count - 1;
  for i:=0 to nCount do
    PMenu1.Items[i].Enabled := False;
  //xxxxx

  N1.Enabled := True;
  N17.Enabled := cxView1.DataController.GetSelectedCount > 0;
  N5.Enabled := cxView1.DataController.GetSelectedCount > 0;
  //备注信息
  
  if cxView1.DataController.GetSelectedCount > 0 then
  with SQLQuery do
  begin
    nStr := FieldByName('C_Status').AsString;
    N9.Enabled := nStr = sFlag_CardUsed;
    //使用中的卡可以挂失
    N10.Enabled := nStr = sFlag_CardLoss;
    //已挂失卡可以解挂失
    N11.Enabled := (nStr = sFlag_CardLoss) or (nStr = '');
    //已挂失,或无卡时可以补办卡
    N12.Enabled := (nStr <> sFlag_CardInvalid) and (nStr <> '');
    //可随时销卡

    N3.Enabled := FieldByName('O_YSTDno').AsString<>'';
  end;

  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('C_Freeze').AsString;
    N14.Enabled := nStr <> sFlag_Yes;   //冻结
    N15.Enabled := nStr = sFlag_Yes;    //解除
  end;
end;

//Desc: 挂失磁卡
procedure TfFrameOtherCard.N9Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_CardLoss, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('挂失操作成功', sHint);
end;

//Desc: 解除挂失
procedure TfFrameOtherCard.N10Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除挂失操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_CardUsed, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除挂失操作成功', sHint);
end;

//Desc: 补办磁卡
procedure TfFrameOtherCard.N11Click(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_EditData;
  nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
  
  CreateBaseFormItem(CFI_FormMakeCardOther, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 注销磁卡
procedure TfFrameOtherCard.N12Click(Sender: TObject);
var nStr,nCard: string;
begin
  nCard := SQLQuery.FieldByName('C_Card').AsString;
  nStr := Format('确定要对卡[ %s ]执行销卡操作吗?', [nCard]);
  if not QueryDlg(nStr, sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  with SQLQuery do
  try
    nStr := 'Update %s Set O_Card='''' Where R_ID=%s';
    nStr := Format(nStr, [sTable_CardOther, FieldByName('R_ID').AsString]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, nCard]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('注销操作成功', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

//Desc: 冻结磁卡
procedure TfFrameOtherCard.N14Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Freeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_Yes, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('冻结操作成功', sHint);
end;

//Desc: 解除冻结
procedure TfFrameOtherCard.N15Click(Sender: TObject);
var nStr,nSQL: string;
begin
  nSQL := '确定要对卡[ %s ]执行解除冻结操作吗?';
  nStr := SQLQuery.FieldByName('C_Card').AsString;

  nSQL := Format(nSQL, [nStr]);
  if not QueryDlg(nSQL, sAsk) then Exit;

  nSQL := 'Update %s Set C_Freeze=''%s'' Where C_Card=''%s''';
  nSQL := Format(nSQL, [sTable_Card, sFlag_No, nStr]);
  FDM.ExecuteSQL(nSQL);

  InitFormData(FWhere);
  ShowMsg('解除冻结操作成功', sHint);
end;

//Desc: 修改备注
procedure TfFrameOtherCard.N17Click(Sender: TObject);
var nStr: string;
    nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_EditData;
  nP.FParamA := SQLQuery.FieldByName('C_Memo').AsString;
  nP.FParamB := 500;

  nStr := SQLQuery.FieldByName('C_Card').AsString;
  nP.FParamC := 'Update %s Set C_Memo=''$Memo'' Where C_Card=''%s''';
  nP.FParamC := Format(nP.FParamC, [sTable_Card, nStr]);

  CreateBaseFormItem(cFI_FormMemo, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    InitFormData(FWhere);
  //xxxxx
end;

//Desc: 打印供应单
procedure TfFrameOtherCard.N3Click(Sender: TObject);
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
  nDir := gSysParam.FPicPath + nystdno+'\'+ nTruckno + '\'+ndate+'\';

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

procedure TfFrameOtherCard.N5Click(Sender: TObject);
var
  nStr,nIfFenChe: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('R_ID').AsString;
    PrintOrderReport(nStr, False);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameOtherCard, TfFrameOtherCard.FrameID);
end.
