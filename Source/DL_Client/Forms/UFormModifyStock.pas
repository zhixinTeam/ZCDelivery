{*******************************************************************************
  作者: juner11212436@163.com 2018/03/01
  描述: 批量修改物料
*******************************************************************************}
unit UFormModifyStock;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit,
  cxTextEdit, dxLayoutControl, StdCtrls, cxDropDownEdit, cxLabel,
  dxLayoutcxEditAdapters, cxCheckBox, cxCalendar, ComCtrls, cxListView;

type
  TfFormModifyStock = class(TfFormNormal)
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditID: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditProvider: TcxTextEdit;
    dxlytmLayout1Item3: TdxLayoutItem;
    editMemo: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    ListQuery: TcxListView;
    EditModel: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditShip: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditKD: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditYear: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FCardData, FListA: TStrings;
    procedure InitFormData;
    //初始化界面
    procedure WriteOptionLog(const LID: string; nIdx: Integer);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, DB, IniFiles, UMgrControl, UAdjustForm, UFormBase, UBusinessPacker,
  UDataModule, USysBusiness, USysDB, USysGrid, USysConst,DateUtils;

var
  gModifyStockForm: TfFormModifyStock = nil;
  //全局使用

class function TfFormModifyStock.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr, nModifyStr: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  if GetSysValidDate < 1 then Exit;

  if Assigned(nParam) then
       nP := nParam
  else Exit;

  nModifyStr := nP.FParamA;

  try
    CreateBaseFormItem(cFI_FormGetPOrderBase, nPopedom, nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
    nStr := nP.FParamB;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  with TfFormModifyStock.Create(Application) do
  try
    Caption := '批量修改物料';

    FListA.Text := nModifyStr;
    FCardData.Text := PackerDecodeStr(nStr);
    InitFormData;

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;

      if FParamA = mrOK then
           FParamB := ''
      else FParamB := '';
    end else ShowModal;
  finally
    Free;
  end;
end;

class function TfFormModifyStock.FormID: integer;
begin
  Result := cFI_FormModifyStock;
end;

procedure TfFormModifyStock.FormCreate(Sender: TObject);
begin
  FListA    := TStringList.Create;
  FCardData := TStringList.Create;
  AdjustCtrlData(Self);
  LoadFormConfig(Self);
  dxGroup1.AlignHorz := ahClient;
end;

procedure TfFormModifyStock.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);

  FListA.Free;
  FCardData.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormModifyStock.InitFormData;
var nStr: string;
    nIdx: Integer;
