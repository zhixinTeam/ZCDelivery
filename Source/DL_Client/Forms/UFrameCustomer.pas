{*******************************************************************************
  作者: dmzn@163.com 2009-6-11
  描述: 客户管理
*******************************************************************************}
unit UFrameCustomer;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameCustomer = class(TfFrameNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
  private
    { Private declarations }
    FListA: TStrings;
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //创建释放
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormWait, USysBusiness,
  UBusinessPacker, USysConst, USysDB, USysLoger;

class function TfFrameCustomer.FrameID: integer;
begin
  Result := cFI_FrameCustomer;
end;

procedure TfFrameCustomer.OnCreateFrame;
begin
  inherited;
  FListA := TStringList.Create;
end;

procedure TfFrameCustomer.OnDestroyFrame;
begin
  FListA.Free;
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameCustomer.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select cus.*,S_Name From $Cus cus' +
            ' Left Join $Sale On S_ID=cus.C_SaleMan';
  //xxxxx

  if nWhere = '' then
       Result := Result + ' Where C_XuNi<>''$Yes'''
  else Result := Result + ' Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$Cus', sTable_Customer),
            MI('$Sale', sTable_Salesman), MI('$Yes', sFlag_Yes)]);
  //xxxxx
end;

//Desc: 关闭
procedure TfFrameCustomer.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormCustomer, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFrameCustomer.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormCustomer, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameCustomer.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('C_ID').AsString;
  CreateBaseFormItem(cFI_FormCustomer, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除
procedure TfFrameCustomer.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('C_Name').AsString;
  if not QueryDlg('确定要删除名称为[ ' + nStr + ' ]的客户吗', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := SQLQuery.FieldByName('C_ID').AsString;
    nSQL := 'Delete From %s Where C_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Customer, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
    nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_CustomerItem, nStr]);
    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('已成功删除记录', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除记录失败', '未知错误');
  end;
end;

//Desc: 查看内容
procedure TfFrameCustomer.cxView1DblClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := SQLQuery.FieldByName('C_ID').AsString;
    CreateBaseFormItem(cFI_FormCustomer, PopedomItem, @nParam);
  end;
end;

//Desc: 执行查询
procedure TfFrameCustomer.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    if EditID.Text = '' then Exit;

    FWhere := 'C_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'C_Name like ''%%%s%%'' Or C_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------

procedure TfFrameCustomer.PMenu1Popup(Sender: TObject);
begin
  {$IFDEF SyncRemote}
  N3.Visible := True;
  N4.Visible := True;
  {$ELSE}
  N3.Visible := False;
  N4.Visible := False;
  {$ENDIF}

  {$IFDEF MicroMsg}
  N6.Enabled := BtnEdit.Enabled;
  N7.Enabled := BtnEdit.Enabled;
  {$ELSE}
  N6.Visible := False;
  N7.Visible := False;
  {$ENDIF}
end;


//Desc: 快捷菜单
procedure TfFrameCustomer.N2Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: FWhere := Format('IsNull(C_XuNi, '''')=''%s''', [sFlag_Yes]);
    20: FWhere := '1=1';
  end;

  InitFormData(FWhere);
end;

procedure TfFrameCustomer.N4Click(Sender: TObject);
begin
  ShowWaitForm(ParentForm, '正在同步,请稍后');
  try
    {$IFDEF SyncDataByWSDL}
    if not SyncSCustomerWSDL('') then
    begin
      ShowMsg('同步失败',sHint);
      Exit;
    end;
    {$ELSE}
    if not SyncSCustomer('') then
    begin
      ShowMsg('同步失败',sHint);
      Exit;
    end;
    {$ENDIF}
    ShowMsg('同步完成',sHint);
    InitFormData('');
  finally
    CloseWaitForm;
  end;   
end;

//------------------------------------------------------------------------------
//Desc: 关联商城账户
procedure TfFrameCustomer.N6Click(Sender: TObject);
var nStr:string;
    nP: TFormCommandParam;
    nID,nName,nBindID,nAccount:string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要开通的记录', sHint);
    Exit;
  end;

  nAccount := SQLQuery.FieldByName('C_WeiXin').AsString;
  if nAccount <> '' then
  begin
    ShowMsg('商城账户[' + nAccount + ']已存在',sHint);
    Exit;
  end;

  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormGetWXAccount, PopedomItem, @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  nBindID  := nP.FParamB;
  nAccount := nP.FParamC;
  nID      := SQLQuery.FieldByName('C_ID').AsString;
  nName    := SQLQuery.FieldByName('C_Name').AsString;

  with FListA do
  begin
    Clear;
    Values['Action']   := 'add';
    Values['BindID']   := nBindID;
    Values['Account']  := nAccount;
    Values['CusID']    := nID;
    Values['CusName']  := nName;
  end;

  if edit_shopclients(PackerEncodeStr(FListA.Text)) <> sFlag_Yes then Exit;
  //call remote

  nStr := 'update %s set C_WeiXin=''%s'' where C_ID=''%s''';
  nStr := Format(nStr,[sTable_Customer, nAccount, nID]);
  FDM.ExecuteSQL(nStr);

  ShowMsg('关联商城账户成功',sHint);
  InitFormData(FWhere);
end;

//Desc: 取消关联商城账户
procedure TfFrameCustomer.N7Click(Sender: TObject);
var nStr:string;
    nID,nName,nAccount:string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要取消的记录', sHint);
    Exit;
  end;

  nAccount := SQLQuery.FieldByName('C_WeiXin').AsString;
  nID := SQLQuery.FieldByName('C_ID').AsString;
  nName := SQLQuery.FieldByName('C_Name').AsString;

  with FListA do
  begin
    Clear;
    Values['Action']   := 'del';
    Values['Account']  := nAccount;
    Values['CusID']    := nID;
    Values['CusName']  := nName;
  end;

  if edit_shopclients(PackerEncodeStr(FListA.Text)) <> sFlag_Yes then Exit;
  //call remote

  nStr := 'update %s set C_WeiXin=Null where C_ID=''%s''';
  nStr := Format(nStr,[sTable_Customer, nID]);
  FDM.ExecuteSQL(nStr);

  InitFormData(FWhere);
  ShowMsg('取消商城关联成功！', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameCustomer, TfFrameCustomer.FrameID);
end.
