{*******************************************************************************
  作者: dmzn@163.com 2017-09-27
  描述: 车辆调度查询
*******************************************************************************}
unit UFrameQueryDiapatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, cxMaskEdit,
  cxButtonEdit, dxLayoutControl, cxTextEdit, Menus, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameQueryDispatch = class(TfFrameNormal)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure OnLoadPopedom; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    procedure SetTruckQueue(const nFirst: Boolean);
    //车辆插队
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, USysPopedom,
  UFormInputbox;

class function TfFrameQueryDispatch.FrameID: integer;
begin
  Result := cFI_FrameDispatchQuery;
end;

procedure TfFrameQueryDispatch.OnLoadPopedom;
begin
  inherited;
  N1.Enabled := BtnAdd.Enabled;
  N2.Enabled := BtnEdit.Enabled;
  N3.Enabled := BtnEdit.Enabled;
  N7.Enabled := BtnEdit.Enabled;
end;

function TfFrameQueryDispatch.InitFormDataSQL(const nWhere: string): string;
begin
  Result := ' Select zt.*,Z_Name,L_CusID,L_CusName,L_Status,L_Value ' +
            'From $ZT zt ' +
            ' Left Join $ZL zl On zl.Z_ID=zt.T_Line ' +
            ' Left Join $Bill b On b.L_ID=zt.T_Bill ';
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  //xxxx
  
  Result := MacroValue(Result, [MI('$ZT', sTable_ZTTrucks),
            MI('$ZL', sTable_ZTLines), MI('$Bill', sTable_Bill)]);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameQueryDispatch.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('zt.T_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-4-26
//Parm: 是否队首
//Desc: 车辆插队
procedure TfFrameQueryDispatch.SetTruckQueue(const nFirst: Boolean);
var nDate: TDateTime;
    nStr,nTruck,nStock: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if nFirst then
    begin
      nStr := '确定要将车辆[ %s ]插入队首吗?' + #13#10 +
              '该车将优先进厂.';
    end else
    begin
      nStr := '确定要将车辆[ %s ]插入队尾吗?' + #13#10 +
              '该车按照新建交货单排队.';
    end;

    nTruck := SQLQuery.FieldByName('T_Truck').AsString;
    nStr := Format(nStr, [nTruck]);
    if not QueryDlg(nStr, sAsk) then Exit;

    if nFirst then
    begin
      nStr := 'Select Min(T_InTime),%s As T_Now From %s Where T_StockNo=''%s''';
    end else
    begin
      nStr := 'Select Max(T_InTime),%s As T_Now From %s Where T_StockNo=''%s''';
    end;

    nStock := SQLQuery.FieldByName('T_StockNo').AsString;
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_ZTTrucks, nStock]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nDate := Fields[0].AsDateTime;
      if nFirst then
           nDate := nDate - StrToTime('00:00:02')
      else nDate := nDate + StrToTime('00:00:02');
    end else
    begin
      nDate := Fields[0].AsDateTime;
    end;

    nStr := 'Update %s Set T_InTime=''%s'',T_Valid=''%s'',T_Line='''' ' +
            'Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, DateTime2Str(nDate), sFlag_Yes,
            nTruck]);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    if nFirst then
    begin
      nStr := SQLQuery.FieldByName('T_Truck').AsString;
      FDM.WriteSysLog(sFlag_TruckQueue, nStr, '车辆插入队首.');
    end;

    InitFormData(FWhere);
    ShowMsg('插队完毕', sHint);
  end;
end;

//Desc: 插队首
procedure TfFrameQueryDispatch.N1Click(Sender: TObject);
begin
  SetTruckQueue(True);
end;

//Desc: 插队尾
procedure TfFrameQueryDispatch.N2Click(Sender: TObject);
begin
  SetTruckQueue(False);
end;

//Desc: 定道装车
procedure TfFrameQueryDispatch.N3Click(Sender: TObject);
var nStr,nLine,nTmp: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择车辆', sHint);
    Exit;
  end;

  nStr := SQLQuery.FieldByName('T_Line').AsString;
  nLine := nStr;
  if not ShowInputBox('请输入新的装车通道号:', sHint, nLine, 15) then Exit;

  nLine := UpperCase(Trim(nLine));
  if (nLine = '') or (CompareText(nStr, nLine) = 0) then Exit;
  //null or same

  nStr := 'Select Z_StockNo,Z_Stock From %s Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZTLines, nLine]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      ShowMsg('无效的通道编号', sHint);
      Exit;
    end;

    nTmp := SQLQuery.FieldByName('T_StockNo').AsString;
    if Fields[0].AsString <> nTmp then
    begin
      nStr := '通道[ %s ]的水泥品种与待装品种不一致,详情如下:' + #13#10#13#10 +
              '※.通道品种: %s' + #13#10 +
              '※.待装品种: %s' + #13#10#13#10 +
              '确定要定道操作吗?';
      nStr := Format(nStr, [nLine, Fields[1].AsString, nTmp]);
      if not QueryDlg(nStr,sAsk) then Exit;
    end;
  end;

  nStr := 'Update %s Set T_Line=''%s'' Where R_ID=%s';
  nStr := Format(nStr, [sTable_ZTTrucks, nLine,
          SQLQuery.FieldByName('R_ID').AsString]);
  FDM.ExecuteSQL(nStr);

  nTmp := SQLQuery.FieldByName('T_Line').AsString;
  if nTmp = '' then nTmp := '空';

  nStr := '指定装车道[ %s ]->[ %s ]';
  nStr := Format(nStr, [nTmp, nLine]);

  nTmp := SQLQuery.FieldByName('T_Truck').AsString;
  FDM.WriteSysLog(sFlag_TruckQueue, nTmp, nStr);
  InitFormData(FWhere);
end;

//Desc: 查询该车前面还有多少车辆
procedure TfFrameQueryDispatch.N6Click(Sender: TObject);
var nStr,nTruck,nStock,nDate: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nTruck := SQLQuery.FieldByName('T_Truck').AsString;
    nStock := SQLQuery.FieldByName('T_StockNo').AsString;
    nDate := SQLQuery.FieldByName('T_InTime').AsString;

    nStr := 'Select Count(*) From $TB Where T_InFact Is Null And ' +
            'T_Valid=''$Yes'' And T_StockNo=''$SN'' And T_InTime<''$IT''';
    nStr := MacroValue(nStr, [MI('$TB', sTable_ZTTrucks),
            MI('$Yes', sFlag_Yes), MI('$SN', nStock),
            MI('$IT', nDate)]);
    //xxxxx

    with FDM.QueryTemp(nStr) do
    begin
      nStr := '车辆[ %s ]前面还有[ %d ]辆车等待进厂.';
      nStr := Format(nStr, [nTruck, Fields[0].AsInteger]);
      ShowDlg(nStr, sHint);
    end;
  end;
