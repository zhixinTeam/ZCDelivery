{*******************************************************************************
  作者: juner11212436@163.com 2018-04-17
  描述: 查询磁卡
*******************************************************************************}
unit UFormCardSearch;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CPort, CPortTypes, UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, cxMemo, cxMaskEdit, cxDropDownEdit,
  cxCheckBox, ComCtrls, cxListView;

type
  TfFormCardSearch = class(TfFormNormal)
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    ComPort1: TComPort;
    dxLayout1Item12: TdxLayoutItem;
    cxLabel2: TcxLabel;
    EditUse: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditFreeze: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCType: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditID: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditUTime: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditCusName: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditStockName: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FBuffer: string;
    //接收缓冲
    procedure ActionComPort(const nStop: Boolean);
    procedure QueryCard(const nCard: string);
    procedure QueryPorderinfo(const nCard: string);
    procedure QueryOtherInfo(const nCard: string);
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

class function TfFormCardSearch.FormID: integer;
begin
  Result := CFI_FormSearchCard;
end;

class function TfFormCardSearch.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormCardSearch.Create(Application) do
  try
    ActionComPort(False);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormCardSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActionComPort(True);
end;

//------------------------------------------------------------------------------
//Desc: 串口操作
procedure TfFormCardSearch.ActionComPort(const nStop: Boolean);
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

procedure TfFormCardSearch.ComPort1RxChar(Sender: TObject; Count: Integer);
var nStr, nSQL: string;
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

    nSql := 'select * from %s where c_card=''%s''';
    nSql := Format(nSql,[sTable_Card,EditCard.Text]);
    with FDM.QuerySQL(nSql) do
    begin
      if RecordCount<=0 then
      begin
        ShowMsg('磁卡号无效',sHint);
        Exit;
      end;

      EditUTime.Text := '';
      if FieldByName('C_Status').AsString = sFlag_CardUsed then
      begin
        EditUse.Text := FieldByName('C_Status').AsString + '、使用中';
        EditUTime.Text := FieldByName('C_Date').AsString;
      end
      else
      if FieldByName('C_Status').AsString = sFlag_CardIdle then
        EditUse.Text := FieldByName('C_Status').AsString + '、空闲'
      else
      if FieldByName('C_Status').AsString = sFlag_CardLoss then
        EditUse.Text := FieldByName('C_Status').AsString + '、挂失'
      else
      if FieldByName('C_Status').AsString = sFlag_CardInvalid then
        EditUse.Text := FieldByName('C_Status').AsString + '、注销'
      else
        EditUse.Text := FieldByName('C_Status').AsString;

      if FieldByName('C_Freeze').AsString = sFlag_Yes then
        EditFreeze.Text := FieldByName('C_Freeze').AsString + '、已冻结'
      else
        EditFreeze.Text := FieldByName('C_Freeze').AsString + '、未冻结';

      if FieldByName('c_used').AsString=sflag_sale then
      begin
        EditCType.Text := FieldByName('c_used').AsString + '、销售';
        QueryCard(EditCard.Text);
      end
      else if FieldByName('c_used').AsString=sFlag_Provide then begin
        EditCType.Text := FieldByName('c_used').AsString + '、供应';
        QueryPorderinfo(EditCard.Text);
      end
      else if FieldByName('c_used').AsString=sFlag_Mul then begin
        EditCType.Text := FieldByName('c_used').AsString + '、临时称重';
        QueryOtherInfo(EditCard.Text);
      end;
    end;

    Exit;
  end;
end;

procedure TfFormCardSearch.QueryCard(const nCard: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where L_Card=''%s''';
  nStr := Format(nStr, [sTable_Bill, nCard]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount < 1 then
    begin
      Exit;
    end;

    EditID.Text  := FieldByName('L_ID').AsString;
    EditCusName.Text   := FieldByName('L_CusName').AsString;
    EditTruck.Text := FieldByName('L_Truck').AsString;
    EditStockName.Text := FieldByName('L_StockName').AsString;
  end;
end;

procedure TfFormCardSearch.QueryPorderinfo(const nCard: string);
var nStr: string;
begin
  nStr := 'select * from %s where o_card=''%s''';
  nStr := Format(nStr, [sTable_Order, nCard]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount < 1 then
    begin
      Exit;
    end;

    EditID.Text  := FieldByName('O_ID').AsString;
    EditCusName.Text   := FieldByName('O_ProName').AsString;
    EditTruck.Text := FieldByName('O_Truck').AsString;
    EditStockName.Text := FieldByName('O_StockName').AsString;
  end;
end;

procedure TfFormCardSearch.QueryOtherInfo(const nCard: string);
var nStr: string;
begin
  nStr := 'select * from %s where o_card=''%s''';
  nStr := Format(nStr, [sTable_CardOther, nCard]);

  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount < 1 then
    begin
      Exit;
    end;

    EditID.Text  := FieldByName('R_ID').AsString;
    EditCusName.Text   := FieldByName('O_CusName').AsString;
    EditTruck.Text := FieldByName('O_Truck').AsString;
    EditStockName.Text := FieldByName('O_MName').AsString;
  end;
end;

//Desc: 保存磁卡
procedure TfFormCardSearch.BtnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormCardSearch, TfFormCardSearch.FormID);
end.
