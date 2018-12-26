{*******************************************************************************
  作者: dmzn@163.com 2009-07-20
  描述: 品种管理
*******************************************************************************}
unit UFormHYStock;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, cxGraphics, StdCtrls, cxMaskEdit, cxDropDownEdit,
  cxMCListBox, cxMemo, dxLayoutControl, cxContainer, cxEdit, cxTextEdit,
  cxControls, cxButtonEdit, cxCalendar, ExtCtrls, cxPC, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormHYStock = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayoutControl1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayoutControl1Item8: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group6: TdxLayoutGroup;
    wPage: TcxPageControl;
    dxLayoutControl1Item25: TdxLayoutItem;
    Sheet1: TcxTabSheet;
    Sheet2: TcxTabSheet;
    cxTextEdit2: TcxTextEdit;
    cxTextEdit3: TcxTextEdit;
    cxTextEdit14: TcxTextEdit;
    cxTextEdit16: TcxTextEdit;
    cxTextEdit15: TcxTextEdit;
    cxTextEdit1: TcxTextEdit;
    cxTextEdit6: TcxTextEdit;
    cxTextEdit5: TcxTextEdit;
    cxTextEdit13: TcxTextEdit;
    cxTextEdit7: TcxTextEdit;
    cxTextEdit4: TcxTextEdit;
    cxTextEdit8: TcxTextEdit;
    cxTextEdit11: TcxTextEdit;
    cxTextEdit9: TcxTextEdit;
    cxTextEdit12: TcxTextEdit;
    cxTextEdit10: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Bevel1: TBevel;
    cxTextEdit17: TcxTextEdit;
    cxTextEdit18: TcxTextEdit;
    cxTextEdit19: TcxTextEdit;
    cxTextEdit20: TcxTextEdit;
    cxTextEdit21: TcxTextEdit;
    cxTextEdit22: TcxTextEdit;
    cxTextEdit23: TcxTextEdit;
    cxTextEdit24: TcxTextEdit;
    cxTextEdit25: TcxTextEdit;
    cxTextEdit26: TcxTextEdit;
    cxTextEdit27: TcxTextEdit;
    cxTextEdit28: TcxTextEdit;
    cxTextEdit29: TcxTextEdit;
    cxTextEdit30: TcxTextEdit;
    cxTextEdit31: TcxTextEdit;
    cxTextEdit32: TcxTextEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Bevel2: TBevel;
    cxTextEdit33: TcxTextEdit;
    cxTextEdit34: TcxTextEdit;
    cxTextEdit35: TcxTextEdit;
    cxTextEdit36: TcxTextEdit;
    cxTextEdit37: TcxTextEdit;
    cxTextEdit38: TcxTextEdit;
    cxTextEdit39: TcxTextEdit;
    cxTextEdit40: TcxTextEdit;
    cxTextEdit41: TcxTextEdit;
    cxTextEdit42: TcxTextEdit;
    cxTextEdit43: TcxTextEdit;
    cxTextEdit47: TcxTextEdit;
    cxTextEdit48: TcxTextEdit;
    cxTextEdit49: TcxTextEdit;
    EditQLevel: TcxTextEdit;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    Label33: TLabel;
    cxTextEdit44: TcxTextEdit;
    Label34: TLabel;
    cxTextEdit45: TcxTextEdit;
    Label35: TLabel;
    cxTextEdit46: TcxTextEdit;
    Label36: TLabel;
    cxTextEdit50: TcxTextEdit;
    Label37: TLabel;
    cxTextEdit51: TcxTextEdit;
    Label38: TLabel;
    cxTextEdit52: TcxTextEdit;
    Label39: TLabel;
    cxTextEdit53: TcxTextEdit;
    Label40: TLabel;
    cxTextEdit54: TcxTextEdit;
    Label41: TLabel;
    cxTextEdit55: TcxTextEdit;
    Label42: TLabel;
    cxTextEdit56: TcxTextEdit;
    Label43: TLabel;
    cxTextEdit57: TcxTextEdit;
    Label44: TLabel;
    cxTextEdit58: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditStockPropertiesEditValueChanged(Sender: TObject);
    procedure cxTextEdit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FRecordID: string;
    //合同编号
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    procedure InitFormData(const nID: string);
    //载入数据
  public
    { Public declarations }
  end;

function ShowStockAddForm: Boolean;
function ShowStockEditForm(const nID: string): Boolean;
procedure ShowStockViewForm(const nID: string);
procedure CloseStockForm;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, USysDB, USysConst, USysBusiness;

var
  gForm: TfFormHYStock = nil;
  //全局使用

//------------------------------------------------------------------------------
//Desc: 添加
function ShowStockAddForm: Boolean;
begin
  with TfFormHYStock.Create(Application) do
  begin
    FRecordID := '';
    Caption := '水泥品种 - 添加';

    InitFormData('');
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: 修改
function ShowStockEditForm(const nID: string): Boolean;
begin
  with TfFormHYStock.Create(Application) do
  begin
    FRecordID := nID;
    Caption := '水泥品种 - 修改';

    InitFormData(nID);
    Result := ShowModal = mrOK;
    Free;
  end;
