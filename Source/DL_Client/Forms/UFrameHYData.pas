{*******************************************************************************
  作者: dmzn@163.com 2009-6-12
  描述: 开化验单
*******************************************************************************}
unit UFrameHYData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, UBitmapPanel,
  cxSplitter, Menus, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameHYData = class(TfFrameNormal)
    EditNO: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N3: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, USysConst, USysDB, UDataModule,
  UFormDateFilter, USysBusiness;

class function TfFrameHYData.FrameID: integer;
begin
  Result := cFI_FrameStockHuaYan;
end;

procedure TfFrameHYData.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameHYData.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;                        
end;

//------------------------------------------------------------------------------
//Desc: 数据查询SQL
function TfFrameHYData.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select hy.*,P_Name,P_QLevel,L_CusPY,L_CusName,L_Type,L_StockNo,' +
            'L_StockName From $HY hy ' +
            ' Left Join $Bill b On b.L_ID=hy.H_Bill ' +
            ' Left Join $SP sp On sp.P_Stock=b.L_StockNo ' +
            'Where ';
  //xxxxx
  
  if nWhere = '' then
       Result := Result + '(H_ReportDate>=''$Start'' and H_ReportDate<''$End'')'
  else Result := Result + '(' + nWhere + ')';

  Result := MacroValue(Result, [
            MI('$HY', sTable_StockHuaYan), MI('$Bill', sTable_Bill),
            MI('$SP', sTable_StockParam), MI('$SR', sTable_StockRecord),
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFrameHYData.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormStockHuaYan, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 删除
procedure TfFrameHYData.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('H_ID').AsString;
  if QueryDlg('确定要删除编号为[ ' + nStr + ' ]的化验单吗', sAsk) then
  begin
    nSQL := 'Delete From %s Where H_ID=%s';
    nSQL := Format(nSQL, [sTable_StockHuaYan, nStr]);
    FDM.ExecuteSQL(nSQL);

    InitFormData(FWhere);
    ShowMsg('已成功删除记录', sHint);
  end;
end;

//Desc: 日期筛选
procedure TfFrameHYData.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameHYData.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := '(H_ReportDate>=''$Start'' and H_ReportDate<''$End'') And ' +
              ' H_Truck Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditNO then
  begin
    EditNO.Text := Trim(EditNO.Text);
    if EditNO.Text = '' then Exit;

    FWhere := Format('H_SerialNo Like ''%%%s%%''', [EditNO.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'L_CusName like ''%%%s%%'' Or L_CusPY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 化验单
procedure TfFrameHYData.N1Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('H_ID').AsString;
    PrintHuaYanReport(nStr, False);
  end;
end;

//Desc: 合格证
procedure TfFrameHYData.N2Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('H_ID').AsString;
    PrintHeGeReport(nStr, False);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameHYData, TfFrameHYData.FrameID);
end.
