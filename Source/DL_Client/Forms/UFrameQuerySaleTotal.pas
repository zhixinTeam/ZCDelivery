{*******************************************************************************
  作者: dmzn@163.com 2017-01-11
  描述: 发货明细
*******************************************************************************}
unit UFrameQuerySaleTotal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, IniFiles, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  StdCtrls, cxRadioGroup, cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB,
  cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameSaleDetailTotal = class(TfFrameNormal)
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
    cxtxtdt4: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    Radio1: TcxRadioButton;
    dxLayout1Item2: TdxLayoutItem;
    Radio2: TcxRadioButton;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure mniN1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FJBWhere: string;
    //交班条件
    FValue,FMoney: Double;
    //均价参数间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    function FilterColumnField: string; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
    procedure SummaryItemsGetText(Sender: TcxDataSummaryItem;
      const AValue: Variant; AIsFooter: Boolean; var AText: String);
    //处理摘要
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormDateFilter, USysPopedom, USysBusiness,
  UBusinessConst, USysConst, USysDB;

class function TfFrameSaleDetailTotal.FrameID: integer;
begin
  Result := cFI_FrameSaleTotalQuery;
end;

procedure TfFrameSaleDetailTotal.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameSaleDetailTotal.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameSaleDetailTotal.OnLoadGridConfig(const nIni: TIniFile);
var i,nCount: Integer;
begin
  with cxView1.DataController.Summary do
  begin
    nCount := FooterSummaryItems.Count - 1;
    for i:=0 to nCount do
      FooterSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件

    nCount := DefaultGroupSummaryItems.Count - 1;
    for i:=0 to nCount do
      DefaultGroupSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件
  end;

  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameSaleDetailTotal.InitFormDataSQL(const nWhere: string): string;
begin
  FEnableBackDB := True;
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if Radio1.Checked then
  begin
    Result := 'select L_SaleID,L_SaleMan,L_CusID,L_CusName,L_CusPY,' +
              'Sum(L_Value) as L_Value,Sum(L_Value * L_Price) as L_Money ' +
              'From $Bill ';
    //xxxxx
  end else
  begin
    Result := 'select L_SaleID,L_SaleMan,L_CusID,L_CusName,L_CusPY,L_Type,' +
              'L_StockNo,L_StockName,Sum(L_Value) as L_Value,' +
              'Sum(L_Value * L_Price) as L_Money From $Bill ';
    //xxxxx
  end;

  if FJBWhere = '' then
  begin
    Result := Result + 'Where (L_OutFact>=''$S'' and L_OutFact <''$End'')';

    if nWhere <> '' then
      Result := Result + ' And (' + nWhere + ')';
    //xxxxx
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  if Radio1.Checked then
  begin
    Result := Result + ' Group By L_SaleID,L_SaleMan,L_CusID,L_CusName,L_CusPY';
  end else
  begin
    Result := Result + ' Group By L_SaleID,L_SaleMan,L_CusID,L_CusName,L_CusPY,' +
              'L_Type,L_StockNo,L_StockName';
    //xxxxx
  end;

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx

  Result := 'Select *,(case L_Value when 0 then 0 else convert(decimal(15,2),' +
            'L_Money/L_Value) end) as L_Price From (' + Result + ') t';
  //计算均价
end;

//Desc: 过滤字段
function TfFrameSaleDetailTotal.FilterColumnField: string;
begin
  if gPopedomManager.HasPopedom(PopedomItem, sPopedom_ViewPrice) then
       Result := ''
  else Result := 'L_Price;L_Money';
end;

//Desc: 日期筛选
procedure TfFrameSaleDetailTotal.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameSaleDetailTotal.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 时间段查询
procedure TfFrameSaleDetailTotal.mniN1Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := '(L_OutFact>=''%s'' and L_OutFact <''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_BillPick, sFlag_BillPost]);
    InitFormData('');
  finally
    FJBWhere := '';
  end;
end;

//Desc: 处理均价
procedure TfFrameSaleDetailTotal.SummaryItemsGetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: String);
var nStr: string;
begin
  nStr := TcxGridDBColumn(TcxGridTableSummaryItem(Sender).Column).DataBinding.FieldName;
  try
    if CompareText(nStr, 'L_Value') = 0 then FValue := SplitFloatValue(AText);
    if CompareText(nStr, 'L_Money') = 0 then FMoney := SplitFloatValue(AText);

    if CompareText(nStr, 'L_Price') = 0 then
    begin
      if FValue = 0 then
           AText := '均价: 0.00元'
      else AText := Format('均价: %.2f元', [Round(FMoney / FValue * cPrecision) / cPrecision]);
    end;
  except
    //ignor any error
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSaleDetailTotal, TfFrameSaleDetailTotal.FrameID);
end.
