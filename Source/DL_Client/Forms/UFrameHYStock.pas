{*******************************************************************************
  作者: dmzn@163.com 2009-7-22
  描述: 品种管理
*******************************************************************************}
unit UFrameHYStock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, UFrameNormal,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameHYStock = class(TfFrameNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditType: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, USysFun, USysConst, USysGrid, USysDB, UMgrControl,
  UFormHYStock;

class function TfFrameHYStock.FrameID: integer;
begin
  Result := cFI_FrameStock;
end;

function TfFrameHYStock.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_StockParam;
  if nWhere <> '' then Result := Result + ' Where ' + nWhere
end;

//------------------------------------------------------------------------------
//Desc: 添加
procedure TfFrameHYStock.BtnAddClick(Sender: TObject);
begin
  if ShowStockAddForm then InitFormData('');
end;

//Desc: 编辑
procedure TfFrameHYStock.BtnEditClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('P_ID').AsString;
    if ShowStockEditForm(nStr) then InitFormData(FWhere);
  end else ShowMsg('请选择要编辑的记录', sHint);
end;

//Desc: 删除
procedure TfFrameHYStock.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('P_ID').AsString;
  if not QueryDlg('确定要删除编号为[ ' + nStr + ' ]的品种吗', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nSQL := 'Delete From %s Where P_ID=''%s''';
    nSQL := Format(nSQL, [sTable_StockParam, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where R_PID=''%s''';
    nSQL := Format(nSQL, [sTable_StockParamExt, nStr]);

    FDM.ExecuteSQL(nSQL);
    FDM.ADOConn.CommitTrans;

    InitFormData(FWhere);
    ShowMsg('记录已成功删除', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('记录删除失败', sError);
  end;
end;

//Desc: 查询
procedure TfFrameHYStock.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    FWhere := 'P_ID like ''%%' + EditID.Text + '%%''';
    InitFormData(FWhere);
  end else

  if Sender = EditType then
  begin
    FWhere := 'P_Stock like ''%%' + EditType.Text + '%%''';
    InitFormData(FWhere);
  end else
end;

initialization
  gControlManager.RegCtrl(TfFrameHYStock, TfFrameHYStock.FrameID);
end.
