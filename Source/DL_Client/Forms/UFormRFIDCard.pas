{*******************************************************************************
  作者: fendou116688@163.com 2015/1/11
  描述: 电子标签发卡模块
*******************************************************************************}
unit UFormRFIDCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormBase, UFormNormal, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ExtCtrls, cxCheckBox,
  cxTextEdit, dxLayoutControl, StdCtrls, cxGraphics;

type
  TfFormRFIDCard = class(TfFormNormal)
    tmrReadCard: TTimer;
    edtTruck: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    edtRFIDCard: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    chkValue: TcxCheckBox;
    dxLayout1Item4: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure edtRFIDCardKeyPress(Sender: TObject; var Key: Char);
    procedure tmrReadCardTimer(Sender: TObject);
  private
    { Private declarations }
    FParam: PFormCommandParam;
    procedure InitFormData;
    function  ActionComPort(const nStop: Boolean):Boolean;
    function  GetStr(nPStr: PChar; nLen: Integer): string;
    function  GetHexStr(nBinStr: string): string;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

var
  fFormRFIDCard: TfFormRFIDCard;

implementation

uses
  IniFiles, UMgrRFID102_Head, USmallFunc, ULibFun, UMgrControl, USysDB,
  USysLoger, USysConst;

type
  TReaderType = (ptT800, pt8142);
  //表头类型

  TReaderItem = record
    FType: TReaderType;
    FPort: Integer;
    FBaud: Byte;
    FDataBit: Integer;
    FStopBit: Integer;
    FReadAddr: Byte;
    FReadIndex: Integer;
    FCheckMode: Integer;
  end;

var
  gReaderItem: TReaderItem;
  //全局使用

const
  gRFIDBuffSize    = 2048;
  gRFIDReadCardCmd = '04FF011BB4'; //读卡指令 16进制

{$R *.dfm}

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFormRFIDCard, '电子标签模块', nEvent);
end;

class function TfFormRFIDCard.FormID: integer;
begin
  Result := cFI_FormMakeRFIDCard;
end;

class function TfFormRFIDCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;

  with TfFormRFIDCard.Create(Application) do
  try
    FParam := nParam;
    InitFormData;
    if not ActionComPort(False) then Exit;
    
    tmrReadCard.Enabled := True;
    chkValue.Checked := FParam.FParamC = sFlag_Yes;

    FParam.FCommand := cCmd_ModalResult;
    FParam.FParamA  := ShowModal;
    FParam.FParamB  := Trim(edtRFIDCard.Text);

    if chkValue.Checked then
         FParam.FParamC := sFlag_Yes
    else FParam.FParamC := sFlag_No;
  finally
    Free;
  end;
end;

procedure TfFormRFIDCard.InitFormData;
begin
  ActiveControl := edtRFIDCard;
  edtTruck.Text := FParam.FParamA;
  edtRFIDCard.Text := FParam.FParamB;
end;

procedure TfFormRFIDCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  ActionComPort(True);
  tmrReadCard.Enabled := False;
end;

procedure TfFormRFIDCard.BtnOKClick(Sender: TObject);
var nRFIDCard: string;
begin
  inherited;
  nRFIDCard := Trim(edtRFIDCard.Text);
  if nRFIDCard = '' then
  begin
    ActiveControl := edtRFIDCard;
    edtRFIDCard.SelectAll;
    ModalResult := mrCancel;

    ShowMsg('请输入有效电子标签', sHint);
    Exit;
  end;

  ModalResult := mrOk;
  //done
end;

procedure TfFormRFIDCard.edtRFIDCardKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    Key := #0;
    BtnOK.Click;
  end else OnCtrlKeyPress(Sender, Key);
end;

procedure TfFormRFIDCard.tmrReadCardTimer(Sender: TObject);
var
  nStr, nSEPC, nCard, nTemps: string;
  nEPC: array[0..gRFIDBuffSize-1] of Char;
  nStartAddr, nCmdRet, nTotallen, nCardNum, nCardIndex, nEPClen: Integer;
begin
  inherited;
  nCmdRet := Inventory_G2(gReaderItem.FReadAddr, 0, 0, 0, nEPC, nTotallen,
    nCardNum, gReaderItem.FReadIndex);
  //xxxxxx

  case nCmdRet of
  $01, $02, $03:
  begin
    nTemps :=GetStr(nEPC,nTotallen);

    nStartAddr:=1;
    for nCardIndex := 1 to nCardNum do
    begin
      nEPClen    := Ord(nTemps[nStartAddr]) + 1;
      nSEPC      := Copy(nTemps, nStartAddr, nEPClen) ;

      nStartAddr := nStartAddr + nEPClen;
      if Length(nSEPC) <> nEPClen then Continue;
      nStr := GetHexStr(nSEPC);

      nCard := Copy(nStr, 3, Length(nStr)-2);
    end;
  end;
  end;

  if nCard <> '' then
  begin
    tmrReadCard.Enabled := False;
    edtRFIDCard.Text := nCard;
  end;  
end;

//Desc: 串口操作
function TfFormRFIDCard.ActionComPort(const nStop: Boolean):Boolean;
var nStr: string;
    nInt: Integer;
    nIni: TIniFile;
begin
  Result := False;
  if nStop then
  begin
    CloseComPort;
    Exit;
  end;

  nIni := TIniFile.Create(gPath + 'RFIDReader.Ini');
  with gReaderItem do
  try
    nInt := nIni.ReadInteger('Param', 'Type', 1);
    FType := TReaderType(nInt - 1);

    FPort := nIni.ReadInteger('Param', 'Port', 0);
    FBaud := nIni.ReadInteger('Param', 'Rate', 5);
    FDataBit := nIni.ReadInteger('Param', 'DataBit', 8);
    FStopBit := nIni.ReadInteger('Param', 'StopBit', 0);
    FReadAddr := nIni.ReadInteger('Param', 'Address', $FF);
    FReadIndex := nIni.ReadInteger('Param', 'Index', -1);
    FCheckMode := nIni.ReadInteger('Param', 'CheckMode', 0);
  finally
    nIni.Free;
  end;

  case gReaderItem.FPort of
  0:
    nInt := AutoOpenComPort(gReaderItem.FPort, gReaderItem.FReadAddr,
      gReaderItem.FBaud, gReaderItem.FReadIndex);
  else
    nInt := OpenComPort(gReaderItem.FPort, gReaderItem.FReadAddr,
      gReaderItem.FBaud, gReaderItem.FReadIndex);
  end;

  if nInt <> 0 then
  begin
    nStr := '电子标签读卡器打开失败,错误码[0x%s]';
    nStr := Format(nStr, [IntToHex(nInt, 2)]);
    //xxxxxx

    WriteLog(nStr);
    ShowMsg(nStr, '提示');
    Exit;
  end;

  Result := True;
end;

function TfFormRFIDCard.GetStr(nPStr: PChar; nLen: Integer): string;
var
  nIdx: Integer;
begin
  Result := '';
  for nIdx := 0 to nLen - 1 do
    Result := Result + (nPStr + nIdx)^;
end;

function TfFormRFIDCard.GetHexStr(nBinStr: string): string; //获得十六进制字符串
var
  nIdx: Integer;
begin
  Result := '';
  for nIdx := 1 to Length(nBinStr) do
    Result := Result + IntToHex(ord(nBinStr[nIdx]), 2);
end;

initialization
  gControlManager.RegCtrl(TfFormRFIDCard, TfFormRFIDCard.FormID);
end.