end;

//Desc: 交货单出队入队
procedure TfFrameQueryDispatch.N9Click(Sender: TObject);
var nStr,nFlag,nEvent: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    case TComponent(Sender).Tag of
     10:
      begin
        nFlag := sFlag_Yes;
        nEvent := '交货单[ %s ]入队操作.';
      end;
     20:
      begin
        nFlag := sFlag_No;
        nEvent := '交货单[ %s ]移出队列.';
      end;
    end;

    nStr := 'Update %s Set T_Valid=''%s'' Where T_Bill=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, nFlag,
            SQLQuery.FieldByName('T_Bill').AsString]);
    FDM.ExecuteSQL(nStr);

    nStr := SQLQuery.FieldByName('T_Truck').AsString;
    nEvent := Format(nEvent, [SQLQuery.FieldByName('T_Bill').AsString]);

    FDM.WriteSysLog(sFlag_TruckQueue, nStr, nEvent);
    InitFormData(FWhere);
  end;
end;

//Desc: 清理交货单
procedure TfFrameQueryDispatch.N11Click(Sender: TObject);
var nStr: string;
    nInt: Integer;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := '系统将清理满足以下条件的交货单: ' + #13#10#13#10 +
            ' ※.交货单已出厂.' + #13#10 +
            ' ※.交货单已无效.' + #13#10#13#10 +
            '该操作将交货单从队列中直接删除,要继续吗?' + #32#32;
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := 'Delete From $ZT Where R_ID In (' +
            'Select zt.R_ID From $ZT zt ' +
            ' Left Join $Bill b On b.L_ID=zt.T_Bill ' +
            'Where (IsNull(L_OutFact,'''') <> '''') Or (L_ID Is Null))';
    //has out or not exists

    nStr := MacroValue(nStr, [MI('$ZT', sTable_ZTTrucks),
            MI('$Bill', sTable_Bill)]);
    nInt := FDM.ExecuteSQL(nStr);

    nStr := Format('清理队列,共[ %d ]张交货单出队.', [nInt]);
    FDM.WriteSysLog(sFlag_TruckQueue, sFlag_TruckQueue, nStr);

    InitFormData(FWhere);
    ShowMsg('清理完毕', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameQueryDispatch, TfFrameQueryDispatch.FrameID);
end.
