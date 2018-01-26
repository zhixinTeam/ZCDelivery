{*******************************************************************************
  作者: dmzn@163.com 2009-6-11
  描述: 客户管理
*******************************************************************************}
unit UFormCustomer;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxLayoutControl, cxCheckBox,
  cxLabel, StdCtrls, cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo,
  cxTextEdit;

type
  TfFormCustomer = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditPhone: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayoutControl1Item5: TdxLayoutItem;
    InfoItems: TcxComboBox;
    dxLayoutControl1Item6: TdxLayoutItem;
    EditInfo: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayoutControl1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayoutControl1Item9: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    cxTextEdit1: TcxTextEdit;
    dxLayoutControl1Item12: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayoutControl1Item13: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayoutControl1Item15: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayoutControl1Item16: TdxLayoutItem;
    EditBank: TcxComboBox;
    dxLayoutControl1Item17: TdxLayoutItem;
    cxTextEdit6: TcxTextEdit;
    dxLayoutControl1Item18: TdxLayoutItem;
    dxLayoutControl1Group6: TdxLayoutGroup;
    dxLayoutControl1Group7: TdxLayoutGroup;
    dxLayoutControl1Group8: TdxLayoutGroup;
    EditCredit: TcxTextEdit;
    dxLayoutControl1Item19: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayoutControl1Item20: TdxLayoutItem;
    dxLayoutControl1Group10: TdxLayoutGroup;
    EditSaleMan: TcxComboBox;
    dxLayoutControl1Item21: TdxLayoutItem;
    dxLayoutControl1Group12: TdxLayoutGroup;
    dxLayoutControl1Group11: TdxLayoutGroup;
    Check1: TcxCheckBox;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutControl1Group13: TdxLayoutGroup;
    dxLayoutControl1Group3: TdxLayoutGroup;
    EditWX: TcxComboBox;
    dxLayoutControl1Item22: TdxLayoutItem;
    dxLayoutControl1Group14: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FCustomerID: string;
    //客户标识
    procedure InitFormData(const nID: string);
    //载入数据
    procedure GetData(Sender: TObject; var nData: string);
    function SetData(Sender: TObject; const nData: string): Boolean;
    //数据相关
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysBusiness,
  USysGrid, USysDB, USysConst;

var
  gForm: TfFormCustomer = nil;
  //全局使用

class function TfFormCustomer.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormCustomer.Create(Application) do
    begin
      FCustomerID := '';
      Caption := '客户 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormCustomer.Create(Application) do
    begin
      FCustomerID := nP.FParamA;
      Caption := '客户 - 修改';

      InitFormData(FCustomerID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormCustomer.Create(Application);
        with gForm do
        begin
          Caption := '客户 - 查看';
          FormStyle := fsStayOnTop;

          BtnOK.Visible := False;
          BtnAdd.Enabled := False;
          BtnDel.Enabled := False;
        end;
      end;

      with gForm  do
      begin
        FCustomerID := nP.FParamA;
        InitFormData(FCustomerID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end; 
end;

class function TfFormCustomer.FormID: integer;
begin
  Result := cFI_FormCustomer;
end;

//------------------------------------------------------------------------------
procedure TfFormCustomer.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  {$IFNDEF MicroMsg}
  EditWX.Hint := '';
  EditWX.Visible := False; 
  {$ENDIF}

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;

  ResetHintAllForm(Self, 'T', sTable_Customer);
  //重置表名称
end;

procedure TfFormCustomer.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormCustomer.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormCustomer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 设置数据
function TfFormCustomer.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;
  if Sender = Check1 then
  begin
    Result := True;
    Check1.Checked := nData = sFlag_Yes;
  end;
end;

//Date: 2009-6-2
//Parm: 供应商编号
//Desc: 载入nID供应商的信息到界面
procedure TfFormCustomer.InitFormData(const nID: string);
var nStr: string;
begin
  LoadSysDictItem(sFlag_CustomerItem, InfoItems.Properties.Items);
  LoadSysDictItem(sFlag_BankItem, EditBank.Properties.Items);
  
  if EditSaleMan.Properties.Items.Count < 1 then
    LoadSaleMan(EditSaleMan.Properties.Items);
  //xxxxx

  if nID <> '' then
  begin
    nStr := 'Select cus.* From %s cus ' +
            'Where cus.C_ID=''%s''';
    nStr := Format(nStr, [sTable_Customer, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);

    InfoList1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_CustomerItem), MI('$ID', nID)]);
    //扩展信息

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('I_Item').AsString + InfoList1.Delimiter +
                FieldByName('I_Info').AsString;
        InfoList1.Items.Add(nStr);
        
        Next;
      end;
    end;
  end;
end;

//Desc: 添加信息
procedure TfFormCustomer.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    InfoItems.SetFocus;
    ShowMsg('请填写 或 选择有效的信息项', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    ShowMsg('请填写有效的信息内容', sHint); Exit;
  end;

  InfoList1.Items.Add(InfoItems.Text + InfoList1.Delimiter + EditInfo.Text);
end;

//Desc: 删除信息项
procedure TfFormCustomer.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if InfoList1.ItemIndex < 0 then
  begin
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := InfoList1.ItemIndex;
  InfoList1.Items.Delete(InfoList1.ItemIndex);

  if nIdx >= InfoList1.Count then Dec(nIdx);
  InfoList1.ItemIndex := nIdx;
  ShowMsg('信息项已删除', sHint);
end;

//Desc: 获取数据
procedure TfFormCustomer.GetData(Sender: TObject; var nData: string);
begin
  if Sender = Check1 then
  begin
    if Check1.Checked then
         nData := sFlag_Yes
    else nData := sFlag_No;
  end;
end;

//Desc: 保存数据
procedure TfFormCustomer.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i,nCount,nPos: integer;
    nStr,nSQL,nTmp,nID: string;
begin
  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    ShowMsg('请填写客户名称', sHint); Exit;
  end;

  nStr := 'Select Count(*) From %s Where C_Name=''%s''';
  nStr := Format(nStr, [sTable_Customer, EditName.Text]);

  if FCustomerID <> '' then
    nStr := nStr + Format(' And C_ID<>''%S''', [FCustomerID]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
  begin
    nStr := '客户[ %s ]已存在!!' + #13#10#13#10 +
            '客户重名可能会导致回款、办卡等操作错误,要继续吗?';
    nStr := Format(nStr, [EditName.Text]);
    if not QueryDlg(nStr, sAsk, Handle) then Exit;
  end;

  nList := TStringList.Create;
  nList.Text := SF('C_PY', GetPinYinOfStr(EditName.Text));

  if FCustomerID = '' then
  begin
    nID := GetSerialNo(sFlag_BusGroup, sFlag_Customer, False);
    if nID = '' then Exit;
    
    nList.Add(SF('C_ID', nID));
    nSQL := MakeSQLByForm(Self, sTable_Customer, '', True, GetData, nList);
  end else
  begin
    nID := FCustomerID;
    nStr := 'C_ID=''' + FCustomerID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Customer, nStr, False, GetData, nList);
  end;

  nList.Free;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);
    //insert data
    
    if FCustomerID <> '' then
    begin
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_CustomerItem, nID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nCount := InfoList1.Items.Count - 1;
    for i:=0 to nCount do
    begin
      nStr := InfoList1.Items[i];
      nPos := Pos(InfoList1.Delimiter, nStr);

      nTmp := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos + Length(InfoList1.Delimiter) - 1);

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_CustomerItem, nID, nTmp, nStr]);
      FDM.ExecuteSQL(nSQL);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('数据已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormCustomer, TfFormCustomer.FormID);
end.
