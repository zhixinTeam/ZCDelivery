{*******************************************************************************
  作者: dmzn@163.com 2013-12-05
  描述: 管理SAP参数
*******************************************************************************}
unit UFormParamSAP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrParam, USAPConnection, UFormBase, ExtCtrls, StdCtrls;

type
  TfFormParamSAP = class(TBaseForm)
    ListParam: TListBox;
    BtnAdd: TButton;
    BtnDel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditID: TEdit;
    Label3: TLabel;
    EditName: TEdit;
    Bevel1: TBevel;
    BtnExit: TButton;
    BtnOK: TButton;
    Label4: TLabel;
    EditUser: TEdit;
    Label5: TLabel;
    EditPwd: TEdit;
    Label6: TLabel;
    EditLang: TEdit;
    Label7: TLabel;
    EditNum: TEdit;
    Label8: TLabel;
    EditClient: TEdit;
    Label9: TLabel;
    EditPage: TEdit;
    Label10: TLabel;
    EditServer: TEdit;
    Label11: TLabel;
    EditSystem: TEdit;
    procedure ListParamClick(Sender: TObject);
    procedure EditIDChange(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FParams: array of TSAPParam;
    //参数缓存
    procedure LoadParams;
    procedure InitFormData(const nID: string);
    //界面数据
    function IsParamValid(const nID: string): Boolean;
    //校正判定
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TFormCreateResult; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UMITConst;

class function TfFormParamSAP.CreateForm(const nPopedom: string;
  const nParam: Pointer): TFormCreateResult;
var nStr: string;
begin
  Result := inherited CreateForm(nPopedom, nParam);
  if Assigned(nParam) then
       nStr := PFormCommandParam(nParam).FParamA
  else nStr := '';

  with TfFormParamSAP.Create(Application) do
  try
    BtnAdd.Enabled := gSysParam.FIsAdmin;
    BtnDel.Enabled := gSysParam.FIsAdmin;
    BtnOK.Enabled := False;

    LoadParams;
    InitFormData(nStr);
    Result.FModalResult := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormParamSAP.FormID: integer;
begin
  Result := cFI_FormSAP;
end;

//------------------------------------------------------------------------------
procedure TfFormParamSAP.LoadParams;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptSAP);
    SetLength(FParams, nList.Count);

    for nIdx:=0 to nList.Count - 1 do
      FParams[nIdx] := gParamManager.GetSAP(nList[nIdx])^;
    //xxxxx
  finally
    nList.Free;
  end;
end;

procedure TfFormParamSAP.InitFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
begin
  ListParam.Clear;
  for nIdx:=Low(FParams) to High(FParams) do
  if FParams[nIdx].FEnable then
  begin
    nStr := Format('%d.%s', [ListParam.Items.Count+1, FParams[nIdx].FName]);
    ListParam.Items.AddObject(nStr, Pointer(nIdx));

    if FParams[nIdx].FID = nID then
    begin
      ListParam.ItemIndex := ListParam.Items.Count - 1;
      ListParamClick(nil);
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormParamSAP.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in cParamIDCharacters) then
  begin
    Key := #0;
  end;
end;

procedure TfFormParamSAP.ListParamClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListParam.ItemIndex < 0 then Exit;
  nIdx := Integer(ListParam.Items.Objects[ListParam.ItemIndex]);

  with FParams[nIdx] do
  begin
    EditID.Text := FID;
    EditName.Text := FName;
    EditServer.Text := FHost;
    EditUser.Text := FUser;
    EditPwd.Text := FPwd;

    EditSystem.Text := FSystem;
    EditNum.Text := IntToStr(FSysNum);
    EditClient.Text := FClient;
    EditLang.Text := FLang;
    EditPage.Text := FCodePage;
  end;
end;

procedure TfFormParamSAP.EditIDChange(Sender: TObject);
var nIdx: Integer;
begin
  if ActiveControl <> Sender then Exit;
  if ListParam.ItemIndex < 0 then Exit;
  nIdx := Integer(ListParam.Items.Objects[ListParam.ItemIndex]);

  with FParams[nIdx] do
  begin
    if Sender = EditID then
    begin
      if EditID.Text = '' then Exit;
      FID := EditID.Text;
    end else

    if Sender = EditName then
    begin
      if EditName.Text = '' then Exit;
      FName := EditName.Text;
      InitFormData(FID);
    end else

    if Sender = EditServer then
    begin
      FHost := EditServer.Text;
    end else

    if Sender = EditUser then
    begin
      FUser := EditUser.Text;
    end else

    if Sender = EditPwd then
    begin
      FPwd := EditPwd.Text;
    end else

    if Sender = EditSystem then
    begin
      FSystem := EditSystem.Text
    end;

    if Sender = EditNum then
    begin
      if not IsNumber(EditNum.Text, False) then Exit;
      FSysNum := StrToInt(EditNum.Text);
    end else

    if Sender = EditClient then
    begin
      FClient := EditClient.Text;
    end else

    if Sender = EditLang then
    begin
      FLang := EditLang.Text;
    end else

    if Sender = EditPage then
    begin
      FCodePage := EditPage.Text;
    end;

    BtnOK.Enabled := BtnAdd.Enabled;
  end;
end;

procedure TfFormParamSAP.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nSAP: TSAPParam;
begin
  for nIdx:=Low(FParams) to High(FParams) do
   if FParams[nIdx].FEnable and (FParams[nIdx].FID = 'new_sap') then Exit;
  //has exits

  gParamManager.InitSAP(nSAP);
  nSAP.FID := 'new_sap';
  nSAP.FName := '新建SAP';

  nIdx := Length(FParams);
  SetLength(FParams, nIdx + 1);

  FParams[nIdx] := nSAP;
  FParams[nIdx].FEnable := True;

  BtnOK.Enabled := True;
  InitFormData(nSAP.FID);
end;

procedure TfFormParamSAP.BtnDelClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  if ListParam.ItemIndex < 0 then Exit;
  nIdx := Integer(ListParam.Items.Objects[ListParam.ItemIndex]);

  nStr := Format('确定要删除名称为[ %s ]的SAP配置吗?', [FParams[nIdx].FName]);
  if QueryDlg(nStr, sAsk, Handle) then
  begin
    FParams[nIdx].FEnable := False;
    BtnOK.Enabled := True;

    Dec(nIdx);
    if nIdx >= Low(FParams) then
    begin
      InitFormData(FParams[nIdx].FID);
      Exit;
    end;

    Inc(nIdx, 2);
    if nIdx <= High(FParams) then
      InitFormData(FParams[nIdx].FID);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
//Desc: 判定nID是否在FPacks中
function TfFormParamSAP.IsParamValid(const nID: string): Boolean;
var nIdx: Integer;
begin
  for nIdx:=Low(FParams) to High(FParams) do
  if FParams[nIdx].FEnable and (FParams[nIdx].FID = nID) then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
end;

procedure TfFormParamSAP.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptSAP);
    for nIdx:=nList.Count - 1 downto 0 do
     if not IsParamValid(nList[nIdx]) then
      gParamManager.DelSAP(nList[nIdx]);
    //delete valid
  finally
    nList.Free;
  end;

  for nIdx:=Low(FParams) to High(FParams) do
   if FParams[nIdx].FEnable then
    gParamManager.AddSAP(FParams[nIdx]);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormParamSAP, TfFormParamSAP.FormID);
end.
