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
  cxCheckBox;

type
  TfFormCardOther = class(TfFormNormal)
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    ComPort1: TComPort;
    dxLayout1Item3: TdxLayoutItem;
    EditMID: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    EditMName: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    EditCID: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    EditCName: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item13: TdxLayoutItem;
    EditVal: TcxTextEdit;
    Check1: TcxCheckBox;
    dxLayout1Item11: TdxLayoutItem;
    CheckOnePValue: TcxCheckBox;
    dxLayout1Item14: TdxLayoutItem;
    CheckOneDoor: TcxCheckBox;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cbbystd: TcxComboBox;
    dxLayout1Item16: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
    procedure EditMIDPropertiesEditValueChanged(Sender: TObject);
    procedure EditMNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditCIDPropertiesEditValueChanged(Sender: TObject);
    procedure EditCNamePropertiesEditValueChanged(Sender: TObject);
    procedure EditTruckKeyPress(Sender: TObject; var Key: Char);
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
  UDataModule, UFormCtrl;

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
  ActiveControl := EditMID;
  with EditType.Properties do
  begin
    Items.Add(sFlag_San + '.散装');
    Items.Add(sFlag_Dai + '.包装');
    EditType.ItemIndex := 0;
  end;

  if FParam.FCommand = cCmd_AddData then
  begin
//    PoundLoadMaterails(EditMID.Properties.Items, EditMName.Properties.Items);
//    PoundLoadCustomer(EditCID.Properties.Items, EditCName.Properties.Items);
  end else
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_CardOther, FParam.FParamA]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
      begin
        ShowMsg('数据丢失', sHint);
        BtnOK.Enabled := False;
        Exit;
      end;

      EditCID.Text := FieldByName('O_CusID').AsString;
      EditCID.Properties.ReadOnly := True;
      EditCName.Text := FieldByName('O_CusName').AsString;
      EditCName.Properties.ReadOnly := True;

      EditMID.Text := FieldByName('O_MID').AsString;
      EditMID.Properties.ReadOnly := True;
      EditMName.Text := FieldByName('O_MName').AsString;
      EditMName.Properties.ReadOnly := True;

      if FieldByName('O_MType').AsString = sFlag_San then
           EditType.ItemIndex := 0
      else EditType.ItemIndex := 1;

      EditType.Properties.ReadOnly := True;
      EditTruck.Text := FieldByName('O_Truck').AsString;
      EditTruck.Properties.ReadOnly := True;
      nYstdno := FieldByName('O_YSTDno').AsString;
      if nYstdno<>'' then
      begin
        nIndex := FYSTDList.IndexOf(nYstdno);
        cbbystd.ItemIndex := nIndex;
      end;

      CheckOnePValue.Checked := FieldByName('O_UsePValue').AsString = sFlag_Yes;
      CheckOneDoor.Checked := FieldByName('O_OneDoor').AsString = sFlag_Yes;
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

//------------------------------------------------------------------------------
procedure TfFormCardOther.EditMIDPropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditMID.Focused and (not EditMID.Properties.ReadOnly) then
  begin
    EditMName.ItemIndex := EditMID.ItemIndex;
  end;
end;

procedure TfFormCardOther.EditMNamePropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditMName.Focused and (not EditMName.Properties.ReadOnly) then
  begin
    EditMID.ItemIndex := EditMName.ItemIndex;
  end;
end;

procedure TfFormCardOther.EditCIDPropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditCID.Focused and (not EditCID.Properties.ReadOnly) then
  begin
    EditCName.ItemIndex := EditCID.ItemIndex;
  end;
end;

procedure TfFormCardOther.EditCNamePropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditCName.Focused and (not EditCName.Properties.ReadOnly) then
  begin
    EditCID.ItemIndex := EditCName.ItemIndex;
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
  nYstdno:string;
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

  if not IsNumber(EditVal.Text, True) then
  begin
    ActiveControl := EditVal;
    EditVal.SelectAll;

    ShowMsg('请输入数值', sHint);
    Exit;
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
      if EditType.ItemIndex = 0 then
           nMType := sFlag_San
      else nMType := sFlag_Dai;

      nStr := MakeSQLByStr([
              SF('O_Status', sFlag_TruckNone),
              SF('O_NextStatus', sFlag_TruckIn),
              SF('O_Card', EditCard.Text),
              SF('O_Truck', EditTruck.Text),
              SF('O_CusID', EditCID.Text),
              SF('O_CusName', EditCName.Text),
              SF('O_MID', EditMID.Text),
              SF('O_MName', EditMName.Text),
              SF('O_MType', nMType),
              SF('O_LimVal', EditVal.Text, sfVal),
              SF('O_KeepCard', nCType),
              SF('O_UsePValue', nOneP),
              SF('O_OneDoor', nOneDoor),
              SF('O_Man', gSysParam.FUserID),
              SF('O_Date', sField_SQLServer_Now, sfVal),
              SF('O_YSTDno', nYstdno)
              ], sTable_CardOther, '', True);
      {$IFDEF QHSN}
      {$IFDEF GGJC}
      nStr := MakeSQLByStr([
              SF('O_Status', sFlag_TruckIn),
              SF('O_NextStatus', sFlag_TruckBFP),
              SF('O_Card', EditCard.Text),
              SF('O_Truck', EditTruck.Text),
              SF('O_CusID', EditCID.Text),
              SF('O_CusName', EditCName.Text),
              SF('O_MID', EditMID.Text),
              SF('O_MName', EditMName.Text),
              SF('O_MType', nMType),
              SF('O_LimVal', EditVal.Text, sfVal),
              SF('O_KeepCard', nCType),
              SF('O_UsePValue', nOneP),
              SF('O_OneDoor', nOneDoor),
              SF('O_Man', gSysParam.FUserID),
              SF('O_Date', sField_SQLServer_Now, sfVal),
              SF('O_YSTDno', nYstdno)
              ], sTable_CardOther, '', True);
      {$ENDIF}
      {$ENDIF}
      FDM.ExecuteSQL(nStr);
    end else
    begin
      nStr := MakeSQLByStr([
              SF('O_Card', EditCard.Text),
              SF('O_KeepCard', nCType)
              ], sTable_CardOther, 'R_ID=' + FParam.FParamA, False);
      FDM.ExecuteSQL(nStr);
    end;

    nStr := MakeSQLByStr([SF('C_Used', sFlag_Other),
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

initialization
  gControlManager.RegCtrl(TfFormCardOther, TfFormCardOther.FormID);
end.