end;

//Desc: 查看
procedure ShowStockViewForm(const nID: string);
begin
  if not Assigned(gForm) then
  begin
    gForm := TfFormHYStock.Create(Application);
    gForm.Caption := '水泥品种 - 查看';
    gForm.FormStyle := fsStayOnTop;
    gForm.BtnOK.Visible := False;
  end;

  with gForm  do
  begin
    InitFormData(nID);
    if not Showing then Show;
  end;
end;

procedure CloseStockForm;
begin
  FreeAndNil(gForm);
end;

//------------------------------------------------------------------------------
procedure TfFormHYStock.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  wPage.ActivePageIndex := 0;
  ResetHintAllForm(Self, 'T', sTable_StockParam);
  ResetHintAllForm(Self, 'E', sTable_StockParamExt);
  //重置表名称
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'PZ');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  {$IFDEF SyncDataByWSDL}
  if not SyncSMaterailWSDL('') then
  begin
    ShowMsg('同步ERP销售物料失败',sHint);
  end;
  {$ELSE}
  if not SyncSMaterail('') then
  begin
    ShowMsg('同步ERP销售物料失败',sHint);
  end;
  {$ENDIF}
end;

procedure TfFormHYStock.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormHYStock.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormHYStock.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end else

  if Key = VK_DOWN then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end else

  if Key = VK_UP then
  begin
    Key := 0;
    Perform(WM_NEXTDLGCTL, 1, 0);
  end;
end;

procedure TfFormHYStock.cxTextEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-6-2
//Parm: 品种编号
//Desc: 载入nID供应商的信息到界面
procedure TfFormHYStock.InitFormData(const nID: string);
var nStr: string;
begin
  if EditStock.Properties.Items.Count < 1 then
  begin
    nStr := 'D_Value=Select D_Memo,D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem]);

    FDM.FillStringsData(EditStock.Properties.Items, nStr, -1, '、');
    AdjustCtrlData(Self);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_StockParam, nID]);
    LoadDataToForm(FDM.QuerySQL(nStr), Self, sTable_StockParam);

    nStr := 'Select * From %s Where R_PID=''%s''';
    nStr := Format(nStr, [sTable_StockParamExt, nID]);
    LoadDataToForm(FDM.QueryTemp(nStr), Self, sTable_StockParamExt);
  end;
end;

//Desc: 设置类型
procedure TfFormHYStock.EditStockPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  nStr := GetPinYinOfStr(EditStock.Text);
  if Pos('kzf', nStr) > 0 then //矿渣粉
  begin
    Label8.Caption := '密度g/cm:'; cxTextEdit2.Text := '≥';
    Label3.Caption := '流动度比:'; cxTextEdit1.Text := '≥';
    Label6.Caption := '含 水 量:'; cxTextEdit14.Text := '≥';
    Label2.Caption := '7天活性指数:'; cxTextEdit11.Text := '≥';
    Label10.Caption := '28天活性指数:'; cxTextEdit12.Text := '≥';
  end else
  begin
    Label8.Caption := '氧 化 镁:'; cxTextEdit2.Text := '≤';
    Label3.Caption := '碱 含 量:'; cxTextEdit1.Text := '';
    Label6.Caption := '细    度:'; cxTextEdit14.Text := '';
    Label2.Caption := '3天抗折强度:'; cxTextEdit11.Text := '≥';
    Label10.Caption := '28天抗折强度:'; cxTextEdit12.Text := '≥';
  end;

  Label24.Caption := Label8.Caption;
  Label22.Caption := Label6.Caption;
  Label19.Caption := Label3.Caption;
  Label18.Caption := Label2.Caption;
  Label26.Caption := Label10.Caption;

  SetCtrlData(EditType, Copy(EditStock.Text, 1, 1));
end;

//Desc: 生成随机编号
procedure TfFormHYStock.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := FDM.GetRandomID(FPrefixID, FIDLength);
end;

//Desc: 保存数据
procedure TfFormHYStock.BtnOKClick(Sender: TObject);
var nList: TStrings;
    nStr,nSQL: string;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('请填写有效的品种编号', sHint); Exit;
  end;

  if FRecordID = '' then
  begin
    nStr := 'Select Count(*) From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_StockParam, EditID.Text]);
    //查询编号是否存在

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       ShowMsg('该编号的品种已经存在', sHint); Exit;
     end;

     nSQL := MakeSQLByForm(Self, sTable_StockParam, '', True);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'P_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_StockParam, nStr, False);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FRecordID = '' then
    begin
      nList := TStringList.Create;
      nList.Text := 'R_PID=''' + EditID.Text + '''';
      
      nSQL := MakeSQLByForm(Self, sTable_StockParamExt, '', True, nil, nList);
      nList.Free;
    end else
    begin
      nStr := 'R_PID=''' + FRecordID + '''';
      nSQL := MakeSQLByForm(Self, sTable_StockParamExt, nStr, False);
    end;

    FDM.ExecuteSQL(nSQL);
    FDM.ADOConn.CommitTrans;
    
    ModalResult := mrOK;
    ShowMsg('数据已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

end.
