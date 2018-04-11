{*******************************************************************************
  作者: dmzn@163.com 2009-6-13
  描述: 添加、修改、删除、浏览处理Form基类
*******************************************************************************}
unit UFormNormal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, ULibFun, UAdjustForm, USysConst, dxLayoutControl,
  StdCtrls, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormNormal = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item1: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; virtual;
    function IsDataValid: Boolean; virtual;
    {*验证数据*}
    procedure GetSaveSQLList(const nList: TStrings); virtual;
    {*写SQL列表*}
    procedure AfterSaveData(var nDefault: Boolean); virtual;
    {*后续动作*}
  end;

implementation

{$R *.dfm}

procedure TfFormNormal.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 写数据SQL列表
procedure TfFormNormal.GetSaveSQLList(const nList: TStrings);
begin
  nList.Clear;
end;

//Desc: 验证Sender的数据是否正确,返回提示内容
function TfFormNormal.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  nHint := '';
  Result := True;
end;

//Desc: 验证数据是否正确
function TfFormNormal.IsDataValid: Boolean;
var nStr: string;
    nCtrls: TList;
    nObj: TObject;
    i,nCount: integer;
begin
  Result := True;

  nCtrls := TList.Create;
  try
    EnumSubCtrlList(Self, nCtrls);
    nCount := nCtrls.Count - 1;

    for i:=0 to nCount do
    begin
      nObj := TObject(nCtrls[i]);
      if not OnVerifyCtrl(nObj, nStr) then
      begin
        if nObj is TWinControl then
          TWinControl(nObj).SetFocus;
        //xxxxx
        
        if nStr <> '' then
          ShowMsg(nStr, sHint);
        Result := False; Exit;
      end;
    end;
  finally
    nCtrls.Free;
  end;
end;

//Desc: 保存后续动作
procedure TfFormNormal.AfterSaveData(var nDefault: Boolean);
begin

end;

//Desc: 保存
procedure TfFormNormal.BtnOKClick(Sender: TObject);
var nBool: Boolean;
    nSQLs: TStrings;
    i,nCount: integer;
begin
  if not IsDataValid then Exit;
  
  nSQLs := nil;
  try
    nSQLs := TStringList.Create;
    GetSaveSQLList(nSQLs);

    if nSQLs.Count > 0 then
    begin
      FDM.ADOConn.BeginTrans;
      nCount := nSQLs.Count - 1;

      for i:=0 to nCount do
        FDM.ExecuteSQL(nSQLs[i]);
      FDM.ADOConn.CommitTrans;
    end;

    FreeAndNil(nSQLs);
    nBool := True;
    AfterSaveData(nBool);

    if nBool then
    begin
      ModalResult := mrOK;
      ShowMsg('已保存成功', sHint);
    end;
  except
    if Assigned(nSQLs) then nSQLs.Free;
    if FDM.ADOConn.InTransaction then FDM.ADOConn.RollbackTrans;
    ShowMsg('保存数据失败', sError);
  end;
end;

end.
