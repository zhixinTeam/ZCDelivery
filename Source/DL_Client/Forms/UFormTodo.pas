{*******************************************************************************
  作者: dmzn@163.com 2016-11-01
  描述: 异常处理和异常提醒
*******************************************************************************}
unit UFormTodo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, ImgList, DB, ADODB,
  ExtCtrls, cxGroupBox, cxRadioGroup, cxMemo, cxTextEdit, cxListView,
  cxLabel, dxLayoutControl, StdCtrls;

type
  TfFormTodo = class(TfFormNormal)
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    ListTodo: TcxListView;
    dxLayout1Item3: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditDate: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditFrom: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditEvent: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    cxRadio1: TcxRadioGroup;
    dxLayout1Item8: TdxLayoutItem;
    Timer1: TTimer;
    ADOQuery1: TADOQuery;
    ImageBar: TcxImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListTodoSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure cxRadio1PropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    function LoadEventFromDB: Boolean;
    procedure LoadEventToUI;
    function GetSolution(const nData: string; nUIIndex: Integer = -1): string;
  protected
    Procedure CreateParams(Var Params: TCreateParams); override;
    //new style
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UFormBase, UFormCtrl, USysDB, USysConst,
  USysGrid, UMgrSndPlay;

const
  cRefreshInterval = 10; //刷新间隔

type
  PEventItem = ^TEventItem;
  TEventItem = record
    FEnable: Boolean;
    FRecord: string;
    FFrom: string;
    FEvent: string;
    FSolution: string;
    FDate: TDateTime;
  end;

var
  gEventList: TList = nil;
  gForm: TfFormTodo = nil;
  //全局使用

class function TfFormTodo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if not Assigned(gForm) then
  begin
    gForm := TfFormTodo.Create(Application);
    gForm.Caption := '待处理事项';
    gForm.BtnOk.Visible := False;
  end;

  if (nPopedom <> '') and (not gForm.Visible) then
    gForm.Show;
  //xxxxx
end;

class function TfFormTodo.FormID: integer;
begin
  Result := cFI_FormTodo;
end;

procedure TfFormTodo.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams(Params);
  with Params do
  begin
    WndParent := GetDesktopWindow;
    ExStyle := ExStyle or WS_EX_APPWINDOW or WS_EX_TOPMOST;
  end;
end;

procedure TfFormTodo.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name + '_ListTodo', ListTodo, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormTodo.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  inherited;
  Action := caHide;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name + '_ListTodo', ListTodo, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormTodo.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
procedure ClearEventList(const nFree: Boolean);
var nIdx: Integer;
    nItem: PEventItem;
begin
  for nIdx:=gEventList.Count - 1 downto 0 do
  if Assigned(gEventList[nIdx]) then
  begin
    nItem := gEventList[nIdx];
    gEventList[nIdx] := nil;
    Dispose(nItem);         
  end;

  gEventList.Clear;
  if nFree then
    FreeAndNil(gEventList);
  //xxxxx
end;

function TfFormTodo.LoadEventFromDB: Boolean;
var nStr: string;
    nIdx: Integer;
    nBool,nChange: Boolean;
    nItem: PEventItem;
begin
  Result := False;
  for nIdx:=gEventList.Count - 1 downto 0 do
  begin
    nItem := gEventList[nIdx];
    nItem.FEnable := False;
  end;

  with ADOQuery1 do
  try                            
    nStr := 'Select * from %s Where (E_Date>=%s-1 and E_Result Is Null ' +
            'and E_Departmen=''%s'') or (E_Date>=dateadd(hour,-1,%s) and ' +
            'E_Departmen=''%s'') Order By R_ID desc';
    nStr := Format(nStr, [sTable_ManualEvent, sField_SQLServer_Now,
            gSysParam.FDepartment, sField_SQLServer_Now, sFlag_Departments]);
    //一天之内本部门,或所有部门一小时内未处理消息

    FDM.QueryData(ADOQuery1, nStr);
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nItem := nil;
        nBool := False;
        nChange := False;

        nStr := FieldByName('R_ID').AsString;        
        for nIdx:=gEventList.Count - 1 downto 0 do
        begin
          nItem := gEventList[nIdx];
          if nItem.FRecord = nStr then
          begin
            nChange := nItem.FDate < FieldByName('E_Date').AsDateTime;
            nBool := True;

            nItem.FEnable := True;
            Break;
          end;
        end;

        if not nBool then
        begin
          Result := True;
          New(nItem);
          gEventList.Add(nItem);
        end;

        if Assigned(nItem) and ((not nBool) or nChange) then
        begin
          nItem.FEnable := True;
          nItem.FRecord := nStr;
          nItem.FFrom := FieldByName('E_From').AsString;
          nItem.FEvent := FieldByName('E_Event').AsString;
          nItem.FSolution := FieldByName('E_Solution').AsString;
          nItem.FDate := FieldByName('E_Date').AsDateTime;
        end;

        Next;
      end;
    end;
  except
    //ignor any error
  end;

  for nIdx:=gEventList.Count - 1 downto 0 do
  begin
    nItem := gEventList[nIdx];
    if nItem.FEnable then Continue;

    Dispose(nItem);
    gEventList.Delete(nIdx);
    Result := True;
  end;
