{*******************************************************************************
  作者: dmzn@163.com 2013-12-05
  描述: 管理参数包
*******************************************************************************}
unit UFormPack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrParam, UFormBase, ExtCtrls, StdCtrls;

type
  TfFormPack = class(TBaseForm)
    ListPack: TListBox;
    BtnAdd: TButton;
    BtnDel: TButton;
    Label1: TLabel;
    EditDB: TComboBox;
    Label2: TLabel;
    EditID: TEdit;
    Label3: TLabel;
    EditName: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    EditSAP: TComboBox;
    Label6: TLabel;
    EditPerform: TComboBox;
    Bevel1: TBevel;
    BtnExit: TButton;
    BtnOK: TButton;
    procedure ListPackClick(Sender: TObject);
    procedure EditIDChange(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FPacks: array of TParamItemPack;
    //参数缓存
    procedure LoadPacks;
    procedure SetListIndex(const nList: TComboBox; const nData: string);
    procedure InitFormData(const nID: string);
    //界面数据
    function IsPackValid(const nID: string): Boolean;
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

class function TfFormPack.CreateForm(const nPopedom: string;
  const nParam: Pointer): TFormCreateResult;
var nStr: string;
begin
  Result := inherited CreateForm(nPopedom, nParam);
  if Assigned(nParam) then
       nStr := PFormCommandParam(nParam).FParamA
  else nStr := '';

  with TfFormPack.Create(Application) do
  try
    BtnAdd.Enabled := gSysParam.FIsAdmin;
    BtnDel.Enabled := gSysParam.FIsAdmin;
    BtnOK.Enabled := False;

    LoadPacks;
    InitFormData(nStr);
    Result.FModalResult := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormPack.FormID: integer;
begin
  Result := cFI_FormPack;
end;

//------------------------------------------------------------------------------
procedure TfFormPack.LoadPacks;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptPack);
    SetLength(FPacks, nList.Count);

    for nIdx:=0 to nList.Count - 1 do
      FPacks[nIdx] := gParamManager.GetParamPack(nList[nIdx])^;
    //xxxxx
  finally
    nList.Free;
  end;

  gParamManager.LoadParam(EditDB.Items, ptDB);
  gParamManager.LoadParam(EditSAP.Items, ptSAP);
  gParamManager.LoadParam(EditPerform.Items, ptPerform);

  EditDB.Items.Insert(0, '');
  EditSAP.Items.Insert(0, '');
  EditPerform.Items.Insert(0, '');

  for nIdx:=EditDB.Items.Count - 1 downto 1 do
  begin
    nStr := gParamManager.GetDB(EditDB.Items[nIdx]).FName;
    nStr := StrWithWidth(EditDB.Items[nIdx], 5, 1) + ' - ' + nStr;
    EditDB.Items[nIdx] := nStr;
  end;

  for nIdx:=EditSAP.Items.Count - 1 downto 1 do
  begin
    nStr := gParamManager.GetSAP(EditSAP.Items[nIdx]).FName;
    nStr := StrWithWidth(EditSAP.Items[nIdx], 5, 1) + ' - ' + nStr;
    EditSAP.Items[nIdx] := nStr;
  end;

  for nIdx:=EditPerform.Items.Count - 1 downto 1 do
  begin
    nStr := gParamManager.GetPerform(EditPerform.Items[nIdx]).FName;
    nStr := StrWithWidth(EditPerform.Items[nIdx], 5, 1) + ' - ' + nStr;
    EditPerform.Items[nIdx] := nStr;
  end;
end;

procedure TfFormPack.SetListIndex(const nList: TComboBox; const nData: string);
var nIdx,nPos: Integer;
begin
  for nIdx:=nList.Items.Count - 1 downto 0 do
  begin
    nPos := Pos(' - ', nList.Items[nIdx]) - 1;
    if Trim(Copy(nList.Items[nIdx], 1, nPos)) = nData then
    begin
      nList.ItemIndex := nIdx;
      Exit;
    end;
  end;

  nList.ItemIndex := -1;
end;

