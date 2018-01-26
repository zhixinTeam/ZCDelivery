{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 开提货单
*******************************************************************************}
unit UFormGetZhiKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, UBusinessConst, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, cxListView,
  cxDropDownEdit, cxTextEdit, cxMaskEdit, cxButtonEdit, cxMCListBox,
  dxLayoutControl, StdCtrls, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, ADODB, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid;

type
  TfFormGetZhiKa = class(TfFormNormal)
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    GridOrders: TcxGrid;
    dxLayout1Item3: TdxLayoutItem;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    EditCus: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxView1Column3: TcxGridDBColumn;
    cxView1Column4: TcxGridDBColumn;
    cxView1Column5: TcxGridDBColumn;
    cxView1Column6: TcxGridDBColumn;
    cxView1Column7: TcxGridDBColumn;
    cxView1Column8: TcxGridDBColumn;
    cxView1Column9: TcxGridDBColumn;
    cxView1Column10: TcxGridDBColumn;
    cxView1Column11: TcxGridDBColumn;
    cxView1Column12: TcxGridDBColumn;
    cxView1Column13: TcxGridDBColumn;
    cxView1Column14: TcxGridDBColumn;
    cxView1Column15: TcxGridDBColumn;
    cxView1Column16: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditCusPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    { Private declarations }
    FListA: TStrings;
    FBillItem: PLadingBillItem;
    //订单数据
    procedure InitFormData(const nCusName: string);
    //初始化
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormBase, UMgrControl, UDataModule, USysGrid, USysDB, USysConst,
  USysBusiness;

class function TfFormGetZhiKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  nP := nParam;

  with TfFormGetZhiKa.Create(Application) do
  try
    Caption := '销售订单';
    FBillItem := nP.FParamE;
    InitFormData('');
    
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormGetZhiKa.FormID: integer;
begin
  Result := cFI_FormGetZhika;
end;

procedure TfFormGetZhiKa.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  FListA := TStringList.Create;
  dxGroup1.AlignVert := avClient;
  LoadFormConfig(Self);

  for nIdx:=0 to cxView1.ColumnCount-1 do
    cxView1.Columns[nIdx].Tag := nIdx;
  InitTableView(Name, cxView1);
end;

procedure TfFormGetZhiKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FListA);
  SaveFormConfig(Self);
  SaveUserDefineTableView(Name, cxView1);
end;

//------------------------------------------------------------------------------
procedure TfFormGetZhiKa.InitFormData(const nCusName: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where O_Valid=''%s''';
  nStr := Format(nStr, [sTable_SalesOrder, sFlag_Yes]);
  
  if nCusName <> '' then
    nStr := nStr + ' And (' + nCusName + ')';
  FDM.QueryData(ADOQuery1, nStr);

  if ADOQuery1.Active and (ADOQuery1.RecordCount = 1) then
  begin
    ActiveControl := BtnOK;
  end else
  begin
    ActiveControl := EditCus;
    EditCus.SelectAll;
  end;
end;

procedure TfFormGetZhiKa.EditCusPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nWhere: string;
    nIdx: Integer;
begin
  if AButtonIndex = 1 then
  begin
    InitFormData('');
    ShowMsg('刷新成功', sHint);
    Exit;
  end;

  EditCus.Text := Trim(EditCus.Text);
  if EditCus.Text = '' then
  begin
    ShowMsg('请输入客户名称', sHint);
    Exit;
  end;

  SplitStr(EditCus.Text, FListA, 0, #32);
  if FListA.Count > 1 then
   for nIdx:=FListA.Count-1 downto 0 do
    if Trim(FListA[nIdx]) = '' then FListA.Delete(nIdx);
  //清理空参数

  nWhere := '';
  if FListA.Count > 0 then
  begin
    nStr := 'KUNNRDESC Like ''%%%s%%'' Or O_CusPY Like ''%%%s%%''';
    nWhere := Format(nStr, [FListA[0], FListA[0]]);
  end; //客户名

  if FListA.Count > 1 then
  begin
    nStr := ' And ARKTX Like ''%%%s%%''';
    nWhere := nWhere + Format(nStr, [FListA[1]]);
  end; //品种名

  if FListA.Count > 2 then
  begin
    if CompareText(FListA[2], 'D') = 0 then
         nStr := '31'
    else nStr := '32';

    nStr := Format(' And VTEXT=''%s''', [nStr]);
    nWhere := nWhere + nStr;
  end; //包装类型

  InitFormData(nWhere);
end;

procedure TfFormGetZhiKa.BtnOKClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount < 0 then
  begin
    ShowMsg('请选择订单', sHint);
    Exit;
  end;

  with ADOQuery1,FBillItem^ do
  begin
    FZhiKa       := FieldByName('VBELN').AsString;
    FStockNo     := FieldByName('MATNR').AsString;
    FStockName   := FieldByName('ARKTX').AsString;
    FCusID       := FieldByName('KUNNR').AsString;
    FCusName     := FieldByName('KUNNRDESC').AsString;

    FValue       := FieldByName('ZAVA').AsFloat;
    FStatus      := FieldByName('WERKS').AsString;
    FNextStatus  := FieldByName('WERKSDESC').AsString;

    FType := FieldByName('VTEXT').AsString;
    if FType = '31' then
         FType := sFlag_Dai
    else FType := sFlag_San;
  end;

  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormGetZhiKa, TfFormGetZhiKa.FormID);
end.
