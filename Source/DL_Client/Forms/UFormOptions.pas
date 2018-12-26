{*******************************************************************************
  作者: dmzn@163.com 2017-07-09
  描述: 系统设置
*******************************************************************************}
unit UFormOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxCheckBox, cxLabel,
  cxButtons, cxTextEdit, cxMCListBox, cxPC, StdCtrls, dxLayoutControl;

type
  TfFormOptions = class(TfFormNormal)
    wPage: TcxPageControl;
    dxLayout1Item3: TdxLayoutItem;
    Sheet1: TcxTabSheet;
    ListStockNF: TcxMCListBox;
    Label8: TLabel;
    EditStockId2: TcxTextEdit;
    BtnDel2: TcxButton;
    BtnAdd2: TcxButton;
    EditStockName2: TcxTextEdit;
    Label9: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Sheet2: TcxTabSheet;
    ListDaiWuCha: TcxMCListBox;
    EditStart: TcxTextEdit;
    cxLabel1: TcxLabel;
    EditEnd: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    EditZWC: TcxTextEdit;
    cxLabel4: TcxLabel;
    EditFWC: TcxTextEdit;
    EditPercent: TcxCheckBox;
    BtnAdd4: TcxButton;
    BtnDel4: TcxButton;
    procedure wPageChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure BtnAdd4Click(Sender: TObject);
    procedure BtnDel4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure InitFormData;
    //基本参数
    procedure LoadNFStock;
    procedure SaveNFStock;
    procedure LoadNFStockList;
    //无需发货
    procedure LoadDaiPoundWC;
    procedure SaveDaiPoundWC;
    procedure LoadDaiPoundWCList;
    //袋装误差设置
  public
    { Public declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //验证信息
    
    class function FormID: integer; override;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    //base
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst,
  UAdjustForm, USysGrid;

type
  TStockItem = record
    FID: string;
    FName: string;
    FType: string;
    FEnabled: Boolean;
  end;

  TNoFangHuiStock = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FItems: array of TStockItem;
  end;

  TPoundDaiWCItem = record
    FStart: Double;           //起始吨位
    FEnd  : Double;           //结束吨位
    FWuChaZ: Double;          //正误差
    FWuChaF: Double;          //负误差
    FIsPercent: string;      //按比例计算
    FStation: string;         //磅站编号
    FEnabled: Boolean;         //是否有效
  end;

  TPoundDaiWCParam = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FItems: array of TPoundDaiWCItem;
  end;

var
  gNFStock: TNoFangHuiStock;
  //无需放灰品种
  gPoundDaiWCParam: TPoundDaiWCParam;
  //袋装误差配置

class function TfFormOptions.FormID: integer;
begin
  Result := cFI_FormOptions;
end;

class function TfFormOptions.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormOptions.Create(Application) do
  begin
    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormOptions.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  LoadMCListBoxConfig(Name, ListStockNF);
  LoadMCListBoxConfig(Name, ListDaiWuCha);
end;

procedure TfFormOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  SaveMCListBoxConfig(Name, ListStockNF);
  SaveMCListBoxConfig(Name, ListDaiWuCha);
end;

procedure TfFormOptions.InitFormData;
begin
  gNFStock.FLoaded := False;
  gPoundDaiWCParam.FLoaded := False;

  wPage.ActivePage := Sheet1;
  LoadNFStock;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.LoadNFStock;
var nStr: string;
    nIdx: Integer;
begin
  with gNFStock do
  begin
    FLoaded := True;
    FSaved := True;
    SetLength(FItems, 0);

    nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      SetLength(FItems, RecordCount);

      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID := Fields[0].AsString;
          FName := Fields[1].AsString;
          FEnabled := True;
        end;

        Inc(nIdx);
        Next;
      end;

      LoadNFStockList;
    end;
  end;
end;

procedure TfFormOptions.SaveNFStock;
var nStr: string;
    nIdx: Integer;
begin
  with gNFStock do
  begin
    nStr := 'Delete From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    begin
      if not FEnabled then Continue;
      nStr := MakeSQLByStr([SF('D_Name', sFlag_NFStock),
              SF('D_Desc', '无需发货品种'),
              SF('D_Value', FID), SF('D_Memo', FName)
              ], sTable_SysDict, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FSaved := True;
  end;
end;

procedure TfFormOptions.LoadNFStockList;
var nIdx: Integer;
begin
  with gNFStock do
  begin
    ListStockNF.Clear;
    for nIdx:=Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FEnabled then
       ListStockNF.Items.AddObject(FID + ListStockNF.Delimiter + FName, Pointer(nIdx));
    //items
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.LoadDaiPoundWC;
var nStr: string;
    nIdx: Integer;
begin
  with gPoundDaiWCParam do
  begin
    FLoaded := True;
    FSaved := True;
    SetLength(FItems, 0);

    nStr := 'Select * From ' + sTable_PoundDaiWC;
    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      SetLength(FItems, RecordCount);

      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FStart := FieldByName('P_Start').AsFloat;
          FEnd   := FieldByName('P_End').AsFloat;

          FWuChaZ:= FieldByName('P_DaiWuChaZ').AsFloat;
          FWuChaF:= FieldByName('P_DaiWuChaF').AsFloat;
          FIsPercent := FieldByName('P_Percent').AsString;

          FStation := FieldByName('P_Station').AsString;
          FEnabled := True;
        end;

        Inc(nIdx);
        Next;
      end;

      LoadDaiPoundWCList;
    end;
  end;
end;

procedure TfFormOptions.LoadDaiPoundWCList;
var nIdx: Integer;
    nStr: string;
begin
  with gPoundDaiWCParam do
  begin
    ListDaiWuCha.Clear;
    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    if FEnabled then
    begin
      nStr := FloatToStr(FStart) + ListDaiWuCha.Delimiter +
              FloatToStr(FEnd)   + ListDaiWuCha.Delimiter +
              FloatToStr(FWuChaZ)+ ListDaiWuCha.Delimiter +
              FloatToStr(FWuChaF)+ ListDaiWuCha.Delimiter +
              FIsPercent         + ListDaiWuCha.Delimiter +
              FStation;
      ListDaiWuCha.Items.AddObject(nStr, Pointer(nIdx));
    end;
    //items
  end;
end;

procedure TfFormOptions.SaveDaiPoundWC;
var nStr: string;
    nIdx: Integer;
begin
  with gPoundDaiWCParam do
  begin
    nStr := 'Delete From ' + sTable_PoundDaiWC;
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    begin
      if not FEnabled then Continue;
      nStr := MakeSQLByStr([
              SF('P_DaiWuChaZ', FWuChaZ, sfVal),
              SF('P_DaiWuChaF', FWuChaF, sfVal),
              SF('P_Start',FStart, sfVal),
              SF('P_End', FEnd, sfVal),

              SF('P_Percent', FIsPercent),
              SF('P_Station', FStation)
              ], sTable_PoundDaiWC, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FSaved := True;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.wPageChange(Sender: TObject);
begin
  case wPage.ActivePageIndex of
   0: if not gNFStock.FLoaded then LoadNFStock;
   1: if not gPoundDaiWCParam.FLoaded then LoadDaiPoundWC;
  end;
end;

procedure TfFormOptions.BtnDel2Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListStockNF.ItemIndex > -1 then
  with gNFStock do
  begin
    nIdx := Integer(ListStockNF.Items.Objects[ListStockNF.ItemIndex]);
    FItems[nIdx].FEnabled := False;

    FSaved := False;
    LoadNFStockList;
  end;
end;

procedure TfFormOptions.BtnAdd2Click(Sender: TObject);
var nIdx: Integer;
begin
  EditStockId2.Text := Trim(EditStockId2.Text);
  EditStockName2.Text := Trim(EditStockName2.Text);

  with gNFStock do
  begin
    for nIdx:=Low(FItems) to High(FItems) do
    if (CompareText(FItems[nIdx].FID, EditStockId2.Text) = 0) and
       (FItems[nIdx].FEnabled) then
    begin
      EditStockId2.SetFocus;
      ShowMsg('编号已存在', sHint); Exit;
    end;

    nIdx := Length(FItems);
    SetLength(FItems, nIdx + 1);

    with FItems[nIdx] do
    begin
      FID := EditStockId2.Text;
      FName := EditStockName2.Text;
      FEnabled := True;
    end;

    FSaved := False;
    LoadNFStockList;
  end;
end;

procedure TfFormOptions.BtnAdd4Click(Sender: TObject);
var nIdx: Integer;
    nStart, nEnd: Double;
begin
  inherited;
  if not IsDataValid then Exit;

  nStart := StrToFloat(EditStart.Text);
  nEnd   := StrToFloat(EditEnd.Text);

  with gPoundDaiWCParam do
  begin
    for nIdx := Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    if FloatRelation(FStart, nStart, rtLE) and
       FloatRelation(FEnd, nStart, rtGreater) and FEnabled then
    begin
      ActiveControl := EditStart;
      ShowMsg('起始范围已重叠.', sHint);
      Exit;
    end else

    if FloatRelation(FStart, nEnd, rtLess) and
       FloatRelation(FEnd, nEnd, rtGE) and FEnabled then
    begin
      ActiveControl := EditEnd;
      ShowMsg('结束范围已重叠.', sHint);
      Exit;
    end;

    nIdx := Length(FItems);
    SetLength(FItems, nIdx + 1);

    with FItems[nIdx] do
    begin
      FStart := nStart;
      FEnd   := nEnd;

      FWuChaZ:= StrToFloat(EditZWC.Text);
      FWuChaF:= StrToFloat(EditFWC.Text);
      if EditPercent.Checked then
           FIsPercent := sFlag_Yes
      else FIsPercent := sFlag_No;

      FStation := ''; //gPoundParam.FPoundID;
      if FStation = '' then FStation := ' ';
      FEnabled := True;
    end;

    FSaved := False;
    LoadDaiPoundWCList;
  end;
end;

procedure TfFormOptions.BtnDel4Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListDaiWuCha.ItemIndex > -1 then
  with gPoundDaiWCParam do
  begin
    nIdx := Integer(ListDaiWuCha.Items.Objects[ListDaiWuCha.ItemIndex]);
    FItems[nIdx].FEnabled := False;

    FSaved := False;
    LoadDaiPoundWCList;
  end;
end;  

function TfFormOptions.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditStart then
  begin
    Result := IsNumber(EditStart.Text, True);
    nHint  := '请输入有效数值(起始范围)';
  end else

  if Sender = EditEnd then
  begin
    Result := IsNumber(EditEnd.Text, True);
    nHint  := '请输入有效数值(结束范围)';

    if not Result then Exit;

    Result := IsNumber(EditStart.Text, True);
    nHint  := '请输入有效数值(起始范围)';

    if not Result then Exit;

    Result := FloatRelation(StrToFloat(EditEnd.Text), StrToFloat(EditStart.Text),
              rtGreater, cPrecision);
    nHint  := '起始值应该小于结束值'
  end else

  if Sender = EditZWC then
  begin
    Result := IsNumber(EditZWC.Text, True);
    nHint  := '请输入有效误差范围(正误差)';
  end else

  if Sender = EditFWC then
  begin
    Result := IsNumber(EditFWC.Text, True);
    nHint  := '请输入有效误差范围(负误差)';
  end;
end;    

//Desc: 保存数据
procedure TfFormOptions.BtnOKClick(Sender: TObject);
begin
  with gNFStock do
    if FLoaded and (not FSaved) then SaveNFStock;
  //xxxxx

  with gPoundDaiWCParam do
    if FLoaded and (not FSaved) then SaveDaiPoundWC;
  //xxxxx

  ModalResult := mrOk;
  ShowMsg('保存完毕', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormOptions, TfFormOptions.FormID);
end.