begin
  with FCardData do
  begin
    EditID.Text       := Values['SQ_ID'];
    EditProvider.Text := Values['SQ_ProName'];
    EditMate.Text     := Values['SQ_StockName'];
    EditModel.Text    := Values['SQ_Model'];
    editMemo.Text     := Values['SQ_Memo'];
    EditYear.Text     := Values['SQ_Year'];
    EditKD.Text       := Values['SQ_KD'];
  end;
  for nIdx := 0 to FListA.Count - 1 do
  begin
    nStr := 'Select O_ID,O_Truck,O_StockName,O_BID,O_Model,O_Ship, ' +
            'O_Year, O_KD From %s Where O_ID =''%s''';
    nStr := Format(nStr, [sTable_Order, FListA.Strings[nIdx]]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then
        Continue;

      with ListQuery.Items.Add do
      begin
        Caption := Fields[0].AsString;
        SubItems.Add(Fields[1].AsString);
        SubItems.Add(Fields[2].AsString);
        SubItems.Add(Fields[3].AsString);
        SubItems.Add(Fields[4].AsString);
        SubItems.Add(Fields[5].AsString);
        SubItems.Add(Fields[6].AsString);
        SubItems.Add(Fields[7].AsString);
        ImageIndex := cItemIconIndex;
      end;
    end;
  end;
  if ListQuery.Items.Count>0 then
    ListQuery.ItemIndex := 0;
end;

//Desc: 保存
procedure TfFormModifyStock.BtnOKClick(Sender: TObject);
var nStr, nSQL, nShip: string;
    nIdx: Integer;
begin
  if not QueryDlg('确定要修改上述车辆物料信息吗?', sHint) then Exit;

  nShip := Trim(EditShip.Text);

  if Length(nShip) > 0 then
  begin
    nStr := '确定将所有船号更新为[ %s ]吗?';
    nStr := Format(nStr, [nShip]);
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  for nIdx := 0 to FListA.Count - 1 do
  begin
    if Length(nShip) > 0 then
    begin
      nSQL := 'Update %s Set O_StockNo=''%s'', O_StockName=''%s'','+
                ' O_BID=''%s'',O_Model=''%s'',O_ProID=''%s'','+
                ' O_ProName=''%s'',O_ProPY=''%s'',O_Ship=''%s'','+
                ' O_Year=''%s'',O_KD=''%s'' Where O_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Order, FCardData.Values['SQ_StockNo'],
                                          FCardData.Values['SQ_StockName'],
                                          FCardData.Values['SQ_ID'],
                                          FCardData.Values['SQ_Model'],
                                          FCardData.Values['SQ_ProID'],
                                          FCardData.Values['SQ_ProName'],
                                          GetPinYinOfStr(FCardData.Values['SQ_ProName']),
                                          nShip,
                                          FCardData.Values['SQ_Year'],
                                          FCardData.Values['SQ_KD'],
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end
    else
    begin
      nSQL := 'Update %s Set O_StockNo=''%s'', O_StockName=''%s'','+
                ' O_BID=''%s'',O_Model=''%s'',O_ProID=''%s'','+
                ' O_ProName=''%s'',O_ProPY=''%s'','+
                ' O_Year=''%s'',O_KD=''%s'' Where O_ID=''%s''';
      nSQL := Format(nSQL, [sTable_Order, FCardData.Values['SQ_StockNo'],
                                          FCardData.Values['SQ_StockName'],
                                          FCardData.Values['SQ_ID'],
                                          FCardData.Values['SQ_Model'],
                                          FCardData.Values['SQ_ProID'],
                                          FCardData.Values['SQ_ProName'],
                                          GetPinYinOfStr(FCardData.Values['SQ_ProName']),
                                          FCardData.Values['SQ_Year'],
                                          FCardData.Values['SQ_KD'],
                                          FListA.Strings[nIdx]]);
      FDM.ExecuteSQL(nSQL);
    end;


    nSQL := 'Update %s Set D_StockNo=''%s'', D_StockName=''%s'',D_ProID=''%s'','+
            ' D_ProName=''%s'',D_ProPY=''%s'' Where D_OID=''%s''';
    nSQL := Format(nSQL, [sTable_OrderDtl, FCardData.Values['SQ_StockNo'],
                                        FCardData.Values['SQ_StockName'],
                                        FCardData.Values['SQ_ProID'],
                                        FCardData.Values['SQ_ProName'],
                                        GetPinYinOfStr(FCardData.Values['SQ_ProName']),
                                        FListA.Strings[nIdx]]);
    FDM.ExecuteSQL(nSQL);

    WriteOptionLog(FListA.Strings[nIdx], nIdx);
  end;

  ModalResult := mrOK;
  ShowMsg('批量修改物料成功', sHint);
end;

procedure TfFormModifyStock.WriteOptionLog(const LID: string;nIdx: Integer);
var nEvent: string;
begin
  nEvent := '';

  try
    with ListQuery.Items[nIdx] do
    begin
      if EditID.Text <> SubItems[2] then
      begin
        nEvent := nEvent + '订单号由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[2], EditID.Text]);
      end;
      if SubItems[1] <> EditMate.Text then
      begin
        nEvent := nEvent + '物料由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[1], EditMate.Text]);
      end;
      if SubItems[3] <> EditModel.Text then
      begin
        nEvent := nEvent + '型号由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[3], EditModel.Text]);
      end;
      if SubItems[5] <> EditYear.Text then
      begin
        nEvent := nEvent + '记账年月由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[5], EditYear.Text]);
      end;
      if SubItems[6] <> EditKD.Text then
      begin
        nEvent := nEvent + '矿点由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[6], EditKD.Text]);
      end;
      if SubItems[4] <> EditShip.Text then
      begin
        nEvent := nEvent + '船号由 [ %s ] --> [ %s ];';
        nEvent := Format(nEvent, [SubItems[4], EditShip.Text]);
      end;

      if nEvent <> '' then
      begin
        nEvent := '采购单 [ %s ] 参数已被修改:' + nEvent;
        nEvent := Format(nEvent, [LID]);
      end;
    end;

    if nEvent <> '' then
    begin
      FDM.WriteSysLog(sFlag_BillItem, LID, nEvent);
    end;
  except
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormModifyStock, TfFormModifyStock.FormID);
end.
