{*******************************************************************************
  作者: dmzn 2008-9-22
  描述: 修改用户口令
*******************************************************************************}
unit UFormPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxControls,
  cxContainer, cxEdit, cxTextEdit, UFormBase;

type
  TfFormPassword = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditOld: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditNext: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditNew: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, USysPopedom;

//------------------------------------------------------------------------------
class function TfFormPassword.CreateForm;
begin
  Result := nil;

  with TfFormPassword.Create(Application) do
  begin
    //Caption := '修改密码';
    BtnOK.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    ShowModal;
    Free;
  end;
end;

class function TfFormPassword.FormID: integer;
begin
  Result := cFI_FormChangePwd;
end;

//------------------------------------------------------------------------------
//Desc: 保存
procedure TfFormPassword.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if EditOld.Text <> gSysParam.FUserPwd then
  begin
    EditOld.SetFocus;
    ShowMsg('旧密码错误,请重新输入', sHint); Exit;
  end;

  if EditNew.Text <> EditNext.Text then
  begin
    EditNew.SetFocus;
    ShowMsg('两次输入的新密码不一致', '请重试'); Exit;
  end;

  nStr := 'Update %s Set U_PASSWORD=''%s'' Where U_NAME=''%s''';
  nStr := Format(nStr, [sTable_User, EditNew.Text, gSysParam.FUserID]);

  if FDM.ExecuteSQL(nStr, False) > 0 then
  begin
    gSysParam.FUserPwd := EditNew.Text;
    ModalResult := mrOK;
    ShowMsg('新密码已经生效', sHint);
  end else ShowMsg('更新密码时发生未知错误', '保存失败');
end;

initialization
  gControlManager.RegCtrl(TfFormPassword, TfFormPassword.FormID);
end.
