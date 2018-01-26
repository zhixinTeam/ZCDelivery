{*******************************************************************************
  作者: dmzn@163.com 2009-6-13
  描述: 数据还原窗口
*******************************************************************************}
unit UFormRestoreAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, dxLayoutControl, cxControls, StdCtrls, cxMemo, cxContainer,
  cxEdit, cxTextEdit, cxMCListBox, Menus, UFormBase;

type
  TfFormRestoreAccess = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item3: TdxLayoutItem;
    EditTime: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item6: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item7: TdxLayoutItem;
    BackList1: TcxMCListBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BackList1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
    FDataFile: string;
    //数据文件
    procedure LoadBackList;
    //载入备份
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ZLIBEX, ULibFun, UMgrControl, UFormConn, UFormWait, USysDB,
  USysConst;

//------------------------------------------------------------------------------
//Desc: 数据还原窗体
class function TfFormRestoreAccess.CreateForm;
begin
  Result := nil;
  if gSysDBType <> dtAccess then
  begin
    ShowMsg('该功能只支持单机数据库', sHint); Exit;
  end;

  with TfFormRestoreAccess.Create(Application) do
  begin
    Caption := '数据还原';
    ShowModal;
    Free;
  end;
end;

class function TfFormRestoreAccess.FormID: integer;
begin
  Result := cFI_FormRestore;
end;

procedure TfFormRestoreAccess.FormCreate(Sender: TObject);
begin
  LoadBackList;
end;

procedure TfFormRestoreAccess.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------  .
//Desc: 载入备份列表
procedure TfFormRestoreAccess.LoadBackList;
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  nStr := gPath + sBackupDir;
  if not DirectoryExists(nStr) then ForceDirectories(nStr);

  nIni := TIniFile.Create(nStr + sBackupFile);
  nList := TStringList.Create;
  try
    nIni.ReadSections(nList);
    BackList1.Clear;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      if Pos(cSysDatabaseName[Ord(dtAccess)], nList[i]) < 1 then Continue;
      //非Access备份

      nStr := nIni.ReadString(nList[i], 'BackName', '');
      if nStr = '' then Continue;

      nStr := nList[i] + BackList1.Delimiter +
              nStr + BackList1.Delimiter +
              nIni.ReadString(nList[i], 'BackTime', ' ') + BackList1.Delimiter +
              nIni.ReadString(nList[i], 'BackMemo', ' ') + BackList1.Delimiter +
              nIni.ReadString(nList[i], 'BackFile', ' ');
      BackList1.Items.Add(nStr);
    end;
  finally
    nList.Free;
    nIni.Free;
  end;
end;

//Desc: 刷新
procedure TfFormRestoreAccess.N1Click(Sender: TObject);
begin
  LoadBackList;
end;

//Desc: 删除备份
procedure TfFormRestoreAccess.N2Click(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
    nList: TStrings;
begin
  if BackList1.ItemIndex < 0 then Exit;
  nIni := nil;
  nList := TStringList.Create;
  try
    nStr := BackList1.Items[BackList1.ItemIndex];
    if not SplitStr(nStr, nList, 5, BackList1.Delimiter) then Exit;

    nStr := '备份数据删除后将不可恢复!!' + #13#10 +
            '确定要删除备份[ %s ]吗?';
    nStr := Format(nStr, [nList[1]]);
    if not QueryDlg(nStr, sAsk) then Exit;

    nStr := nList[4];
    if (not FileExists(nStr)) or DeleteFile(nStr) then
    begin
      nIni := TIniFile.Create(gPath + sBackupDir + sBackupFile);
      nIni.EraseSection(nList[0]);

      LoadBackList;
      ShowMsg('备份已成功删除', sHint);
    end;
  finally
    nList.Free;
    if Assigned(nIni) then nIni.Free;
  end;
end;

//Desc: 替换回车键
function FixedEnterKey(const nText: string): string;
begin
  Result := StringReplace(nText, '|:)', #13#10, [rfReplaceAll]);
end;

//Desc: 显示备份细节
procedure TfFormRestoreAccess.BackList1Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  FDataFile := '';
  if BackList1.ItemIndex < 0 then Exit;
  
  nList := TStringList.Create;
  try
    nStr := BackList1.Items[BackList1.ItemIndex];
    if not SplitStr(nStr, nList, 5, BackList1.Delimiter) then Exit;

    EditName.Text := nList[1];
    EditTime.Text := nList[2];
    EditMemo.Text := FixedEnterKey(nList[3]);
    FDataFile := nList[4];
  finally
    nList.Free;
  end;
end;

//Date: 2009-9-16
//Parm: 源文件;目标文件
//Desc: 解压nSource文件,存入nDest
procedure UnZipFileForBackup(const nSource, nDest: string);
const
  nBufSize = $F000;
var
  nLeft: Int64;
  nSStream: TFileStream;
	nDStream: TFileStream;
  nBuf: array [0..nBufSize] of Byte;
  nZipStream: TZDecompressionStream;
begin
  nSStream := nil;
  nDStream := nil;
  nZipStream := nil;
  try
    nDStream := TFileStream.Create(nDest, fmCreate);
    nSStream := TFileStream.Create(nSource, fmOpenRead);
    
    nZipStream := TZDecompressionStream.Create(nSStream);
    nZipStream.Seek(0, soFromBeginning); 
    nLeft := nZipStream.Size;

    while nLeft > 0 do
    begin
       if nLeft > nBufSize then
       begin
         nZipStream.Read(nBuf, nBufSize);
         nDStream.Write(nBuf, nBufSize);
       end else
       begin
         nZipStream.Read(nBuf, nLeft);
         nDStream.Write(nBuf, nLeft);
       end;

       nLeft := nLeft - nBufSize;
    end;
  finally
    nZipStream.Free;
    nSStream.Free;
    nDStream.Free;
  end;
end;

//Desc: 开始备份
procedure TfFormRestoreAccess.BtnOKClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if BackList1.ItemIndex < 0 then
  begin
    BackList1.SetFocus;
    ShowMsg('请选择有效的备份', sHint); Exit;
  end;

  if not FileExists(FDataFile) then
  begin
    ShowMsg('该备份已经失效', sHint); Exit;
  end;

  nStr := '现有的数据将被覆盖且不可恢复!!' + #13#10 +
          '确定要还原数据吗?';
  if not QueryDlg(nStr, sAsk) then Exit;

  nList := TStringList.Create;
  try
    LoadConnecteDBConfig(nList);
    nStr := nList.Values[sConn_Key_PathValue];
    if nStr = '' then nStr := gPath;

    if Copy(nStr, Length(nStr), 1) = '\' then
      System.Delete(nStr, Length(nStr), 1);
    //xxxxx

    nStr := StringReplace(nList.Values[sConn_Key_DBFile], sConn_Path, nStr,
                          [rfReplaceAll, rfIgnoreCase]);
    //xxxxx
  finally
    nList.Free;
  end;

  ShowWaitForm(Self, '正在还原');
  try
    FDM.ADOConn.Connected := False;
    UnZipFileForBackup(FDataFile, nStr);
    FDM.ADOConn.Connected := True;

    ModalResult := mrOk;
    CloseWaitForm;
    ShowMsg('数据还原成功', sHint);
  except
    CloseWaitForm;
    ShowMsg('执行还原操作失败', '未知错误');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormRestoreAccess, TfFormRestoreAccess.FormID);
end.
