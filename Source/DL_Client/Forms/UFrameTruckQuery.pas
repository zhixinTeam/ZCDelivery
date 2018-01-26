{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 出入车辆查询
*******************************************************************************}
unit UFrameTruckQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxMaskEdit, cxButtonEdit, cxTextEdit, Menus,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameTruckQuery = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FFilteDate: Boolean;
    //筛选日期
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter;

class function TfFrameTruckQuery.FrameID: integer;
begin
  Result := cFI_FrameTruckQuery;
end;

procedure TfFrameTruckQuery.OnCreateFrame;
begin
  inherited;
  FFilteDate := True;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTruckQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameTruckQuery.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  //xxxxx
  Result := 'Select * from $Bill b ';
               
  if FFilteDate then
    Result := Result + 'Where ((L_InTime>=''$S'' and L_InTime <''$End'') Or ' +
            '(L_OutFact>=''$S'' and L_OutFact <''$End''))';
  //xxxxx

  if nWhere <> '' then
    if FFilteDate then
         Result := Result + ' And (' + nWhere + ')'
    else Result := Result + ' Where (' + nWhere + ')';
  //xxxxx
  
  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

procedure TfFrameTruckQuery.AfterInitFormData;
begin
  FFilteDate := True;
  inherited;         
end;

//Desc: 日期筛选
procedure TfFrameTruckQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameTruckQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'L_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 快捷菜单
procedure TfFrameTruckQuery.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: //显示全部
     begin
       FWhere := '';
       InitFormData;
     end;
    20: //未出厂
     begin
       FFilteDate := False;
       FWhere := 'L_InTime Is Not Null And L_OutFact Is Null';
       InitFormData(FWhere);
     end;
    30: //已出厂
     begin
       FWhere := '';
       InitFormData('L_OutFact Is not Null');
     end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTruckQuery, TfFrameTruckQuery.FrameID);
end.
