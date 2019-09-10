{*******************************************************************************
  作者: dmzn@163.com 2015-01-22
  描述: 选择NC客户或物料
*******************************************************************************}
unit UFormGetYTBatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, dxLayoutControl, StdCtrls, cxControls,
  ComCtrls, cxListView, cxButtonEdit, cxLabel, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutcxEditAdapters,USysConst, ExtCtrls;

type
  TfFormGetYTBatch = class(TfFormNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    ListQuery: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListQueryKeyPress(Sender: TObject; var Key: Char);
    procedure EditCIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListQueryDblClick(Sender: TObject);
  private
    { Private declarations }
    function QueryData: Boolean;
    //查询数据
    procedure GetResult;
    //获取结果
  public
    { Public declarations }
    WebOrderItem:stMallOrderItem;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    class function QueryCorrectBatchCode(const nCementDataText,nWebOrderValue:string;var nCementCodeID:string):string;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UFormBase, USysGrid, USysDB, 
  UDataModule, UBusinessConst, USysBusiness, UBusinessPacker;

var
  gCementData: TStrings;

class function TfFormGetYTBatch.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  gCementData := TStringList.Create;
  with TfFormGetYTBatch.Create(Application) do
  try
    gCementData.Text := nP.FParamA;
    EditCus.Text := gCementData.Values['XCB_CementName'];

    Caption := '选择批次';
    dxLayout1Item5.Caption := '批次号选择';

    nP.FCommand := cCmd_ModalResult;
    QueryData;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin
      nP.FParamB := PackerEncodeStr(gCementData.Text);
    end;
  finally
    gCementData.Free;
    Free;
  end;
end;

class function TfFormGetYTBatch.FormID: integer;
begin
  Result := cFI_FormGetYTBatch;
end;

procedure TfFormGetYTBatch.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormGetYTBatch.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListQuery, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015-01-22
//Desc: 按指定类型查询
function TfFormGetYTBatch.QueryData: Boolean;
var nStr: string;
    nIdx: Integer;
    nListA, nListB: TStrings;
begin
  Result := False;
  ListQuery.Items.Clear;
  gCementData.Text := YT_GetBatchCode(gCementData);

  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(gCementData.Values['XCB_CementRecords']);
    if nListA.Count < 1 then Exit;

    for nIdx := 0 to nListA.Count - 1 do
    with ListQuery.Items.Add do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      Caption := gCementData.Values['XCB_Cement'];
      SubItems.Add(nListB.Values['XCB_CementCode']);
      SubItems.Add(nListB.Values['XCB_CementValue']);
      SubItems.Add(nListB.Values['XCB_OutASH']);
      SubItems.Add(nListB.Values['XCB_CementCodeID']);
      ImageIndex := cItemIconIndex;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;

  if ListQuery.Items.Count > 0 then
    ListQuery.ItemIndex := 0;

  Result := True;
end;

procedure TfFormGetYTBatch.EditCIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditCus.Text := Trim(EditCus.Text);
  if (EditCus.Text <> '') and QueryData then ListQuery.SetFocus;
end;

//Desc: 获取结果
procedure TfFormGetYTBatch.GetResult;
begin
  with ListQuery.Selected do
  begin
    gCementData.Values['XCB_CementCode'] := SubItems[0];
    gCementData.Values['XCB_CementCodeID'] := SubItems[3];
  end;
end;

procedure TfFormGetYTBatch.ListQueryKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if ListQuery.ItemIndex > -1 then
    begin
      GetResult;
      ModalResult := mrOk;
    end;
  end;
end;

procedure TfFormGetYTBatch.ListQueryDblClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end;
end;

procedure TfFormGetYTBatch.BtnOKClick(Sender: TObject);
begin
  if ListQuery.ItemIndex > -1 then
  begin
    GetResult;
    ModalResult := mrOk;
  end else ShowMsg('请在查询结果中选择', sHint);
end;

class function TfFormGetYTBatch.QueryCorrectBatchCode(
  const nCementDataText, nWebOrderValue: string;var nCementCodeID:string): string;
var
  nStr: string;
  nIdx: Integer;
  nCementData,nListA, nListB: TStrings;
  ndOrderValue,nBatchValue:Double;
begin
  Result := '';
  ndOrderValue := StrToFloat(nWebOrderValue);
  nCementData := TStringList.Create;
  nCementData.Text := nCementDataText;
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nCementData.Text := YT_GetBatchCode(nCementData);
    nListA.Text := PackerDecodeStr(nCementData.Values['XCB_CementRecords']);
    if nListA.Count < 1 then Exit;

    for nIdx := 0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      nBatchValue := StrToFloat(nListB.Values['XCB_CementValue']);
      if nBatchValue-ndOrderValue>0.001 then
      begin
        Result := nListB.Values['XCB_CementCode'];
        nCementCodeID := nListB.Values['XCB_CementCodeID'];
        Break;
      end;
    end;
  finally
    nListA.Free;
    nListB.Free;
    nCementData.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormGetYTBatch, TfFormGetYTBatch.FormID);
end.
