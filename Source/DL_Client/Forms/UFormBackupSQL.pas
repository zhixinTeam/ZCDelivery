{*******************************************************************************
  作者: dmzn@163.com 2009-6-13
  描述: 数据备份窗口
*******************************************************************************}
unit UFormBackupSQL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, dxLayoutControl, cxControls, StdCtrls, cxMemo, cxContainer,
  cxEdit, cxTextEdit, UFormBase;

type
  TfFormBackupSQL = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    EditLastName: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item3: TdxLayoutItem;
    EditLastTime: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTime: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item6: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    //创建实例
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormConn, UFormWait, USysDB, USysConst;

//------------------------------------------------------------------------------
//Desc: 数据备份窗体
class function TfFormBackupSQL.CreateForm;
begin
  Result := nil;
  if gSysDBType <> dtSQLServer then
  begin
    ShowMsg('该功能支持SQLServer数据库', sHint); Exit;
  end;

  with TfFormBackupSQL.Create(Application) do
  begin
    Caption := '数据备份';
    ShowModal;
    Free;
  end;
end;

class function TfFormBackupSQL.FormID: integer;
begin
  Result := cFI_FormBackup;
end;

procedure TfFormBackupSQL.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nStr := gPath + sBackupDir;
  if not DirectoryExists(nStr) then ForceDirectories(nStr);

  nIni := TIniFile.Create(nStr + sBackupFile);
  try
    EditLastName.Text := nIni.ReadString('Setup', 'LastName', '无');
    EditLastTime.Text := nIni.ReadString('Setup', 'LastTime', '无');
    EditTime.Text := DateTimeToStr(Now);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBackupSQL.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 创建备份文件名
function MakeBackFile: string;
begin
  Result := FloatToStr(Now);
  Result := StringReplace(Result, '.', '', []);
  Result := gPath + sBackupDir + Result + '.bak';

  while FileExists(Result) do
    Result := MakeBackFile;
  //xxxxx
end;

//Desc: 替换回车键
function FixedEnterKey(const nText: string): string;
begin
  Result := StringReplace(nText, #13#10, '|:)', [rfReplaceAll]); 
end;

//Desc: 开始备份
procedure TfFormBackupSQL.BtnOKClick(Sender: TObject);
var nIni: TIniFile;
    nList: TStrings;
    nStr,nFile: string;
begin
  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    ShowMsg('请填写有效的备份名称', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    LoadConnecteDBConfig(nList);

    nStr := 'Backup Database %s To Disk=''%s''';
    nFile := MakeBackFile;
    nStr := Format(nStr, [nList.Values[sConn_Key_DBCatalog], nFile]);
  finally
    nList.Free;
  end;

  nIni := nil;
  ShowWaitForm(Self, '正在备份');
  try
    FDM.ExecuteSQL(nStr);

    nIni := TIniFile.Create(gPath + sBackupDir + sBackupFile);
    nIni.WriteString('Setup', 'LastName', EditName.Text);
    nIni.WriteString('Setup', 'LastTime', EditTime.Text);

    nStr := cSysDatabaseName[Ord(dtSQLServer)] + '_' + FloatToStr(Now);
    nIni.WriteString(nStr, 'BackName', EditName.Text);
    nIni.WriteString(nStr, 'BackTime', EditTime.Text);
    nIni.WriteString(nStr, 'BackMemo', FixedEnterKey(EditMemo.Text));
    nIni.WriteString(nStr, 'BackFile', nFile);

    nIni.Free;
    ModalResult := mrOk;

    CloseWaitForm;
    ShowMsg('数据备份成功', sHint);
  except
    if Assigned(nIni) then nIni.Free;
    CloseWaitForm;
    ShowMsg('执行备份操作失败', '未知错误');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBackupSQL, TfFormBackupSQL.FormID);
end.
