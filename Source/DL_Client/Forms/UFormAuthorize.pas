{*******************************************************************************
  ◊˜’ﬂ: dmzn@163.com 2014/8/27
  √Ë ˆ: ∞≤»´—È÷§
*******************************************************************************}
unit UFormAuthorize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxLayoutControl, StdCtrls, cxContainer, cxEdit,
  cxTextEdit, cxLabel, cxMaskEdit, cxDropDownEdit;

type
  TfFormAuthorize = class(TfFormNormal)
    EditName: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMAC: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditFact: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditSerial: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditPoubdID: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditDepart: TcxComboBox;
    dxLayout1Item9: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditMITURL: TcxComboBox;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Item12: TdxLayoutItem;
    EditHardURL: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel2: TcxLabel;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadDepartmentList;
    procedure LoadDefaultURLs;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, UDataModule, UFormBase, UFormCtrl, USysDB, USysConst,UMgrLang;

class function TfFormAuthorize.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormAuthorize.Create(Application) do
  try
    Caption := 'Ω”»Î…Í«Î';
    with gSysParam do
    begin
      EditMAC.Text := FLocalMAC;
      EditName.Text := FLocalName;
      ActiveControl := EditSerial;
    end;

    LoadDefaultURLs;
    LoadDepartmentList;
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormAuthorize.FormID: integer;
begin
  Result := cFI_FormAuthorize;
end;

procedure TfFormAuthorize.LoadDepartmentList;
var nStr: string;
begin
  EditDepart.Clear;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_Departments]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := Fields[0].AsString;
    nStr := StringReplace(nStr, ';', #13, [rfReplaceAll]);
    EditDepart.Properties.Items.Text := nStr;
  end;
end;

procedure TfFormAuthorize.LoadDefaultURLs;
var nStr: string;
begin
  with EditMITURL.Properties do
  begin
    Items.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_MITSrvURL]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        Items.Add(Fields[0].AsString);
        Next;
      end;
    end;

    if (gSysParam.FMITServURL <> '') and
       (Items.IndexOf(gSysParam.FMITServURL) < 0) then
      Items.Add(gSysParam.FMITServURL);
    //xxxxx

    EditMITURL.Text := '';
    EditMITURL.ItemIndex := -1;
  end;

  with EditHardURL.Properties do
  begin
    Items.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_HardSrvURL]);

    with FDM.QueryTemp(nStr) do
     if RecordCount > 0 then
      Items.Add(Fields[0].AsString);
    //xxxxx

    if (gSysParam.FHardMonURL <> '') and
       (Items.IndexOf(gSysParam.FHardMonURL) < 0) then
      Items.Add(gSysParam.FHardMonURL);
    //xxxxx

    EditHardURL.Text := '';
    EditHardURL.ItemIndex := -1;
  end;
end;

function TfFormAuthorize.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditFact then
  begin
    EditFact.Text := Trim(EditFact.Text);
    Result := EditFact.Text <> '';
    nHint := '«ÎÃÓ–¥π§≥ß±‡∫≈';
  end else

  if Sender = EditSerial then
  begin
    EditSerial.Text := Trim(EditSerial.Text);
    Result := EditSerial.Text <> '';
    nHint := '«ÎÃÓ–¥µÁƒ‘±‡∫≈';
  end;

  if Sender = EditPoubdID then
  begin
    EditPoubdID.Text := Trim(EditPoubdID.Text);
    Result := EditPoubdID.Text <> '';
    nHint := '«ÎÃÓ–¥∞ı’æ±‡∫≈';
  end;
end;

procedure TfFormAuthorize.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;
  nStr := SF('W_MAC', gSysParam.FLocalMAC);
  
  nStr := MakeSQLByStr([SF('W_Name', EditName.Text),
          SF('W_Factory', EditFact.Text),
          SF('W_Departmen', EditDepart.Text),
          SF('W_Serial', EditSerial.Text),
          SF('W_ReqMan', gSysParam.FUserID),
          SF('W_PoundID', UpperCase(EditPoubdID.Text)),
          SF('W_ReqTime', sField_SQLServer_Now, sfVal),

          SF('W_MITUrl', EditMITURL.Text),
          SF('W_HardUrl', EditHardURL.Text)
          ], sTable_WorkePC, nStr, False);
  //xxxxx

  if FDM.ExecuteSQL(nStr) > 0 then
  begin
    ModalResult := mrOk;
    Exit;
  end;

  nStr := MakeSQLByStr([SF('W_Name', EditName.Text),
          SF('W_MAC', gSysParam.FLocalMAC),
          SF('W_Factory', EditFact.Text),
          SF('W_Departmen', EditDepart.Text),
          SF('W_Serial', EditSerial.Text),
          SF('W_ReqMan', gSysParam.FUserID),
          SF('W_PoundID', UpperCase(EditPoubdID.Text)),
          SF('W_ReqTime', sField_SQLServer_Now, sfVal),

          SF('W_MITUrl', EditMITURL.Text),
          SF('W_HardUrl', EditHardURL.Text)
          ], sTable_WorkePC, '', True);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormAuthorize, TfFormAuthorize.FormID);
end.
