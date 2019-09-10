{*******************************************************************************
  作者: dmzn@163.com 2013-12-05
  描述: 管理性能参数
*******************************************************************************}
unit UFormPerform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrParam, UFormBase, ExtCtrls, StdCtrls;

type
  TfFormPerform = class(TBaseForm)
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
    EditInterval: TEdit;
    Label5: TLabel;
    EditTCP: TEdit;
    Label6: TLabel;
    EditSizeSAP: TEdit;
    Label7: TLabel;
    EditSizeConn: TEdit;
    Label8: TLabel;
    EditSizeBus: TEdit;
    Label9: TLabel;
    EditRecord: TEdit;
    Label11: TLabel;
    EditHttp: TEdit;
    EditBehConn: TComboBox;
    EditBehBus: TComboBox;
    Label10: TLabel;
    Label12: TLabel;
    procedure ListParamClick(Sender: TObject);
    procedure EditIDChange(Sender: TObject);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FParams: array of TPerformParam;
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

class function TfFormPerform.CreateForm(const nPopedom: string;
  const nParam: Pointer): TFormCreateResult;
var nStr: string;
begin
  Result := inherited CreateForm(nPopedom, nParam);
  if Assigned(nParam) then
       nStr := PFormCommandParam(nParam).FParamA
  else nStr := '';

  with TfFormPerform.Create(Application) do
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

class function TfFormPerform.FormID: integer;
begin
  Result := cFI_FormPerform;
end;

//------------------------------------------------------------------------------
procedure TfFormPerform.LoadParams;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptPerform);
    SetLength(FParams, nList.Count);

    for nIdx:=0 to nList.Count - 1 do
      FParams[nIdx] := gParamManager.GetPerform(nList[nIdx])^;
    //xxxxx
  finally
    nList.Free;
  end;
end;

procedure TfFormPerform.InitFormData(const nID: string);
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
procedure TfFormPerform.EditIDKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in cParamIDCharacters) then
  begin
    Key := #0;
  end;
end;

procedure TfFormPerform.ListParamClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListParam.ItemIndex < 0 then Exit;
  nIdx := Integer(ListParam.Items.Objects[ListParam.ItemIndex]);

  with FParams[nIdx] do
  begin
    EditID.Text := FID;
    EditName.Text := FName;
    EditTCP.Text := IntToStr(FPortTCP);
    EditHttp.Text := IntToStr(FPortHttp);

    EditSizeConn.Text := IntToStr(FPoolSizeConn);
    EditSizeBus.Text := IntToStr(FPoolSizeBusiness);
    EditBehConn.ItemIndex := FPoolBehaviorConn;
    EditBehBus.ItemIndex := FPoolBehaviorBusiness;

    EditSizeSAP.Text := IntToStr(FPoolSizeSAP);
    EditInterval.Text := IntToStr(FMonInterval);
    EditRecord.Text := IntToStr(FMaxRecordCount);
  end;
end;

procedure TfFormPerform.EditIDChange(Sender: TObject);
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

    if Sender = EditTCP then
    begin
      if not IsNumber(EditTCP.Text, False) then Exit;
      FPortTCP := StrToInt(EditTCP.Text);
    end else

    if Sender = EditHttp then
    begin
      if not IsNumber(EditHttp.Text, False) then Exit;
      FPortHttp := StrToInt(EditHttp.Text);
    end else

    if Sender = EditSizeConn then
    begin
      if not IsNumber(EditSizeConn.Text, False) then Exit;
      FPoolSizeConn := StrToInt(EditSizeConn.Text);
    end else

    if Sender = EditSizeBus then
    begin
      if not IsNumber(EditSizeBus.Text, False) then Exit;
      FPoolSizeBusiness := StrToInt(EditSizeBus.Text);
    end else

    if Sender = EditSizeSAP then
    begin
      if not IsNumber(EditSizeSAP.Text, False) then Exit;
      FPoolSizeSAP := StrToInt(EditSizeSAP.Text);
    end else

    if Sender = EditBehConn then
    begin
      if EditBehConn.ItemIndex < 0 then
        EditBehConn.ItemIndex := 0;
      FPoolBehaviorConn := EditBehConn.ItemIndex;
    end else
    
    if Sender = EditBehBus then
    begin
      if EditBehBus.ItemIndex < 0 then
        EditBehBus.ItemIndex := 0;
      FPoolBehaviorBusiness := EditBehBus.ItemIndex;
    end else

    if Sender = EditRecord then
    begin
      if not IsNumber(EditRecord.Text, False) then Exit;
      FMaxRecordCount := StrToInt(EditRecord.Text);
    end else

    if Sender = EditInterval then
    begin
      if not IsNumber(EditInterval.Text, False) then Exit;
      FMonInterval := StrToInt(EditInterval.Text);
    end;

    BtnOK.Enabled := BtnAdd.Enabled;
  end;
end;

procedure TfFormPerform.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nPer: TPerformParam;
begin
  for nIdx:=Low(FParams) to High(FParams) do
   if FParams[nIdx].FEnable and (FParams[nIdx].FID = 'new_perform') then Exit;
  //has exits

  gParamManager.InitPerform(nPer);
  nPer.FID := 'new_perform';
  nPer.FName := '新建配置';

  nIdx := Length(FParams);
  SetLength(FParams, nIdx + 1);

  FParams[nIdx] := nPer;
  FParams[nIdx].FEnable := True;

  BtnOK.Enabled := True;
  InitFormData(nPer.FID);
end;

procedure TfFormPerform.BtnDelClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  if ListParam.ItemIndex < 0 then Exit;
  nIdx := Integer(ListParam.Items.Objects[ListParam.ItemIndex]);

  nStr := Format('确定要删除名称为[ %s ]的配置吗?', [FParams[nIdx].FName]);
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
function TfFormPerform.IsParamValid(const nID: string): Boolean;
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

procedure TfFormPerform.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    gParamManager.LoadParam(nList, ptPerform);
    for nIdx:=nList.Count - 1 downto 0 do
     if not IsParamValid(nList[nIdx]) then
      gParamManager.DelPerform(nList[nIdx]);
    //delete valid
  finally
    nList.Free;
  end;

  for nIdx:=Low(FParams) to High(FParams) do
   if FParams[nIdx].FEnable then
    gParamManager.AddPerform(FParams[nIdx]);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormPerform, TfFormPerform.FormID);
end.
