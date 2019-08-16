{*******************************************************************************
  作者: dmzn@163.com 2016-10-26
  描述: 关联磁卡
*******************************************************************************}
unit UFormCardOther;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, cxMemo, cxMaskEdit, cxDropDownEdit,
  cxCheckBox, ComCtrls, cxListView;

type
  TfFormCardOther = class(TfFormNormal)
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    ComPort1: TComPort;
    dxLayout1Item7: TdxLayoutItem;
    EditMName: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    EditRName: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditCName: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel2: TcxLabel;
    Check1: TcxCheckBox;
    dxLayout1Item11: TdxLayoutItem;
    CheckOnePValue: TcxCheckBox;
    dxLayout1Item14: TdxLayoutItem;
    CheckOneDoor: TcxCheckBox;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cbbystd: TcxComboBox;
    dxLayout1Item16: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item13: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item17: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
    procedure EditTruckKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditCNamePropertiesChange(Sender: TObject);
    procedure EditMNamePropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FBuffer: string;
    //接收缓冲
    FYSTDList:TStrings;
    FParam: PFormCommandParam;
    procedure InitFormData;
    procedure ActionComPort(const nStop: Boolean);
    procedure InitComboxYSTD;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst,USysDB,
  UDataModule, UFormCtrl, UBusinessPacker;

type
  TReaderType = (ptT800, pt8142);
  //表头类型

  TReaderItem = record
    FType: TReaderType;
    FPort: string;
    FBaud: string;
    FDataBit: Integer;
    FStopBit: Integer;
    FCheckMode: Integer;
  end;
var
  gReaderItem: TReaderItem;
  //全局使用

class function TfFormCardOther.FormID: integer;
begin
  Result := CFI_FormMakeCardOther;
end;

class function TfFormCardOther.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;

  with TfFormCardOther.Create(Application) do
  try
    dxLayout1Group2.Visible := False;
    dxLayout1Item16.Visible := False;
    //dxLayout1Item11.Visible := False;
    FYSTDList := TStringList.Create;
    FParam := nParam;
    InitFormData;
    ActionComPort(False);

    FParam.FParamA := ShowModal;
    FParam.FCommand := cCmd_ModalResult;
  finally
    Free;
  end;
end;

procedure TfFormCardOther.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FYSTDList.Free;
  ActionComPort(True);
end;

procedure TfFormCardOther.InitFormData;
var nStr: string;
  nIndex:Integer;
  nYstdno:string;
begin
//  InitComboxYSTD;
  ActiveControl := EditMName;

  nStr := 'Select P_Name From %s Where P_Name is not null ';
  nStr := Format(nStr, [sTable_Provider]);

  EditCName.Properties.Items.Clear;

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      try
        EditCName.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          EditCName.Properties.Items.Add(Fields[0].AsString);
          Next;
        end;
      finally
        EditCName.Properties.EndUpdate;
      end;
    end;
  end;

  nStr := 'Select M_Name From %s Where M_Name is not null ';
  nStr := Format(nStr, [sTable_Materails]);

  EditMName.Properties.Items.Clear;

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      try
        EditMName.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          EditMName.Properties.Items.Add(Fields[0].AsString);
          Next;
        end;
      finally
        EditMName.Properties.EndUpdate;
      end;
    end;
  end;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);

  EditRName.Properties.Items.Clear;

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      try
        EditRName.Properties.BeginUpdate;

        First;

        while not Eof do
        begin
          if Fields[1].AsString = sFlag_FactoryName then
            EditRName.Properties.Items.Add(Fields[0].AsString);
          Next;
        end;
      finally
        EditRName.Properties.EndUpdate;
      end;
      EditRName.ItemIndex := 0;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 串口操作
procedure TfFormCardOther.ActionComPort(const nStop: Boolean);
var nInt: Integer;
    nIni: TIniFile;
begin
  if nStop then
  begin
    ComPort1.Close;
    Exit;
  end;

  with ComPort1 do
  begin
    with Timeouts do
    begin
      ReadTotalConstant := 100;
      ReadTotalMultiplier := 10;
    end;

    nIni := TIniFile.Create(gPath + 'Reader.Ini');
    with gReaderItem do
    try
      nInt := nIni.ReadInteger('Param', 'Type', 1);
      FType := TReaderType(nInt - 1);

      FPort := nIni.ReadString('Param', 'Port', '');
      FBaud := nIni.ReadString('Param', 'Rate', '4800');
      FDataBit := nIni.ReadInteger('Param', 'DataBit', 8);
      FStopBit := nIni.ReadInteger('Param', 'StopBit', 0);
      FCheckMode := nIni.ReadInteger('Param', 'CheckMode', 0);

      Port := FPort;
      BaudRate := StrToBaudRate(FBaud);

      case FDataBit of
       5: DataBits := dbFive;
       6: DataBits := dbSix;
       7: DataBits :=  dbSeven else DataBits := dbEight;
      end;

      case FStopBit of
       2: StopBits := sbTwoStopBits;
       15: StopBits := sbOne5StopBits
       else StopBits := sbOneStopBit;
      end;

      if FPort <> '' then
      begin
        ComPort1.Open;
        EditCard.Properties.ReadOnly := True;
      end;
    finally
      nIni.Free;
    end;
  end;
