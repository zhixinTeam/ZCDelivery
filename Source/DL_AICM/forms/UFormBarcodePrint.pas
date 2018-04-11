{*******************************************************************************
  作者: 289525016@163.com 2017-4-9
  描述: 扫描二维码打印化验单
*******************************************************************************}
unit UFormBarcodePrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   UFormNormal, UFormBase, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxTextEdit,
  dxLayoutControl, StdCtrls, cxGraphics, dxLayoutcxEditAdapters, ExtCtrls,
  CPort, Menus, cxButtons;

type
  TfFormBarcodePrint = class(TfFormNormal)
    editWebOrderNo: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item3: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    btnClear: TcxButton;
    dxLayout1Item6: TdxLayoutItem;
    TimerAutoClose: TTimer;
    procedure BtnOKClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure editWebOrderNoKeyPress(Sender: TObject; var Key: Char);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure editWebOrderNoPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FAutoClose:Integer;
    FParam: PFormCommandParam;
    function GetHYDan(const nwebOrderid:string; var nHYDan,nStockname,nStockno:string):Boolean;
    procedure Writelog(nMsg:string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, USysBusiness, USmallFunc, USysConst, USysDB,
  UDataModule,USysLoger;

class function TfFormBarcodePrint.FormID: integer;
begin
  Result := cFI_FormBarCodePrint;
end;

class function TfFormBarcodePrint.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(nParam) then Exit;
  with TfFormBarcodePrint.Create(Application) do
  try
    editWebOrderNo.Properties.MaxLength := gSysParam.FWebOrderLength;
    FAutoClose := 20;
    TimerAutoClose.Interval := 1000;
    TimerAutoClose.Enabled := True;
    ActiveControl := editWebOrderNo;
    FParam := nParam;
    FParam.FCommand := cCmd_ModalResult;
    FParam.FParamA := ShowModal;
  finally
    Free;
  end;

end;

procedure TfFormBarcodePrint.BtnOKClick(Sender: TObject);
var
  nWebOrderID:string;
  nHyDan,nstockname,nstockno:string;
  nMsg:string;
begin
  nWebOrderID := Trim(editWebOrderNo.Text);
  if nWebOrderID='' then
  begin
    nMsg:= '请录入或扫描二维码';
    ShowMsg(nMsg,sHint);
    Exit;
  end;
  if not GetHYDan(nWebOrderID,nHyDan,nstockname,nstockno) then Exit;
  FParam.FParamB := nHyDan;
  FParam.FParamC := nstockname;
  FParam.FParamD := nstockno;
  ModalResult := mrok;
end;

function TfFormBarcodePrint.GetHYDan(const nwebOrderid:string;var nHYDan,nStockname,nStockno: string): Boolean;
var
  nStr:string;
  nBillno:string;
  nMsg:string;
  nStatus:string;
begin
  Result := False;
  nStr := 'select * from %s where WOM_WebOrderID=''%s'' and WOM_deleted=''%s''';
  nStr := Format(nStr,[sTable_WebOrderMatch,nwebOrderid,sFlag_No]);

  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount<1 then
    begin
      nMsg := '商城订单号不存在或已删除';
      ShowMsg(nMsg,sHint);
      Writelog(nMsg);
      Exit;
    end;
    nBillno := FieldByName('WOM_LID').AsString;
  end;

  nStr := 'select L_Status,L_HYDan,L_StockName,l_Stockno from %s where L_ID=''%s''';
  nStr := Format(nStr,[sTable_Bill,nBillno]);
  with fdm.QueryTemp(nStr) do
  begin
    if RecordCount<1 then
    begin
      nMsg := '提货单不存在或已删除';
      ShowMsg(nMsg,sHint);
      Writelog(nMsg);
      Exit;
    end;
    nStatus := FieldByName('L_Status').AsString;
    if (nStatus<>sFlag_TruckBFM) and (nStatus<>sFlag_TruckOut) then
    begin
      nMsg := '请在称完毛重或者车辆出厂后再扫描二维码图片打印化验单';
      ShowMsg(nMsg,sHint);
      Writelog(nMsg);
      Exit;
    end;
    nHYDan := FieldByName('L_HYDan').AsString;
    nStockName := FieldByName('L_StockName').AsString;
    nStockno := FieldByName('l_Stockno').AsString;
    Result := True;
  end;  
end;

procedure TfFormBarcodePrint.btnClearClick(Sender: TObject);
begin
  editWebOrderNo.Clear;
  self.ActiveControl := editWebOrderNo;
  FAutoClose := 20;
end;

procedure TfFormBarcodePrint.Writelog(nMsg: string);
var
  nStr:string;
begin
  nStr := 'weborder[%s]';
  nStr := Format(nStr,[editWebOrderNo.Text]);
  gSysLoger.AddLog(nStr+nMsg);
end;

procedure TfFormBarcodePrint.editWebOrderNoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=Char(vk_return) then
  begin
    key := #0;
    btnok.Click;
  end;
end;

procedure TfFormBarcodePrint.TimerAutoCloseTimer(Sender: TObject);
begin
  if FAutoClose=0 then
  begin
    BtnExit.Click;
  end;
  Dec(FAutoClose);
end;

procedure TfFormBarcodePrint.editWebOrderNoPropertiesChange(
  Sender: TObject);
begin
  FAutoClose := 20;
end;

initialization
  gControlManager.RegCtrl(TfFormBarcodePrint, TfFormBarcodePrint.FormID);
end.
