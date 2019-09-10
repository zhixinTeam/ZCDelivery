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
    ComboBox1: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FListA,FListB: TStrings;
    function GetCustomerInfo: string;
    function GetOrderList: string;
    function CreatLadingOrder: string;
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

function CallWXCommand(const nCmd: Integer; const nData,nParma,nURL: string;
  const nOut: PWorkerWebChatData): Boolean;
var nStr: string;
    nIn: TWorkerWebChatData;
    nPack: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPack := nil;
  nWorker := nil;
  try
    nPack := gBusinessPackerManager.LockPacker(sBus_BusinessWebchat);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessWebchat);

    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nParma;
    nIn.FRemoteUL := nURL;
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
begin
  if ComboBox1.ItemIndex = 0 then
    Memo1.Text := GetOrderList()
  else
    Memo1.Text := CreatLadingOrder();
end;

function TBaseForm1.GetCustomerInfo: string;
var nOut: TWorkerWebChatData;
begin
  if CallWXCommand(cBC_WX_getCustomerInfo, '', '', '', @nOut) then
    Result := nOut.FData
  else Result := nOut.FData;
end;

function TBaseForm1.GetOrderList: string;
var nOut: TWorkerWebChatData;
begin
  if CallWXCommand(cBC_WX_GetOrderList, Edit1.Text, '', '', @nOut) then
    Result := nOut.FData
  else Result := nOut.FData;
end;

function TBaseForm1.CreatLadingOrder: string;
var nOut: TWorkerWebChatData;
begin
  if CallWXCommand(cBC_WX_CreatLadingOrder, Edit1.Text, '', '', @nOut) then
    Result := nOut.FData
  else Result := nOut.FData;
end;

initialization
  gControlManager.RegCtrl(TBaseForm1, TBaseForm1.FormID, sPlug_ModuleHD);
end.
