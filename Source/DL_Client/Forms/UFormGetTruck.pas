{*******************************************************************************
  作者: dmzn@163.com 2010-10-17
  描述: 选择车牌号
*******************************************************************************}
unit UFormGetTruck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxCheckBox, Menus,
  cxLabel, cxListView, cxTextEdit, cxMaskEdit, cxButtonEdit,
  dxLayoutControl, StdCtrls;

type
  TfFormGetTruck = class(TfFormNormal)
    EditTruck: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListTruck: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Check1: TcxCheckBox;
    dxLayout1Item3: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListTruckKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListTruckDblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
    function QueryTruck(const nTruck: string): Boolean;
    //查询车辆
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormBase, USysGrid, USysDB, USysConst,
  USysBusiness, UDataModule, UFormInputbox;

class function TfFormGetTruck.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetTruck.Create(Application) do
  try
    Caption := '选择车辆';
    {N1.Enabled := gSysParam.FIsAdmin;
    N2.Enabled := N1.Enabled;
    N4.Enabled := N1.Enabled;
    N5.Enabled := N1.Enabled;}

    EditTruck.Text := nP.FParamA;
    QueryTruck(EditTruck.Text);

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := ListTruck.Items[ListTruck.ItemIndex].Caption;
      nP.FParamC := ListTruck.Items[ListTruck.ItemIndex].SubItems[0];
      nP.FParamD := ListTruck.Items[ListTruck.ItemIndex].SubItems[1];
    end;
  finally
    Free;
  end;
end;

class function TfFormGetTruck.FormID: integer;
begin
  Result := cFI_FormGetTruck;
end;

procedure TfFormGetTruck.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListTruck, nIni);
    Check1.Checked := nIni.ReadBool(Name, 'AllTruck', False);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetTruck.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListTruck, nIni);
    nIni.WriteBool(Name, 'AllTruck', Check1.Checked);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 查询车牌号
function TfFormGetTruck.QueryTruck(const nTruck: string): Boolean;
var nStr: string;
begin
  Result := False;
  if Trim(nTruck) = '' then Exit;
  ListTruck.Items.Clear;

  nStr := 'Select * From %s Where (T_PY Like ''%%%s%%'' or ' +
          'T_Truck Like ''%%%s%%'')';
  nStr := Format(nStr, [sTable_Truck, Trim(nTruck), Trim(nTruck)]);

  if not Check1.Checked then
    nStr := nStr + Format(' And (T_Valid Is Null or T_Valid<>''%s'') ', [sFlag_No]);
  nStr := nStr + ' Order By T_PY';

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      with ListTruck.Items.Add do
      begin
        Caption := FieldByName('T_Truck').AsString;
        SubItems.Add(FieldByName('T_Owner').AsString);
        SubItems.Add(FieldByName('T_Phone').AsString);

        ImageIndex := 11;
        StateIndex := ImageIndex;
      end;

      Next;
    end;
  end;

  Result := ListTruck.Items.Count > 0;
  if Result then
  begin
    ActiveControl := ListTruck;
    ListTruck.ItemIndex := 0;
    ListTruck.ItemFocused := ListTruck.TopItem;
  end;
end;

//Desc: 修改车主姓名
procedure TfFormGetTruck.N1Click(Sender: TObject);
var nStr,nTmp: string;
begin
  if ListTruck.ItemIndex < 0 then Exit;

  while True do
  begin
    nTmp := ListTruck.Items[ListTruck.ItemIndex].SubItems[0];
    if not ShowInputBox('请输入车主姓名:', sHint, nTmp, 32) then Exit;

    nTmp := Trim(nTmp);
    if nTmp <> '' then Break;
  end;

  nStr := 'Update %s Set T_Owner=''%s'' Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTmp,
          ListTruck.Items[ListTruck.ItemIndex].Caption]);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  ListTruck.Items[ListTruck.ItemIndex].SubItems[0] := nTmp;
  ShowMsg('更新成功', sHint);
end;

//Desc: 修改联系方式
procedure TfFormGetTruck.N2Click(Sender: TObject);
var nStr,nTmp: string;
begin
  if ListTruck.ItemIndex < 0 then Exit;

  while True do
  begin
    nTmp := ListTruck.Items[ListTruck.ItemIndex].SubItems[1];
    if not ShowInputBox('请输入车主联系方式:', sHint, nTmp, 15) then Exit;

    nTmp := Trim(nTmp);
    if nTmp <> '' then Break;
  end;

  nStr := 'Update %s Set T_Phone=''%s'' Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTmp,
          ListTruck.Items[ListTruck.ItemIndex].Caption]);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  ListTruck.Items[ListTruck.ItemIndex].SubItems[1] := nTmp;
  ShowMsg('更新成功', sHint);
end;

//Desc: 显/隐车辆
procedure TfFormGetTruck.N4Click(Sender: TObject);
var nStr,nTmp: string;
begin
  if ListTruck.ItemIndex < 0 then Exit;
  if Sender = N4 then
       nTmp := sFlag_No
  else nTmp := sFlag_Yes;

  nStr := 'Update %s Set T_Valid=''%s'' Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTmp,
          ListTruck.Items[ListTruck.ItemIndex].Caption]);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  ShowMsg('更新成功', sHint);
end;

//------------------------------------------------------------------------------
procedure TfFormGetTruck.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  QueryTruck(EditTruck.Text);
end;

procedure TfFormGetTruck.ListTruckKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if ListTruck.ItemIndex > -1 then
      ModalResult := mrOk;
    //xxxxx
  end;
end;

procedure TfFormGetTruck.ListTruckDblClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
    ModalResult := mrOk;
  //xxxxx
end;

procedure TfFormGetTruck.BtnOKClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
       ModalResult := mrOk
  else ShowMsg('请在查询结果中选择', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormGetTruck, TfFormGetTruck.FormID);
end.
