{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 车辆调度模式
*******************************************************************************}
unit UFormZTMode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxLabel, cxRadioGroup;

type
  TfFormZTMode = class(TfFormNormal)
    Radio1: TcxRadioButton;
    dxLayout1Item3: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    Radio2: TcxRadioButton;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FMode: Byte;
    function GetModeID: Byte;
    function ModeToName(const nMode: Byte): string;
    procedure InitFormData(const nID: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

function ShowZTModeForm: Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  ULibFun, UDataModule, USysBusiness, USysDB, USysConst;

function ShowZTModeForm: Boolean;
begin
  with TfFormZTMode.Create(Application) do
  try
    Caption := '车辆调度模式切换';
    InitFormData('');
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

class function TfFormZTMode.FormID: integer;
begin
  Result := 0;
end;

class function TfFormZTMode.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
end;

function TfFormZTMode.GetModeID: Byte;
begin
  if Radio1.Checked then Result := 1 else
  if Radio2.Checked then Result := 2 else Result := 0;
end;

function TfFormZTMode.ModeToName(const nMode: Byte): string;
begin
  case nMode of
   1: Result := '正常模式';
   2: Result := '预开模式' else Result := '未知';
  end;
end;

procedure TfFormZTMode.InitFormData(const nID: string);
var nStr: string;
begin
  Radio1.Checked  := True;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_SanMultiBill]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Radio2.Checked := Fields[0].AsString = sFlag_Yes;
    //允许散装多单
  end;

  FMode := GetModeID;
end;

procedure TfFormZTMode.BtnOKClick(Sender: TObject);
var nMode: Byte;
    nStr: string;
begin
  nMode := GetModeID;
  if nMode <> FMode then
  begin
    if not ChangeDispatchMode(nMode) then Exit;
    nStr := '切换调度模式[ %s -> %s ]';
    nStr := Format(nStr, [ModeToName(FMode), ModeToName(nMode)]);
    FDM.WriteSysLog(sFlag_TruckQueue, 'TfFormZTMode', nStr, False);
  end;

  ModalResult := mrOk;
  ShowMsg('模式切换成功', sHint);
end;

end.
