{*******************************************************************************
  作者: dmzn@163.com 2009-8-4
  描述: 报表处理模块
*******************************************************************************}
unit UDataReport;

{$I Link.Inc}
interface

uses
  SysUtils, Classes, frxClass, frxDesgn, frxDBSet, frxCross, frxRich,
  frxGradient, UHotKeyManager, UFormInputbox;

type
  PReportParamItem = ^TReportParamItem;
  TReportParamItem = record
    FName: string;
    FValue: Variant;
  end;

  TFDR = class(TDataModule)
    Report1: TfrxReport;
    Dataset1: TfrxDBDataset;
    Dataset2: TfrxDBDataset;
    Dataset3: TfrxDBDataset;
    Designer1: TfrxDesigner;
    Rich1: TfrxRichObject;
    Cross1: TfrxCrossObject;
    UserDS1: TfrxUserDataSet;
    Gradient1: TfrxGradientObject;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Report1GetValue(const VarName: String; var Value: Variant);
    procedure Report1AfterPrintReport(Sender: TObject);
  private
    { Private declarations }
    FParamList: TList;
    {*参数列表*}
    FReportFile: string;
    {*报表文件*}
    FHotKey: Cardinal;
    FHotKeyOver: Boolean;
    FHotKeyMgr: THotKeyManager;
    {*报表热键*}
    FPrintSuccess: Boolean;
    {*成功打印*}
    procedure DisposeParamItem(const nItem: PReportParamItem);
    procedure ClearParamList(const nFree: Boolean);
    {*清理资源*}
    procedure DoHotKeyHotKeyPressed(HotKey: Cardinal; Index: Word);
    {*热键处理*}
  public
    { Public declarations }
    procedure ShowReport;
    procedure DesignReport;
    function PrintReport: Boolean;
    function LoadReportFile(const nFile: string): Boolean;
    {*报表相关*}
    function AddParamItem(const nItem: TReportParamItem): Integer;
    function DeleteParamItem(const nName: string): Integer;
    procedure ClearParamItems;
    {*参数管理*}
    function GetParamItemIndex(const nName: string): integer;
    {*参数检索*}
    property ParamList: TList read FParamList;
    property ReportFile: string read FReportFile;
    property MainReport: TfrxReport read Report1;
    property PrintSuccess: Boolean read FPrintSuccess;
    property DatasetA: TfrxDBDataset read Dataset1;
    property DatasetB: TfrxDBDataset read Dataset2;
    property DatasetC: TfrxDBDataset read Dataset3;
    property UserDatasetA: TfrxUserDataSet read UserDS1;
    {*属性相关*}
  end;

var
  FDR: TFDR;

implementation

{$R *.dfm}

procedure TFDR.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF TrialVersion}
  with Report1.PreviewOptions do
    Buttons := Buttons - [pbPrint];
  //trial version no print
  {$ENDIF}

  FParamList := TList.Create;
  FHotKeyOver := True;

  FHotKeyMgr := THotKeyManager.Create(Self);
  FHotKeyMgr.OnHotKeyPressed := DoHotKeyHotKeyPressed;

  FHotKey := TextToHotKey('Ctrl + Alt + D', False);
  FHotKeyMgr.AddHotKey(FHotKey);
end;

procedure TFDR.DataModuleDestroy(Sender: TObject);
begin
  ClearParamList(True);
end;

//------------------------------------------------------------------------------
//Desc: 释放参数项
procedure TFDR.DisposeParamItem(const nItem: PReportParamItem);
begin
  Dispose(nItem);
end;

//Desc: 清理参数列表
procedure TFDR.ClearParamList(const nFree: Boolean);
var nIdx: integer;
begin
  for nIdx:=FParamList.Count - 1 downto 0 do
  begin
    DisposeParamItem(FParamList[nIdx]);
    FParamList.Delete(nIdx);
  end;

  if nFree then FParamList.Free;
end;

//Desc: 清空参数
procedure TFDR.ClearParamItems;
begin
  ClearParamList(False);
end;

//Desc: 添加参数项
function TFDR.AddParamItem(const nItem: TReportParamItem): Integer;
var nP: PReportParamItem;
begin
  Result := GetParamItemIndex(nItem.FName);
  if Result < 0 then
  begin
    New(nP);
    Result := FParamList.Add(nP);
  end;

  with PReportParamItem(FParamList[Result])^ do
  begin
    FName := nItem.FName;
    FValue := nItem.FValue;
  end;
end;

//Desc: 删除nName参数
function TFDR.DeleteParamItem(const nName: string): Integer;
begin
  Result := GetParamItemIndex(nName);
  if Result > -1 then
  begin
    DisposeParamItem(FParamList[Result]);
    FParamList.Delete(Result);
  end;
end;

//Desc: 获取nName参数的索引位置
function TFDR.GetParamItemIndex(const nName: string): integer;
var nIdx,nLen: integer;
begin
  Result := -1;
  nLen := FParamList.Count - 1;

  for nIdx:=0 to nLen do
  if CompareText(nName, PReportParamItem(FParamList[nIdx]).FName) = 0 then
  begin
    Result := nIdx; Break;
  end;
end;

//Desc: 载入nFile报表文件
function TFDR.LoadReportFile(const nFile: string): Boolean;
begin
  Result := nFile = FReportFile;
  
  if not Result  then
  try
    if FileExists(nFile) then
    begin
      Result := Report1.LoadFromFile(nFile);
      FReportFile := nFile;
    end else Result := False;
  except
    Result := False;
  end;
end;

//Desc: 设计报表
procedure TFDR.DesignReport;
begin
  FPrintSuccess := False;
  Report1.DesignReport;
end;

//Desc: 预览报表
procedure TFDR.ShowReport;
begin
  FPrintSuccess := False;
  Report1.ShowReport;
end;

//Desc: 打印报表
function TFDR.PrintReport: Boolean;
var nBool: Boolean;
begin
  nBool := Report1.PrintOptions.ShowDialog;
  Report1.PrintOptions.ShowDialog := False;
  try
    Report1.PrepareReport;
    Result := Report1.Print;
  finally
    Report1.PrintOptions.ShowDialog := nBool;
  end;
end;

//Desc: 获取
procedure TFDR.Report1GetValue(const VarName: String; var Value: Variant);
var nIdx: integer;
begin
  nIdx := GetParamItemIndex(VarName);
  if nIdx < 0 then
  begin
    Value := '-';
  end else
  begin
    Value := PReportParamItem(FParamList[nIdx]).FValue;
  end;
end;

//Desc: 真正打印结束
procedure TFDR.Report1AfterPrintReport(Sender: TObject);
begin
  FPrintSuccess := True;
end;

//Desc: 设计报表
procedure TFDR.DoHotKeyHotKeyPressed(HotKey: Cardinal; Index: Word);
var nStr: string;
begin
  if FHotKeyOver and (HotKey = FHotKey) then
  try
    FHotKeyOver := False;
    {$IFNDEF DEBUG}
    if ShowInputPWDBox('请输入解锁密码:', '报表设计器', nStr) and
       (nStr = 'admin_dmzn') then
    {$ENDIF} DesignReport;
  finally
    FHotKeyOver := True;
  end;
end;

end.
