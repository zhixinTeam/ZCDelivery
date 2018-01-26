unit UFormTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormBase, StdCtrls, ExtCtrls;

type
  TBaseForm1 = class(TBaseForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    FListA,FListB: TStrings;
    function ServerNow: string;
    function GetSerialNo(const nGroup,nObject: string): string;
    function IsSystemExpired: string;
    function PrintCode(const nBill: string): string;
    function SaveTruck(const nTruck,nPhone: string): string;
    function SaveBill(const nData: string): string;
    function ReverseBill(const nData: string): string;
    function GetBatcode: string;
    function GetPostItem(const nData: string): string;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TFormCreateResult; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  UBusinessWorker, UBusinessPacker, UBusinessConst, UMgrControl, UMgrDBConn,
  UPlugConst, USysDB, ULibFun, UMITConst;

var
  gForm: TBaseForm1 = nil;

class function TBaseForm1.CreateForm(const nPopedom: string;
  const nParam: Pointer): TFormCreateResult;
begin
  if not Assigned(gForm) then
    gForm := TBaseForm1.Create(Application);
  //xxxxx
  
  Result.FFormItem := gForm;
  gForm.Show;
end;

class function TBaseForm1.FormID: integer;
begin
  Result := cFI_FormTest2;
end;

procedure TBaseForm1.FormCreate(Sender: TObject);
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
end;

procedure TBaseForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  gForm := nil;
  FListA.Free;
  FListB.Free;
end;

procedure TBaseForm1.Button1Click(Sender: TObject);
var nItem: TDBASyncItem;
begin
  gDBConnManager.ASyncInitDB;
  gDBConnManager.ASyncInitItem(@nItem, True);
  memo1.Lines.Add(nItem.FSerialNo);

  nItem.FSQL := 'insert into s_bill(l_id) values(''aa'')';
  nItem.FIfQuery := 'select count(*) as no from s_bill where l_id=''aa''';
  nItem.FIfField := 'no';
  nItem.FIfType := arGreater;
  nItem.FIfValue := '0';
  nItem.FIfSQL := 'update s_bill set l_card=''11'' where l_id=''aa''';
  gDBConnManager.ASyncAdd(@nItem);
  gDBConnManager.ASyncApply(nItem.FSerialNo);
end;

//------------------------------------------------------------------------------
function CallBusinessCommand(const nCmd: Integer; const nData,nParma: string;
  const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPack: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPack := nil;
  nWorker := nil;
  try
    nPack := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);

    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nParma;
    nStr := nPack.PackIn(@nIn);

    Result := nWorker.WorkActive(nStr);
    if not Result then
    begin
      ShowDlg(nStr, sWarn);
      Exit;
    end;

    nPack.UnPackOut(nStr, nOut);
  finally
    gBusinessPackerManager.RelasePacker(nPack);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

function CallHardwareCommand(const nCmd: Integer; const nData,nParma: string;
  const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPack: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPack := nil;
  nWorker := nil;
  try
    nPack := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_HardwareCommand);

    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nParma;
    nStr := nPack.PackIn(@nIn);

    Result := nWorker.WorkActive(nStr);
    if not Result then
    begin
      ShowDlg(nStr, sWarn);
      Exit;
    end;

    nPack.UnPackOut(nStr, nOut);
  finally
    gBusinessPackerManager.RelasePacker(nPack);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

function CallBusinessBills(const nCmd: Integer; const nData,nParma: string;
  const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPack: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPack := nil;
  nWorker := nil;
  try
    nPack := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessSaleBill);

    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nParma;
    nStr := nPack.PackIn(@nIn);

    Result := nWorker.WorkActive(nStr);
    if not Result then
    begin
      ShowDlg(nStr, sWarn);
      Exit;
    end;

    nPack.UnPackOut(nStr, nOut);
  finally
    gBusinessPackerManager.RelasePacker(nPack);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

function TBaseForm1.GetSerialNo(const nGroup,nObject: string): string;
var nOut: TWorkerBusinessCommand;
begin
  FListA.Values['Group'] := nGroup;
  FListA.Values['Object'] := nObject;

  if CallBusinessCommand(cBC_GetSerialNO, FListA.Text, sFlag_Yes, @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.ServerNow: string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_ServerNow, '', '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.IsSystemExpired: string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_IsSystemExpired, '', '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.PrintCode(const nBill: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallHardwareCommand(cBC_PrintCode , nBill, '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.SaveTruck(const nTruck, nPhone: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_SaveTruckInfo , nTruck, nPhone, @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.SaveBill(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  FListA.Values['Truck'] := '111';

  if CallBusinessBills(cBC_SaveBills, PackerEncodeStr(FListA.Text), sFlag_Yes, @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.ReverseBill(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessBills(cBC_ReverseBill, '2700125826', sFlag_Yes, @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.GetBatcode: string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetStockBatcode , 'SNPC0325R1', '1000', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

function TBaseForm1.GetPostItem(const nData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessBills(cBC_GetPostBills, '333', sFlag_TruckFH, @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

procedure TBaseForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
       gDBConnManager.ASyncStart
  else gDBConnManager.ASyncStop;
end;

initialization
  gControlManager.RegCtrl(TBaseForm1, TBaseForm1.FormID, sPlug_ModuleHD);
end.
