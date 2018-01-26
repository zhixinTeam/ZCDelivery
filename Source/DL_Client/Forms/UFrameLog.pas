{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-11-30
  描述: 查看系统日志
*******************************************************************************}
unit UFrameLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameBase, ExtCtrls, ImgList, ComCtrls, ToolWin, Menus;

type
  TfFrameLog = class(TBaseFrame)
    mExpand: TMenuItem;
    mCollapse: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Tv1: TTreeView;
    PMenu1: TPopupMenu;
    S1: TToolButton;
    ToolBar1: TToolBar;
    BtnRefresh: TToolButton;
    BtnClear: TToolButton;
    ImageList1: TImageList;
    BtnExit: TToolButton;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Lv1: TListView;
    HintPanel: TPanel;
    PMenu2: TPopupMenu;
    mCopy: TMenuItem;
    mExport: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    TitlePanel: TPanel;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure Tv1Change(Sender: TObject; Node: TTreeNode);
    procedure mExpandClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure PMenu2Popup(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure mCopyClick(Sender: TObject);
    procedure mExportClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
  protected
    { Private declarations }
    FNowDate: string;
    {*当前载入的日期*}
    FLastSave: string;
    {*上次保存*}
    FYears,FDays: integer;
    {*年数,天数*}
    procedure OnCreateFrame; override;
    procedure OnShowFrame; override;
    procedure OnLoadPopedom; override;
    procedure DoOnClose(var nAction: TCloseAction); override;

    procedure LoadLogFileList;
    {*载入日志列表*}
    procedure LoadFrameConfig;
    {*载入配置信息*}
    procedure LoadTreeNodeList(const nList: TStrings);
    {*载入树节点*}
    function FindTreeNode(const nStr: string): TTreeNode;
    {*查找节点*}
    procedure AddLogItem(const nStr: string);
    {*添加日志项*}
    procedure ClearAllYear(const nYear: TTreeNode);
    {*按年份清理日志*}
    function ClearNodeLog(const nNode: TTreeNode): Boolean;
    {*清理指定节点日志*}
    procedure ExportData(const nAll: Boolean);
    {*导出数据*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, Clipbrd, ULibFun, USysConst, USysFun, USysDB, USysPopedom,
  UMgrControl;

ResourceString
  sClearHintSelect = '请选择要清空的日志节点';
  sClearForbidToday = '当天的日志不允许清空';
  sClearAskForYear = '确定要清空该年份下的所有日志吗?';
  sClearAskForDay = '确定要清空 [%s] 日的所有记录吗?';
  sLogInfo = '信息摘要:共【%d】年【%d】天  当前日期:【%s】 记录数:【%d】';

//------------------------------------------------------------------------------
class function TfFrameLog.FrameID: integer;
begin
  Result := cFI_FrameViewLog;
end;

//Desc: 创建
procedure TfFrameLog.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  LoadLogFileList;
  LoadFrameConfig;
end;

//Desc: 显示
procedure TfFrameLog.OnShowFrame;
var nNode: TTreeNode;
begin
  nNode := FindTreeNode(DateToStr(Now));
  if Assigned(nNode) then
  begin
    nNode.Selected := True;
    nNode.Parent.Expand(False);
  end;
end;

//Desc: 设置权限
procedure TfFrameLog.OnLoadPopedom;
begin
  BtnClear.Enabled := gPopedomManager.HasPopedom(PopedomItem, sPopedom_Delete);
end;

//Desc: 关闭
procedure TfFrameLog.DoOnClose(var nAction: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteString(Name, 'LastSave', FLastSave);
    nIni.WriteInteger(Name, 'LeftTree', Tv1.Width);
    nIni.WriteString(Name, 'LvColumn', MakeListViewColumnInfo(Lv1));
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入配置
procedure TfFrameLog.LoadFrameConfig;
var nStr: string;
    nInt: integer;
    nIni: TIniFile;
begin
  nStr := gPath + sFormConfig;
  if not FileExists(nStr) then Exit;

  nIni := TIniFile.Create(nStr);
  try
    FLastSave := nIni.ReadString(Name, 'LastSave', gPath);
    nInt := nIni.ReadInteger(Name, 'LeftTree', 0);
    if nInt <> 0 then Tv1.Width := nInt;

    nStr := nIni.ReadString(Name, 'LvColumn', '');
    if nStr <> '' then LoadListViewColumn(nStr, Lv1);
  finally
    nIni.Free;
  end;
end;

//Desc: 载入日志文件列表
procedure TfFrameLog.LoadLogFileList;
var nStr: string;
    nRes: Integer;
    nSR: TSearchRec;
    nList: TStrings;
begin
  nStr := gPath + sLogDir;
  if not DirectoryExists(nStr) then Exit;

  nList := TStringList.Create;
  try
    nStr := nStr + '*' + sLogExt;
    nRes := FindFirst(nStr, faAnyFile, nSR);
    
    while nRes = 0 do
    begin
      nList.Add(nSR.Name);
      nRes := FindNext(nSR);
    end;

    FindClose(nSR);
    LoadTreeNodeList(nList);
  finally
    nList.Free;
  end;
end;

//Desc: 载入树节点
procedure TfFrameLog.LoadTreeNodeList(const nList: TStrings);
var nStr: string;
    nNode: TTreeNode;
    i,nCount,nLen: integer;
begin
  nLen := Length(sLogExt);
  nCount := nList.Count - 1;
  FYears := 0; FDays := 0;
  
  for i:=0 to nCount do
  begin
    nStr := Copy(nList[i], 1, 4);
    if not IsNumber(nStr, False) then Continue;

    nNode := FindTreeNode(nStr);
    if not Assigned(nNode) then
    begin
      Inc(FYears);
      nNode := Tv1.Items.AddChild(nil, nStr);
      nNode.ImageIndex := 3;
      nNode.SelectedIndex := nNode.ImageIndex;
    end;

    Inc(FDays);
    nStr := nList[i];
    System.Delete(nStr, Length(nStr) - nLen + 1, nLen);

    nNode := Tv1.Items.AddChild(nNode, nStr);
    nNode.ImageIndex := 4;
    nNode.SelectedIndex := nNode.ImageIndex;
  end;
end;

//Desc: 添加日志项
procedure TfFrameLog.AddLogItem(const nStr: string);
var nItem: TListItem;
    nIdx,nNow,nLen: integer;
begin
  nNow := 1;
  nItem := nil;
  nLen := Length(nStr);

  for nIdx:=nNow to nLen do
  if nStr[nIdx] = sLogField then
  begin
    if nNow = 1 then
    begin
      nItem := Lv1.Items.Add;
      nItem.ImageIndex := 5;
      nItem.Caption := Copy(nStr, nNow, nIdx - 1);
    end else nItem.SubItems.Add(Copy(nStr, nNow, nIdx - nNow));

    nNow := nIdx + 1;
  end;

  if (nNow > 1) and (nNow < nLen) then
    nItem.SubItems.Add(Copy(nStr, nNow, nLen - nNow + 1));
  //追加最后一个域
end;

//Desc: 查找名为nStr的节点
function TfFrameLog.FindTreeNode(const nStr: string): TTreeNode;
var nNode: TTreeNode;
begin
  Result := nil;
  nNode := Tv1.Items.GetFirstNode;
  while Assigned(nNode) do
  begin
    if nNode.Text = nStr then
    begin
      Result := nNode; Break;
    end;

    nNode := nNode.GetNext;
  end;
end;

//Desc: 清理nYear年份的所有日志
procedure TfFrameLog.ClearAllYear(const nYear: TTreeNode);
var nTmp,nNode: TTreeNode;
begin
  nNode := nYear.getFirstChild;
  while Assigned(nNode) do
  begin
    if nNode.Text = DateToStr(Now) then
    begin
      nNode := nNode.getNextSibling; Continue;
    end; //当天不让清空

    if ClearNodeLog(nNode) then
    begin
      nTmp := nNode;
      nNode := nNode.getNextSibling;
      nTmp.Delete;
    end else nNode := nNode.getNextSibling;
  end;

  if not nYear.HasChildren then
    nYear.Delete;
  //清空则删除
end;

//Desc: 清空nNode节点对应的日志
function TfFrameLog.ClearNodeLog(const nNode: TTreeNode): Boolean;
var nStr: string;
begin
  nStr := gPath + sLogDir + nNode.Text + sLogExt;
  if FileExists(nStr) then
       Result := DeleteFile(nStr)
  else Result := True;

  if Result and (nNode.Text = FNowDate) then
  begin
    Lv1.Items.BeginUpdate;
    Lv1.Items.Clear;
    Lv1.Items.EndUpdate;
  end; //若已载入日志的节点被删除,则清空
end;

//------------------------------------------------------------------------------
//Desc: 退出
procedure TfFrameLog.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//Desc: 清空日志
procedure TfFrameLog.BtnClearClick(Sender: TObject);
begin
  if not Assigned(Tv1.Selected) then
  begin
    ShowDlg(sClearHintSelect, sHint); Exit;
  end;

  if Tv1.Selected.Text = DateToStr(Now) then
  begin
    ShowDlg(sClearForbidToday, sHint); Exit;
  end;

  if Tv1.Selected.HasChildren then
  begin
    if QueryDlg(sClearAskForYear, sAsk) then
    begin
      ClearAllYear(Tv1.Selected); Exit;
    end;
  end;

  if Length(Tv1.Selected.Text) > 4 then
  begin
    if QueryDlg(Format(sClearAskForDay, [Tv1.Selected.Text]), sAsk) then
    begin
      if ClearNodeLog(Tv1.Selected) then Tv1.Selected.Delete; 
    end;
  end;
end;

//Desc: 载入日志明细
procedure TfFrameLog.Tv1Change(Sender: TObject; Node: TTreeNode);
var nStr: string;
    nFile: TextFile;
begin
  nStr := gPath + sLogDir + Node.Text + sLogExt;
  if not FileExists(nStr) then Exit;

  AssignFile(nFile, nStr);
  Lv1.Items.BeginUpdate;
  Application.ProcessMessages;

  try
    Reset(nFile);
    Lv1.Items.Clear;
    FNowDate := Node.Text;

    while not Eof(nFile) do
    begin
      ReadLn(nFile, nStr);
      AddLogItem(nStr);
    end;
  finally
    Lv1.Items.EndUpdate;
    CloseFile(nFile);
  end;

  HintPanel.Caption := Format(sLogInfo, [FYears, FDays, FNowDate, Lv1.Items.Count]);
  //显示摘要
end;

//Desc: 刷新
procedure TfFrameLog.BtnRefreshClick(Sender: TObject);
begin
  if Assigned(Tv1.Selected) then Tv1Change(nil, Tv1.Selected);
end;

//Desc: 控制菜单项
procedure TfFrameLog.PMenu1Popup(Sender: TObject);
begin
  mExpand.Enabled := Assigned(Tv1.Selected) and Tv1.Selected.HasChildren;
  mCollapse.Enabled := mExpand.Enabled; 
end;

//Desc: 控制菜单项
procedure TfFrameLog.PMenu2Popup(Sender: TObject);
begin
  mCopy.Enabled := Lv1.SelCount > 0;
  mExport.Enabled := mCopy.Enabled;
end;

//Desc: 日志树快捷菜单
procedure TfFrameLog.mExpandClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    10: if Assigned(Tv1.Selected) then Tv1.Selected.Expand(False);
    20: if Assigned(Tv1.Selected) then Tv1.Selected.Collapse(False);
    30: Tv1.FullExpand;
    40: Tv1.FullCollapse;
  end;
end;

//Desc: 组合nLv中的信息,填充到nList中
procedure CombinListData(const nList: TStrings; nLv: TListView; const nAll: Boolean);
var i,nCount: integer;
begin
  nList.Clear;
  nCount := nLv.Items.Count - 1;

  for i:=0 to nCount do
  if nAll or nLv.Items[i].Selected then
  begin
    nList.Add(nLv.Items[i].Caption + sLogField +
      CombinStr(nLv.Items[i].SubItems, sLogField));
    //组合日志
  end;
end;

//Desc: 导出数据
procedure TfFrameLog.ExportData(const nAll: Boolean);
var nStr: string;
    nList: TStrings;
begin
  with TSaveDialog.Create(Application) do
  begin
    if nAll then
         Title := '全部导出'
    else Title := '导出';

    Filter := sExportFilter;
    DefaultExt := sExportExt;
    
    InitialDir := FLastSave;
    Options := Options + [ofOverwritePrompt];
    if Execute then nStr := FileName else nStr := '';
    Free;
  end;

  if nStr = '' then Exit;
  nList := TStringList.Create;
  try
    CombinListData(nList, Lv1, nAll);
    nList.SaveToFile(nStr);
    
    FLastSave := ExtractFilePath(nStr);
    ShowDlg('日志导出成功', sHint);
  finally
    nList.Free;
  end;
end;

//Desc: 复制选中项到粘贴板
procedure TfFrameLog.mCopyClick(Sender: TObject);
var nList: TStrings;
begin
  nList := TStringList.Create;
  CombinListData(nList, Lv1, False);
  Clipboard.AsText := nList.Text;
  nList.Free;
end;

//Desc: 导出选中内容
procedure TfFrameLog.mExportClick(Sender: TObject);
begin
  ExportData(False);
end;

//Desc: 导出全部
procedure TfFrameLog.N9Click(Sender: TObject);
begin
  ExportData(True);
end;

initialization
  gControlManager.RegCtrl(TfFrameLog, TfFrameLog.FrameID);
end.