end;

procedure TfFormTodo.LoadEventToUI;
var nIdx,nRd: Integer;
    nItem: PEventItem;
begin
  ListTodo.Items.BeginUpdate;
  try
    nRd := ListTodo.ItemIndex;
    ListTodo.Items.Clear;

    for nIdx:=0 to gEventList.Count - 1 do
    begin
      nItem := gEventList[nIdx];
      with ListTodo.Items.Add do
      begin
        Caption := DateTime2Str(nItem.FDate);
        SubItems.Add(nItem.FFrom);
        SubItems.Add(nItem.FEvent);

        Data := nItem;
        ImageIndex := 0;
      end;
    end;

    if ListTodo.Items.Count > 0 then
    begin
      if nRd < 0 then
        nRd := 0;
      //default

      if nRd < ListTodo.Items.Count then
           ListTodo.ItemIndex := nRd
      else ListTodo.ItemIndex := 0;
    end;
  finally
    ListTodo.Items.EndUpdate;
  end;
end;

procedure TfFormTodo.ListTodoSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var nStr: string;
    nItem: PEventItem;
begin
  cxRadio1.Enabled := Selected;
  if Selected and Assigned(Item) then
  begin
    nItem := Item.Data;
    EditDate.Text := DateTime2Str(nItem.FDate);
    EditFrom.Text := nItem.FFrom;

    while True do
    begin
      nStr := StringReplace(nItem.FEvent, #13#10#13#10, #13#10, [rfReplaceAll]);
      if nItem.FEvent = nStr then Break;
      nItem.FEvent := nStr;
    end;

    EditEvent.Text := nItem.FEvent;
    GetSolution(nItem.FSolution);
  end;
end;

function TfFormTodo.GetSolution(const nData: string; nUIIndex: Integer): string;
var nList: TStrings;
    nIdx: Integer;
begin
  Result := '';
  nList := TStringList.Create;
  try
    cxRadio1.Properties.Items.BeginUpdate;
    nList.Text := StringReplace(nData, ';', #13, [rfReplaceAll]);
    
    if nUIIndex < 0 then
    begin
      cxRadio1.Properties.Items.Clear;
      //xxxxx

      for nIdx:=0 to nList.Count - 1 do
      with cxRadio1.Properties.Items.Add do
      begin
        Caption := nList.ValueFromIndex[nIdx];
        Tag := nIdx;
      end;
    end else
    begin
      Result := nList.Names[nUIIndex];
    end;

    if cxRadio1.Properties.Items.Count < 3 then
         cxRadio1.Properties.Columns := cxRadio1.Properties.Items.Count
    else cxRadio1.Properties.Columns := 3;
  finally
    nList.Free;
    cxRadio1.Properties.Items.EndUpdate;
  end;   
end;

procedure TfFormTodo.Timer1Timer(Sender: TObject);
var nStr: string;
    nBool: Boolean;
begin
  Timer1.Tag := Timer1.Tag + 1;
  if Timer1.Tag < cRefreshInterval then Exit;
  Timer1.Tag := 0;

  if LoadEventFromDB then
  begin
    LoadEventToUI;
    if ListTodo.Items.Count < 1 then
    begin
      Hide;
      Exit;
    end;

    if Visible and Active then
         nBool := False
    else nBool := True;

    if not Visible then Show;
    //xxxxx
    
    if nBool then
    begin
      nStr := gPath + 'sound.wav';
      if FileExists(nStr) then
        gSoundPlayManager.PlaySound(nStr);
      //xxxxx
    end;
  end;
end;

procedure TfFormTodo.cxRadio1PropertiesEditValueChanged(Sender: TObject);
var nStr: string;
    nItem: PEventItem;
begin
  if cxRadio1.Focused and Assigned(ListTodo.Selected) then
  begin
    nItem := ListTodo.Selected.Data;
    nStr := cxRadio1.Properties.Items[cxRadio1.ItemIndex].Caption;

    nStr := '事件处理如下:' + StringOfChar(' ', 22) + #13#10#13#10 +
            '※.来源: ' + EditFrom.Text + #13#10 + 
            '※.结果: ' + nStr + #13#10#13#10 +
            '确认处理结果请点击"是"按钮.';
    if not QueryDlg(nStr, sAsk, Handle) then Exit;

    nStr := GetSolution(nItem.FSolution, cxRadio1.ItemIndex);
    nStr := MakeSQLByStr([SF('E_Result', nStr),
            SF('E_ManDeal', gSysParam.FUserID),
            SF('E_DateDeal', sField_SQLServer_Now, sfVal)
            ], sTable_ManualEvent, SF('R_ID', nItem.FRecord), False);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    Timer1.Tag := cRefreshInterval - 1;
  end;
end;

initialization
  if not Assigned(gEventList) then
    gEventList := TList.Create;
  gControlManager.RegCtrl(TfFormTodo, TfFormTodo.FormID);
finalization
  if Assigned(gEventList) then
    ClearEventList(True);
  //xxxxx
end.
