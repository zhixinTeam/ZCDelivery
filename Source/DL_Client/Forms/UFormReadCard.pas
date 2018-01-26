{*******************************************************************************
  作者: fendou116688@163.com 2016/4/6
  描述: 读取磁卡编号
*******************************************************************************}
unit UFormReadCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxMemo, cxTextEdit,
  dxLayoutControl, StdCtrls, CPort;

type
  TfFormReadCard = class(TfFormNormal)
    EditCard: TcxTextEdit;
    dxlytmLayout1Item4: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxlytmLayout1Item5: TdxLayoutItem;
    ComPort1: TComPort;
    procedure BtnOKClick(Sender: TObject);
    procedure ComPort1RxChar(Sender: TObject; Count: Integer);
    procedure EditCardKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FBuffer: string;
    //接收缓冲
    procedure ActionComPort(const nStop: Boolean);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormWait, UFormBase, USysConst, USmallFunc,
  IniFiles, CPortTypes;

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

class function TfFormReadCard.FormID: integer;
begin
  Result := cFI_FormReadCard;
end;

class function TfFormReadCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  with TfFormReadCard.Create(Application) do
  try
    Caption := '读取磁卡编号';
    ActiveControl := EditCard;

    try
      ActionComPort(False);
    except
      on E: Exception do
      begin
        EditMemo.Text := E.Message;
      end;  
    end;
    
    if Assigned(nP) then
    begin
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      nP.FParamB := Trim(EditCard.Text);
    end else ShowModal;
  finally
    Free;
  end;
end;

procedure TfFormReadCard.EditCardKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if Sender = EditCard then
    begin
      BtnOKClick(nil);
    end;
  end;
end;

procedure TfFormReadCard.BtnOKClick(Sender: TObject);
begin
  BtnOK.Enabled := False;

  try
    EditMemo.Clear;
    EditCard.Text := Trim(EditCard.Text);
    
    if EditCard.Text = '' then
    begin
      ShowMsg('请输入磁卡编号', sHint);
      Exit;
    end;

    ModalResult   := mrOk;
  finally
    if ModalResult <> mrOk then
    begin
      BtnOK.Enabled := True;
      EditCard.SetFocus;
      EditCard.SelectAll;
    end;
  end;
end;

//Desc: 串口操作
procedure TfFormReadCard.ActionComPort(const nStop: Boolean);
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
    finally
      nIni.Free;
    end;

    if ComPort1.Port <> '' then
      ComPort1.Open;
    //xxxxx
  end;
end;

procedure TfFormReadCard.ComPort1RxChar(Sender: TObject; Count: Integer);
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

procedure TfFormReadCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ActionComPort(True);
end;

initialization
  gControlManager.RegCtrl(TfFormReadCard, TfFormReadCard.FormID);
end.