end;

procedure TfFormCardOther.ComPort1RxChar(Sender: TObject; Count: Integer);
var nStr: string;
    nIdx,nLen: Integer;
begin
  ComPort1.ReadStr(nStr, Count);
  FBuffer := FBuffer + nStr;

  nLen := Length(FBuffer);
  if nLen < 7 then Exit;

  for nIdx:=1 to nLen do
  begin
    if (FBuffer[nIdx] <> #$AA) or (nLen - nIdx < 6) then Continue;
    if (FBuffer[nIdx+1] <> #$FF) or (FBuffer[nIdx+2] <> #$00) then Continue;

    nStr := Copy(FBuffer, nIdx+3, 4);
    EditCard.Text := ParseCardNO(nStr, True); 

    FBuffer := '';
    Exit;
  end;
end;

procedure TfFormCardOther.EditTruckKeyPress(Sender: TObject;
  var Key: Char);
var nP: TFormCommandParam;
begin
  if (Key = #32) and (not EditTruck.Properties.ReadOnly) then
  begin
   Key := #0;
   nP.FParamA := EditTruck.Text;
   CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

   if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
     EditTruck.Text := nP.FParamB;
   EditTruck.SelectAll;
  end;
end;

procedure TfFormCardOther.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Click;
  end else OnCtrlKeyPress(Sender, Key);
end;

//Desc: 保存磁卡
procedure TfFormCardOther.BtnOKClick(Sender: TObject);
var nStr,nMType,nCType,nOneP,nOneDoor: string;
  nYstdno,nPName,nMName,nPNameUse,nMNameUse:string;
  nPNameList, nMNameList: TStrings;
  nIdx: Integer;
begin
  nYstdno := '';

  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    ActiveControl := EditCard;
    EditCard.SelectAll;

    ShowMsg('请输入有效卡号', sHint);
    Exit;
  end;

  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text = '' then
  begin
    ActiveControl := EditTruck;
    EditTruck.SelectAll;

    ShowMsg('请输入车牌号', sHint);
    Exit;
  end;

  EditRName.Text := Trim(EditRName.Text);
  if EditRName.Text = '' then
  begin
    ActiveControl := EditRName;

    ShowMsg('请输入或选择收货单位', sHint);
    Exit;
  end;

  if ListQuery.Items.Count <= 0  then
  begin
    ActiveControl := EditCName;

    ShowMsg('请添加过磅物料', sHint);
    Exit;
  end;

  if Check1.Checked then
  begin
    if ListQuery.Items.Count > 1  then
    begin
      ActiveControl := EditCName;

      ShowMsg('固定卡不支持添加多种过磅物料', sHint);
      Exit;
    end;
  end;

  try
    nPNameList := TStringList.Create;
    nMNameList := TStringList.Create;
    nPName := '';
    nMName := '';
    for nIdx := 0 to ListQuery.Items.Count - 1 do
    begin
      nPNameList.Add(ListQuery.Items[nIdx].Caption);
      nMNameList.Add(ListQuery.Items[nIdx].SubItems[0]);
      nPName := nPName + ListQuery.Items[nIdx].Caption + ',';
      nMName := nMName + ListQuery.Items[nIdx].SubItems[0] + ',';
    end;
    nPNameUse := nPNameList.Text;
    nMNameUse := nMNameList.Text;
  finally
    nPNameList.Free;
    nMNameList.Free
  end;
  FDM.ADOConn.BeginTrans;
  try
    nStr := 'O_Card=''%s''';
    if FParam.FCommand = cCmd_EditData then
      nStr := nStr + ' And R_ID<>%s';
    nStr := Format(nStr, [EditCard.Text, FParam.FParamA]);

    nStr := MakeSQLByStr([SF('O_Card', ''),
            SF('O_OutTime', sField_SQLServer_Now, sfVal),
            SF('O_OutMan', gSysParam.FUserID)
            ], sTable_CardOther, nStr, False);
    FDM.ExecuteSQL(nStr);

    if Check1.Checked then
         nCType := sFlag_Yes
    else nCType := sFlag_No;

    if CheckOnePValue.Checked then
         nOneP := sFlag_Yes
    else nOneP := sFlag_No;

    if CheckOneDoor.Checked then
         nOneDoor := sFlag_Yes
    else nOneDoor := sFlag_No;

    if cbbystd.ItemIndex<>-1 then
    begin
      nYstdno := FYSTDList.Strings[cbbystd.ItemIndex];
    end;
    if FParam.FCommand = cCmd_AddData then
    begin

      nStr := MakeSQLByStr([
              SF('O_Status', sFlag_TruckNone),
              SF('O_NextStatus', sFlag_TruckIn),
              SF('O_Card', EditCard.Text),
              SF('O_Truck', EditTruck.Text),
              SF('O_CusName', nPName),
              SF('O_RevName', EditRName.Text),
              SF('O_MName', nMName),
              SF('O_CusNameUse', nPNameUse),
              SF('O_MNameUse', nMNameUse),
              SF('O_KeepCard', nCType),
              SF('O_UsePValue', nOneP),
              SF('O_OneDoor', nOneDoor),
              SF('O_Man', gSysParam.FUserID),
              SF('O_Date', sField_SQLServer_Now, sfVal),
              SF('O_YSTDno', nYstdno)
              ], sTable_CardOther, '', True);
      FDM.ExecuteSQL(nStr);
    end else
    begin
      nStr := MakeSQLByStr([
              SF('O_Card', EditCard.Text),
              SF('O_KeepCard', nCType)
              ], sTable_CardOther, 'R_ID=' + FParam.FParamA, False);
      FDM.ExecuteSQL(nStr);
    end;

    nStr := MakeSQLByStr([SF('C_Used', sFlag_Mul),
            SF('C_Status', sFlag_CardUsed)
            ], sTable_Card, SF('C_Card', EditCard.Text), False);
    FDM.ExecuteSQL(nStr);

    nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, EditTruck.Text]);
    //xxxxx

    if FDM.QueryTemp(nStr).Fields[0].AsInteger < 1 then
    begin
      nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
      nStr := Format(nStr, [sTable_Truck, EditTruck.Text,
              GetPinYinOfStr(EditTruck.Text)]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    //done
  except
    FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

procedure TfFormCardOther.InitComboxYSTD;
var
  nStr:string;
  nid,nName:string;
begin
  FYSTDList.Clear;
  cbbystd.Properties.Items.Clear;
//  nStr := 'select * from %s where y_valid=''%s''';
//  nStr := Format(nStr,[sTable_YSLines,sFlag_Yes]);
  with FDM.QueryTemp(nStr) do
  begin
    while not Eof do
    begin
      nid := FieldByName('Y_id').AsString;
      nName := FieldByName('Y_Name').AsString;
      FYSTDList.Add(nid);
      cbbystd.Properties.Items.Add(nName);
      Next;
    end;
  end;
end;

procedure TfFormCardOther.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nStr: string;
begin
  if EditCName.Text = '' then
  begin
    ActiveControl := EditCName;

    ShowMsg('请输入或选择发货单位', sHint);
    Exit;
  end;
  if EditMName.Text = '' then
  begin
    ActiveControl := EditMName;

    ShowMsg('请输入或选择物料', sHint);
    Exit;
  end;

  for nIdx := 0 to ListQuery.Items.Count - 1 do
  begin
    nStr:= ListQuery.Items[nIdx].SubItems[0];
    if CompareText(Trim(EditMName.Text),nStr) = 0 then
    begin
      ShowMsg('物料重复,请重新选择', sHint);
      Exit;
    end;
  end;
  with ListQuery.Items.Add do
  begin
    Caption := EditCName.Text;
    SubItems.Add(EditMName.Text);
    ImageIndex := cItemIconIndex;
  end;
  if ListQuery.Items.Count > 0 then
    ListQuery.ItemIndex := ListQuery.Items.Count - 1;
end;

procedure TfFormCardOther.BtnDelClick(Sender: TObject);
begin
  if ListQuery.ItemIndex < 0 then
  begin
    ShowMsg('请选择需要删除的项目',sHint);
    Exit;
  end;
  ListQuery.Items.Delete(ListQuery.ItemIndex);
  if ListQuery.Items.Count > 0 then
    ListQuery.ItemIndex := ListQuery.Items.Count - 1;
end;

procedure TfFormCardOther.EditCNamePropertiesChange(Sender: TObject);
var nIdx : Integer;
begin
  for nIdx := 0 to EditCName.Properties.Items.Count - 1 do
  begin;
    if Pos(EditCName.Text,EditCName.Properties.Items.Strings[nIdx]) > 0 then
    begin
      EditCName.SelectedItem := nIdx;
      Break;
    end;
  end;
end;

procedure TfFormCardOther.EditMNamePropertiesChange(Sender: TObject);
var nIdx : Integer;
begin
  for nIdx := 0 to EditMName.Properties.Items.Count - 1 do
  begin;
    if Pos(EditMName.Text,EditMName.Properties.Items.Strings[nIdx]) > 0 then
    begin
      EditMName.SelectedItem := nIdx;
      Break;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormCardOther, TfFormCardOther.FormID);
end.
