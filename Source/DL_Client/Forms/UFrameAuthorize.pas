{*******************************************************************************
  作者: dmzn@163.com 2014-08-27
  描述: 系统接入认证管理
*******************************************************************************}
unit UFrameAuthorize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameAuthorize = class(TfFrameNormal)
    EditName: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditMAC: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
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
  ULibFun, UMgrControl, UFormBase, UFormCtrl, USysConst, USysDB, UDataModule;

class function TfFrameAuthorize.FrameID: integer;
begin
  Result := cFI_FrameAuthorize;
end;

//Desc: 数据查询SQL
function TfFrameAuthorize.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_WorkePC;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: 申请
procedure TfFrameAuthorize.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormAuthorize, '', @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    InitFormData('');
  //xxxxx
end;

//Desc: 批准
procedure TfFrameAuthorize.BtnEditClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('W_Valid').AsString;
  if nStr = sFlag_Yes then
  begin
    ShowMsg('已批准接入系统', sHint); Exit;
  end;

  nStr := SF('R_ID', SQLQuery.FieldByName('R_ID').AsString, sfVal);
  nStr := MakeSQLByStr([SF('W_RatifyMan', gSysParam.FUserID),
          SF('W_RatifyTime', sField_SQLServer_Now, sfVal),
          SF('W_Valid', sFlag_Yes)], sTable_WorkePC, nStr, False);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  InitFormData(FWhere);
end;

//Desc: 禁止
procedure TfFrameAuthorize.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要禁止的计算机', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('W_Valid').AsString;
  if nStr = sFlag_No then
  begin
    ShowMsg('已禁止接入系统', sHint); Exit;
  end;

  nStr := SF('R_ID', SQLQuery.FieldByName('R_ID').AsString, sfVal);
  nStr := MakeSQLByStr([SF('W_RatifyMan', gSysParam.FUserID),
          SF('W_RatifyTime', sField_SQLServer_Now, sfVal),
          SF('W_Valid', sFlag_No)], sTable_WorkePC, nStr, False);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameAuthorize.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := 'W_Name like ''%' + EditName.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditMAC then
  begin
    EditMAC.Text := Trim(EditMAC.Text);
    if EditMAC.Text = '' then Exit;

    FWhere := 'W_MAC like ''%' + EditMAC.Text + '%''';
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameAuthorize, TfFrameAuthorize.FrameID);
end.
