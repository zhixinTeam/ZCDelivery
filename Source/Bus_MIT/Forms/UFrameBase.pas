{*******************************************************************************
  作者: dmzn@163.com 2009-5-22
  描述: Frame基类,实现统一的函数调用
*******************************************************************************}
unit UFrameBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  TypInfo;

type
  PFrameCommandParam = ^TFrameCommandParam;
  TFrameCommandParam = record
    FCommand: integer;
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;
  end;
  
  TfFrameBase = class(TFrame)
  private
    FParentForm: TForm;
    {所在窗体}
    FIsBusy: Boolean;
    {*繁忙状态*}
    FPopedom: string;
    {*权限项*}
    FOldAlign: TAlign;
    FCentered: Boolean;
    {*居中显示*}
  protected
    { Protected declarations }
    FHorCentered: Boolean;
    FHorEdge: Integer;
    FVerCentered: Boolean;
    FVerEdge: Integer;
    {*居中设置*}
    procedure OnCreateFrame; virtual;
    procedure OnShowFrame; virtual;
    procedure OnDestroyFrame; virtual;
    procedure DoOnClose(var nAction: TCloseAction); virtual;
    procedure OnLoadPopedom; virtual;
    {*可继承*}
    function GetParentForm: Boolean;
    procedure SetPopedom(const nItem: string);
    procedure CMRelease(var Message: TMessage); message CM_RELEASE;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure SetCentered(const nValue: Boolean);
    procedure DoParentResizeBind(const nUnBind: Boolean);
    {*xxxxx*}
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*创建释放*}
    procedure Close(const nEvent: Boolean = True);
    {*关闭*}
    function DealCommand(Sender: TObject; const nCmd: Integer;
     const nParamA: Pointer; const nParamB: Integer): Integer; virtual;
    {*处理命令*}
    class function GetCtrlParentForm(const nCtrl: TWinControl): TForm;
    {*获取窗体*}
    class function FrameID: integer; virtual; abstract;
    {*标识*}
    property ParentForm: TForm read FParentForm;
    property PopedomItem: string read FPopedom write SetPopedom;
    property IsBusy: Boolean read FIsBusy write FIsBusy;
    property Centered: Boolean read FCentered write SetCentered;
    {*属性相关*}
  published
    procedure DoParentResize(Sender: TObject);
    {*宣告事件*}
  end;

function CreateBaseFrameItem(const nFrameID: Integer; const nParent: TWinControl;
 const nAlign: TAlign = alClient; const nPopedom: string = ''): TfFrameBase;
function BroadcastFrameCommand(Sender: TObject; const nCmd:integer;
 const nParamA: Pointer = nil; const nParamB: Integer = -1): integer;
//入口函数

implementation

{$R *.dfm}
uses
  UMgrControl;

//Desc: 将命令广播给所有的Frame类
function BroadcastFrameCommand(Sender: TObject; const nCmd:integer;
 const nParamA: Pointer; const nParamB: Integer): integer;
var nList: TList;
    i,nCount: integer;
begin
  nList := TList.Create;
  try
    Result := 0;
    if not gControlManager.GetAllInstance(nList) then Exit;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
     if TObject(nList[i]) is TfFrameBase then
      Result := Result + TfFrameBase(nList[i]).DealCommand(Sender, nCmd,
       nParamA, nParamB);
    //broadcast command and combine then result
  finally
    nList.Free;
  end;
end;

//Date: 2009-6-13
//Parm: FrameID;父容器;权限项
//Desc: 创建标识为nFormID的Frame实例
function CreateBaseFrameItem(const nFrameID: Integer; const nParent: TWinControl;
 const nAlign: TAlign; const nPopedom: string): TfFrameBase;
var nCtrl: TWinControl;
begin
  Result := nil;
  nCtrl := gControlManager.NewCtrl2(nFrameID, nParent, nAlign);

  if Assigned(nCtrl) and (nCtrl is TfFrameBase) then
       Result := nCtrl as TfFrameBase
  else Exit;

  Result.PopedomItem := nPopedom;
  Result.BringToFront;
end;

//------------------------------------------------------------------------------
constructor TfFrameBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not GetParentForm then
    raise Exception.Create('Invalid Frame Owner');
  //no parent isn't invalid

  FIsBusy := False;
  FCentered := False;
  
  FHorCentered := True;
  FHorEdge := 0;
  FVerCentered := False;
  FVerEdge := 0;

  OnCreateFrame;
  if FHorCentered then
  begin
    Anchors := Anchors - [akRight];
  end else
  begin
    Anchors := Anchors + [akRight];
    Height := TWinControl(AOwner).Width - FHorEdge;
  end;
  
  if FVerCentered then
  begin
    Anchors := Anchors - [akBottom];
  end else
  begin
    Anchors := Anchors + [akBottom];
    Height := TWinControl(AOwner).Height - FVerEdge;
  end;