procedure TfFormPack.InitFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
begin
  ListPack.Clear;
  for nIdx:=Low(FPacks) to High(FPacks) do
  if FPacks[nIdx].FEnable then
  begin
    nStr := Format('%d.%s', [ListPack.Items.Count+1, FPacks[nIdx].FName]);
    ListPack.Items.AddObject(nStr, Pointer(nIdx));

    if FPacks[nIdx].FID = nID then
    begin
      ListPack.ItemIndex := ListPack.Items.Count - 1;
      ListPackClick(nil);
    end;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormPack.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in cParamIDCharacters) then
  begin
    Key := #0;
  end;
end;

procedure TfFormPack.ListPackClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListPack.ItemIndex < 0 then Exit;
  nIdx := Integer(ListPack.Items.Objects[ListPack.ItemIndex]);

  with FPacks[nIdx] do
  begin
    EditID.Text := FID;
    EditName.Text := FName;

    SetListIndex(EditDB, FNameDB);
    SetListIndex(EditSAP, FNameSAP);
    SetListIndex(EditPerform, FNamePerform);
  end;
end;

procedure TfFormPack.EditIDChange(Sender: TObject);
var nIdx: Integer;
begin
  if ActiveControl <> Sender then Exit;
  if ListPack.ItemIndex < 0 then Exit;
  nIdx := Integer(ListPack.Items.Objects[ListPack.ItemIndex]);

  with FPacks[nIdx] do
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

    if Sender = EditDB then
    begin
      FNameDB := Trim(Copy(EditDB.Text, 1, Pos(' - ', EditDB.Text) - 1));
    end else

    if Sender = EditSAP then
    begin
      FNameSAP := Trim(Copy(EditSAP.Text, 1, Pos(' - ', EditSAP.Text) - 1));
    end else

    if Sender = EditPerform then
    begin
      FNamePerform := Copy(EditPerform.Text, 1, Pos(' - ', EditPerform.Text) - 1);
      FNamePerform := Trim(FNamePerform);
    end;

    BtnOK.Enabled := BtnAdd.Enabled;
  end;
end;

procedure TfFormPack.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nPack: TParamItemPack;
begin
  for nIdx:=Low(FPacks) to High(FPacks) do
   if FPacks[nIdx].FEnable and (FPacks[nIdx].FID = 'new_pack') then Exit;
  //has exits

  gParamManager.InitPack(nPack);
  nPack.FID := 'new_pack';
  nPack.FName := '新建参数组';

  nIdx := Length(FPacks);
  SetLength(FPacks, nIdx + 1);

  FPacks[nIdx] := nPack;
  FPacks[nIdx].FEnable := True;

  BtnOK.Enabled := True;
  InitFormData(nPack.FID);
end;

procedure TfFormPack.BtnDelClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  if ListPack.ItemIndex < 0 then Exit;
  nIdx := Integer(ListPack.Items.Objects[ListPack.ItemIndex]);

  nStr := Format('确定要删除[ %s ]参数组吗?', [FPacks[nIdx].FName]);
  if QueryDlg(nStr, sAsk, Handle) then
  begin
    FPacks[nIdx].FEnable := False;
    BtnOK.Enabled := True;

    Dec(nIdx);
    if nIdx >= Low(FPacks) then
    begin
      InitFormData(FPacks[nIdx].FID);
      Exit;
    end;

    Inc(nIdx, 2);
    if nIdx <= High(FPacks) then
      InitFormData(FPacks[nIdx].FID);
    //xxxxx
  end;
end;

//------------------------------------------------------------------------------
//Desc: 判定nID是否在FPacks中
function TfFormPack.IsPackValid(const nID: string): Boolean;
var nIdx: Integer;
begin
  for nIdx:=Low(FPacks) to High(FPacks) do
  if FPacks[nIdx].FEnable and (FPacks[nIdx].FID = nID) then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
end;

procedure TfFormPack.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptPack);
    for nIdx:=nList.Count - 1 downto 0 do
     if not IsPackValid(nList[nIdx]) then
      gParamManager.DelPack(nList[nIdx]);
    //delete valid
  finally
    nList.Free;
  end;

  for nIdx:=Low(FPacks) to High(FPacks) do
   if FPacks[nIdx].FEnable then
    gParamManager.AddPack(FPacks[nIdx]);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormPack, TfFormPack.FormID);
end.
