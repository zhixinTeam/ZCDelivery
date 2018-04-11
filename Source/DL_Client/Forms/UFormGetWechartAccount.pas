{*******************************************************************************
  作者: dmzn@163.com 2017-10-26
  描述: 获取已注册微信账户
*******************************************************************************}
unit UFormGetWechartAccount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, ComCtrls, ImgList, ExtCtrls,
  cxTextEdit, cxMaskEdit, cxButtonEdit, cxListView, cxLabel,
  dxLayoutControl, StdCtrls;

type
  TWechatCustomer = record
    FBindID   : string;   //绑定客户id
    FCusName  : string;   //登录账号
    FEmail    : string;   //邮箱
    FPhone    : string;   //手机号码
    FSelected : Boolean;  //选中状态
  end;

  TWechatCustomers = array of TWechatCustomer;
  //账户列表

  TfFormGetWechartAccount = class(TfFormNormal)
    cxLabel1: TcxLabel;
    dxLayout1Item4: TdxLayoutItem;
    ListQuery: TcxListView;
    dxLayout1Item5: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    Timer1: TTimer;
    ImageList1: TImageList;
    procedure Timer1Timer(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditNamePropertiesChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FUsers: TWechatCustomers;
    procedure LoadCustomerList;
    procedure LoadCustomer(nFilter: string);
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  Contnrs, UFormBase, USysConst, UBusinessPacker, ULibFun, UMgrControl,
  UFormWait, USysBusiness;

class function TfFormGetWechartAccount.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nIdx: Integer;
    nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormGetWechartAccount.Create(Application) do
  try
    Caption := '选择账号';
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
    begin 
      nIdx := Integer(ListQuery.Selected.Data);
      nP.FParamB := FUsers[nIdx].FBindID;
      nP.FParamC := FUsers[nIdx].FCusName;
    end;
  finally
    Free;
  end;
end;

class function TfFormGetWechartAccount.FormID: integer;
begin
  Result := cFI_FormGetWXAccount;
end;

procedure TfFormGetWechartAccount.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormGetWechartAccount.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormGetWechartAccount.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  SetLength(FUsers, 0);
  LoadCustomer('');
end;

procedure TfFormGetWechartAccount.EditNamePropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  EditName.Text := '';
end;

procedure TfFormGetWechartAccount.EditNamePropertiesChange(Sender: TObject);
begin
  LoadCustomer(EditName.Text);
end;

//------------------------------------------------------------------------------
procedure TfFormGetWechartAccount.LoadCustomerList;
var nIdx: Integer;
begin
  ListQuery.Items.BeginUpdate;
  try
    ListQuery.Clear;
    for nIdx:=Low(FUsers) to High(FUsers) do
     with FUsers[nIdx] do
      begin
        if not FSelected then Continue;
        with ListQuery.Items.Add do
        begin
          Caption := FCusName;
          SubItems.Add('');
          SubItems.Add(FPhone);
          Data := Pointer(nIdx);
        end;
      end;
    //xxxxx

    if ListQuery.Items.Count > 0 then
      ListQuery.ItemIndex := 0;
    //select first
  finally
    ListQuery.Items.EndUpdate;
  end;
end;

procedure TfFormGetWechartAccount.LoadCustomer(nFilter: string);
var nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  if Length(FUsers) < 1 then
  begin
    nListA := nil;
    nListB := nil;
    ShowWaitForm(Self, '读取微信账户', True);
    try
      nListA := TStringList.Create;
      nListA.Text := getCustomerInfo('');
      nListB := TStringList.Create;

      nInt := 0;
      SetLength(FUsers, nListA.Count);

      for nIdx:=0 to nListA.Count-1 do
      begin
        nListB.Text := PackerDecodeStr(nListA[nIdx]);
        with FUsers[nInt],nListB do
        begin
          FBindID   := Values['BindID'];
          FCusName  := Values['Name'];
          FPhone    := Values['Phone'];

          Inc(nInt);
        end;
      end;
    finally
      nListA.Free;
      nListB.Free;
      CloseWaitForm;
    end;   
  end;

  if Length(FUsers) > 0 then
  begin
    nFilter := LowerCase(nFilter);
    //case

    for nIdx:=Low(FUsers) to High(FUsers) do
     with FUsers[nIdx] do
      FSelected := (nFilter = '') or
                   (Pos(nFilter, LowerCase(FCusName)) > 0) or
                   (Pos(nFilter, LowerCase(FPhone)) > 0);
    //set item status

    LoadCustomerList;
    //load ui
  end;
end;

procedure TfFormGetWechartAccount.EditNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    if ListQuery.ItemIndex >= 0 then
      ModalResult := mrOk;
    //xxxxx
  end;

end;

procedure TfFormGetWechartAccount.EditNameKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_UP then
  begin
    Key := 0;
    if ListQuery.ItemIndex > 0 then
      ListQuery.ItemIndex := ListQuery.ItemIndex - 1;
    //xxxx
  end;

  if Key = VK_DOWN then
  begin
    Key := 0;
    if ListQuery.ItemIndex < ListQuery.Items.Count-1 then
      ListQuery.ItemIndex := ListQuery.ItemIndex + 1;
    //xxxx
  end;
end;

procedure TfFormGetWechartAccount.BtnOKClick(Sender: TObject);
begin
  if ListQuery.ItemIndex < 0 then
       ShowMsg('请选择有效账户', sHint)
  else ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormGetWechartAccount, TfFormGetWechartAccount.FormID); 
end.
