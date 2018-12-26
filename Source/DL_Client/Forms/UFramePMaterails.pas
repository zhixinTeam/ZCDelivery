{*******************************************************************************
  作者: dmzn@163.com 2009-7-2
  描述: 原材料
*******************************************************************************}
unit UFramePMaterails;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus;

type
  TfFrameMaterails = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N1: TMenuItem;
    N7: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule,
  UFormBase, USysBusiness, UFormCtrl;

class function TfFrameMaterails.FrameID: integer;
begin
  Result := cFI_FrameMaterails;
end;

function TfFrameMaterails.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Materails;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  Result := Result + ' Order By M_Name';
end;

//Desc: 添加
procedure TfFrameMaterails.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormMaterails, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameMaterails.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('M_ID').AsString;
    CreateBaseFormItem(cFI_FormMaterails, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: 删除
procedure TfFrameMaterails.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('M_Name').AsString;
    nStr := Format('确定要删除原材料[ %s ]吗?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Materails, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: 查询
procedure TfFrameMaterails.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := Format('M_Name Like ''%%%s%%''', [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

procedure TfFrameMaterails.PopupMenu1Popup(Sender: TObject);
begin
  inherited;

  {$IFDEF COMMON}
  N2.Visible := True;
  N3.Visible := True;
  {$ENDIF}
end;

procedure TfFrameMaterails.N2Click(Sender: TObject);
var nStr: string;
    nStockName, nStockID, nStockType: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('M_Name').AsString;
    nStr := Format('确定要将材料[ %s ]设为发货品种吗?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStockID := SQLQuery.FieldByName('M_ID').AsString;
    nStockName := SQLQuery.FieldByName('M_Name').AsString;

    if Pos('袋', nStockName) > 0 then
         nStockType := sFlag_Dai
    else nStockType := sFlag_San;

    nStr := 'Select count(*) From %s Where D_Name=''%s'' And D_ParamB=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem, nStockID]);
    with FDM.QueryTemp(nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('D_Name', sFlag_StockItem),
              SF('D_Desc', '水泥类型'),
              SF('D_ParamA', 0, sfVal),
              SF('D_ParamB', nStockID),
              SF('D_Value', nStockName),
              SF('D_Memo', nStockType)], sTable_SysDict, '', True);
      FDM.ExecuteSQL(nStr);

      nStr := 'Update %s Set M_IsSale=''%s'' Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Materails, sFlag_Yes, nStockID]);
      FDM.ExecuteSQL(nStr);
    end;

    InitFormData(FWhere);
  end;
end;

procedure TfFrameMaterails.N3Click(Sender: TObject);
var nStr, nStockID: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('M_Name').AsString;
    nStr := Format('确定要取消材料[ %s ]的发货品种吗?', [nStr]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStockID := SQLQuery.FieldByName('M_ID').AsString;
    nStr := 'Delete From %s Where D_Name=''%s'' And D_ParamB=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem, nStockID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set M_IsSale=''%s'' Where M_ID=''%s''';
    nStr := Format(nStr, [sTable_Materails, sFlag_No, nStockID]);
    FDM.ExecuteSQL(nStr);
    
    InitFormData(FWhere);
  end;
end;

procedure TfFrameMaterails.N5Click(Sender: TObject);
var nStr, nSQL, nTmp: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount < 1 then  Exit;

  nStr := SQLQuery.FieldByName('M_Name').AsString;
  nStr := Format('确定要将该品种[ %s ] %s 吗?', [nStr, TMenuItem(Sender).Caption]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nStr := SQLQuery.FieldByName('M_ID').AsString;
  //StockNO

  if SQLQuery.FieldByName('M_IsSale').AsString = sFlag_Yes then
       nTmp := '现场不发货'
  else nTmp := '现场不验收';

  case TMenuItem(Sender).Tag of
  1:
  begin
    nSQL := 'Delete From %s Where D_Name=''%s'' And D_Value=''%s''';
    nSQL := Format(nSQL, [sTable_SysDict, sFlag_NFStock, nStr]);

    FDM.ExecuteSQL(nSQL);
  end;
  0:
  begin
    nSQL := 'Insert Into %s (D_Name, D_Value, D_Desc, D_Memo) ' +
            'Values(''%s'', ''%s'', ''%s'', ''%s'')';
    nSQL := Format(nSQL, [sTable_SysDict, sFlag_NFStock, nStr,
            nTmp, SQLQuery.FieldByName('M_Name').AsString]);

    nStr := Format('Select * From %s Where D_Name=''%s'' And D_Value=''%s''',
            [sTable_SysDict, sFlag_NFStock, nStr]);
    with FDM.QueryTemp(nStr) do
    if RecordCount>0 then
    begin
      nStr := '品种 [%s] 已经设置为%s';
      nStr := Format(nStr, [SQLQuery.FieldByName('M_Name').AsString, nTmp]);

      ShowMsg(nStr, sHint);
      Exit;
    end;

    FDM.ExecuteSQL(nSQL);
  end;  
  end;

  InitFormData(FWhere);
end;

procedure TfFrameMaterails.N7Click(Sender: TObject);
begin
  {$IFDEF SyncDataByDataBase}
  if not SyncPMaterail('') then
  begin
    ShowMsg('同步失败',sHint);
    Exit;
  end;
  {$ENDIF}
  ShowMsg('同步完成',sHint);
  InitFormData('');
end;

initialization
  gControlManager.RegCtrl(TfFrameMaterails, TfFrameMaterails.FrameID);
end.
