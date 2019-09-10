{*******************************************************************************
  作者: dmzn@163.com 2012-03-26
  描述: 发货明细
*******************************************************************************}
unit UFrameQueryWXSynInfo;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, IniFiles, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxCheckBox;

type
  TfFrameQueryWXSynInfo = class(TfFrameNormal)
    cxtxtdt1: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxtxtdt2: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    pmPMenu1: TPopupMenu;
    mniN1: TMenuItem;
    cxtxtdt3: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxtxtdt4: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditBill: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    chkAll: TcxCheckBox;
    dxLayout1Item9: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure mniN1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FJBWhere: string;
    //交班条件
    FValue,FMoney: Double;
    //均价参数
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB, UDataModule, UBusinessPacker;

class function TfFrameQueryWXSynInfo.FrameID: integer;
begin
  Result := cFI_FrameQueryWXSynInfo;
end;

procedure TfFrameQueryWXSynInfo.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameQueryWXSynInfo.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameQueryWXSynInfo.OnLoadGridConfig(const nIni: TIniFile);
begin

  inherited;
end;

function TfFrameQueryWXSynInfo.InitFormDataSQL(const nWhere: string): string;
begin
  FEnableBackDB := True;
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  Result := ' Select * From $Sync b ';
  //同步记录
  Result := MacroValue(Result, [MI('$Sync', sTable_HHJYSync)]);
end;

//Desc: 过滤字段
function TfFrameQueryWXSynInfo.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price;L_Money';
end;

//Desc: 日期筛选
procedure TfFrameQueryWXSynInfo.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameQueryWXSynInfo.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  //
end;

//Desc: ERP同步上传
procedure TfFrameQueryWXSynInfo.mniN1Click(Sender: TObject);
var nStr: string;
begin
  inherited;

  nStr := '确认ERP上传失败记录重新上传吗?';
  if not QueryDlg(nStr, sHint) then Exit;

  nStr := ' Update %s Set H_SyncNum = 0 ' +
          ' Where H_Deleted = ''%s'' ';
  nStr := Format(nStr, [sTable_HHJYSync, sFlag_No]);
  FDM.ExecuteSQL(nStr);
  ShowMsg('ERP上传失败记录重新上传完成', sHint);
end;

procedure TfFrameQueryWXSynInfo.N2Click(Sender: TObject);
var nPID, nStr,nPreFix: string;
    nList: TStrings;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nPID := SQLQuery.FieldByName('L_ID').AsString;

    nPreFix := 'WY';
    nStr := 'Select B_Prefix From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nPreFix := Fields[0].AsString;
    end;

    if Pos(nPreFix,SQLQuery.FieldByName('L_ZhiKa').AsString) > 0 then
    begin
      nStr := Format('提货单[ %s ]非ERP订单,无法上传', [nPID]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nStr := Format('确认上传提货单[ %s ]吗?', [nPID]);
    if not QueryDlg(nStr, sHint) then Exit;

    if SQLQuery.FieldByName('L_OutFact').AsString = '' then
    begin
      nStr := Format('提货单[ %s ]未出厂,无法上传', [nPID]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    nList := TStringList.Create;
    nList.Values['ID'] := SQLQuery.FieldByName('L_ID').AsString;
    nList.Values['Status'] := '1';

    nStr := PackerEncodeStr(nList.Text);
    try
      if not SyncHhSaleDetailWSDL(nStr) then
      begin
        ShowMsg('提货单上传失败',sHint);
        Exit;
      end;
    finally
      nList.Free;
    end;

    ShowMsg('上传成功',sHint);
    InitFormData('');
  end;
end;

procedure TfFrameQueryWXSynInfo.N3Click(Sender: TObject);
var nLID, nStr,nPreFix,nHint: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nLID := SQLQuery.FieldByName('L_ID').AsString;

    nPreFix := 'WY';
    nStr := 'Select B_Prefix From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_SaleOrderOther]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nPreFix := Fields[0].AsString;
    end;

    if Pos(nPreFix,SQLQuery.FieldByName('L_ZhiKa').AsString) > 0 then
    begin
      nStr := Format('提货单[ %s ]非ERP订单,无法更新', [nLID]);
      ShowMsg(nStr, sHint);
      Exit;
    end;

    if not PoundVerifyHhSalePlanWSDL(nLID,
           SQLQuery.FieldByName('L_Value').AsFloat,
           SQLQuery.FieldByName('L_OutFact').AsString, nHint) then
    begin
      ShowMsg('更新失败',sHint);
    end;
    InitFormData('');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQueryWXSynInfo, TfFrameQueryWXSynInfo.FrameID);
end.