end;

destructor TfFrameBase.Destroy;
begin
  OnDestroyFrame;
  Centered := False;
  gControlManager.FreeCtrl(FrameID, False);
  inherited;
end;

//Desc: 关闭
procedure TfFrameBase.Close;
var nAction: TCloseAction;
begin
  nAction := caFree;
  if nEvent then DoOnClose(nAction);

  if nAction = caFree then
  begin
    PostMessage(Handle, CM_RELEASE, 0, 0);
  end else //释放
  if nAction = caHide then
  begin
    Visible := False;
  end; //隐藏
end;

//Desc: 关闭时释放
procedure TfFrameBase.CMRelease(var Message: TMessage);
begin
  inherited;
  Free;
end;

//Desc: 显示时触发
procedure TfFrameBase.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then OnShowFrame;
end;

//Desc: 查询nCtrl所在窗体
class function TfFrameBase.GetCtrlParentForm(const nCtrl: TWinControl): TForm;
var nTmp: TWinControl;
begin
  Result := nil;
  nTmp := nCtrl;

  while Assigned(nTmp) do
  if nTmp is TForm then
  begin
    Result := nTmp as TForm;
    Break;
  end else nTmp := nTmp.Parent;
end;

//Desc: 查找所在窗体
function TfFrameBase.GetParentForm: Boolean;
begin
  if Owner is TWinControl then
       FParentForm := GetCtrlParentForm(Owner as TWinControl)
  else FParentForm := nil;

  Result := Assigned(FParentForm);
end;

//Desc: 设置权限项
procedure TfFrameBase.SetPopedom(const nItem: string);
begin
  if FPopedom <> nItem then
  begin
    FPopedom := nItem;
    OnLoadPopedom;
  end;
end;

//Desc: 设置居中
procedure TfFrameBase.SetCentered(const nValue: Boolean);
begin
  if nValue <> FCentered then
  begin
    FCentered := nValue;

    if nValue then
    begin
      FOldAlign := Align;
      Align := alNone;

      DoParentResize(nil);
      DoParentResizeBind(False)
    end else
    begin
      Align := FOldAlign;
      DoParentResizeBind(True)
    end;
  end;
end;

//Desc: 绑定事件到父窗体
procedure TfFrameBase.DoParentResizeBind(const nUnBind: Boolean);
var nMethod: TMethod;
begin
  if Assigned(Parent) and IsPublishedProp(Parent, 'OnResize') then
  begin
    nMethod := GetMethodProp(Parent, 'OnResize');
    if nUnBind then
    begin
      if nMethod.Data <> Self then Exit;
      //三方已挂载

      nMethod.Code := nil;
      nMethod.Data := Parent;
    end else
    begin
      nMethod.Code := MethodAddress('DoParentResize');
      nMethod.Data := Self;
    end;

    SetMethodProp(Parent, 'OnResize', nMethod);
  end;
end;

procedure TfFrameBase.DoParentResize(Sender: TObject);
var nInt: Integer;
    nP: TWinControl;
begin
  if Assigned(Parent) then
  begin
    nP := TWinControl(Parent);
    if FHorCentered then
    begin
      nInt := Round((nP.Width - Width) / 2);
      if nInt > 0 then Left := nInt else Top := 0;
    end else Left := 0;

    if FVerCentered then
    begin
      nInt := Round((nP.Height - Height) / 2);
      if nInt > 0 then Top := nInt else Top := 0;
    end else Top := 0;     
  end;
end;

//Desc: 关闭
procedure TfFrameBase.DoOnClose(var nAction: TCloseAction);
begin

end;

//Desc: 显示
procedure TfFrameBase.OnShowFrame;
begin

end;

//Desc: 载入权限
procedure TfFrameBase.OnLoadPopedom;
begin

end;

//Desc: 创建
procedure TfFrameBase.OnCreateFrame;
begin

end;

//Desc: 释放
procedure TfFrameBase.OnDestroyFrame;
begin

end;

//Desc: 处理命令
function TfFrameBase.DealCommand(Sender: TObject; const nCmd: integer;
  const nParamA: Pointer; const nParamB: Integer): integer;
begin
  Result := -1;
end;

end.
