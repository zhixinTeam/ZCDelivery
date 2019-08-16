{*******************************************************************************
  作者: juner11212436@163.com 2018-05-14
  描述: 车牌识别启用停用
*******************************************************************************}
unit UFormSnapTruckSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxControls,
  cxContainer, cxEdit, cxTextEdit, UFormBase, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, cxMaskEdit,
  cxDropDownEdit;

type
  TfFormSnapTruckSet = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    cxComboBox1: TcxComboBox;
    dxLayoutControl1Item2: TdxLayoutItem;
    cxbPost: TcxComboBox;
    dxLayoutControl1Item1: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure cxbPostPropertiesChange(Sender: TObject);
    procedure cxComboBox1PropertiesChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, USysPopedom;

type
  TSnapPostItem = record
    FID     : string;
    FStatus : string;
  end;

var
  gSnapPostItem: array of TSnapPostItem;
  //仓库列表

//------------------------------------------------------------------------------
class function TfFormSnapTruckSet.CreateForm;
var nStr: string;
    nIdx: Integer;
begin
  Result := nil;

  with TfFormSnapTruckSet.Create(Application) do
  begin
    BtnOK.Enabled := False;
    nStr := 'select D_Value, D_Memo from %s where D_Name=''%s'' ';
    nStr := Format(nStr, [sTable_SysDict, sFlag_TruckInNeedManu]);

    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      cxbPost.Properties.Items.Clear;

      SetLength(gSnapPostItem, RecordCount);
      nIdx := 0;

      First;

      while not Eof do
      begin
        gSnapPostItem[nIdx].FID     := Fields[1].AsString;
        gSnapPostItem[nIdx].FStatus := Fields[0].AsString;
        cxbPost.Properties.Items.Add(gSnapPostItem[nIdx].FID);
        Inc(nIdx);
        Next;
      end;

      cxbPost.ItemIndex := 0;
      cxbPost.Properties.OnChange(nil);
      BtnOK.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
    end;
    ShowModal;
    Free;
  end;
end;

class function TfFormSnapTruckSet.FormID: integer;
begin
  Result := cFI_FormSnapTruckSet;
end;

//------------------------------------------------------------------------------
//Desc: 保存
procedure TfFormSnapTruckSet.BtnOKClick(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  try
    for nIdx := Low(gSnapPostItem) to High(gSnapPostItem) do
    begin
      if gSnapPostItem[nIdx].FStatus = sFlag_Yes then
      begin
        nStr:='Update %s set D_Value=''%s'' where D_Name=''%s'' and D_Memo=''%s'' ';
        nStr := Format(nStr, [sTable_SysDict, sFlag_Yes, sFlag_TruckInNeedManu,
                              gSnapPostItem[nIdx].FID]);
      end else
      begin
        nStr:='Update %s set D_Value=''%s'' where D_Name=''%s'' and D_Memo=''%s'' ';
        nStr := Format(nStr, [sTable_SysDict, sFlag_No, sFlag_TruckInNeedManu,
                              gSnapPostItem[nIdx].FID]);
      end;
      FDM.ExecuteSQL(nStr, False);
    end;
    ModalResult := mrOK;
    ShowMsg('模式切换成功', sHint);
  except
    ShowMsg('切换状态时发生未知错误', '保存失败');
  end;
end;

procedure TfFormSnapTruckSet.cxbPostPropertiesChange(Sender: TObject);
begin
  if gSnapPostItem[cxbPost.ItemIndex].FStatus = sFlag_Yes then
    cxComboBox1.ItemIndex := 0
  else
    cxComboBox1.ItemIndex := 1;
end;

procedure TfFormSnapTruckSet.cxComboBox1PropertiesChange(Sender: TObject);
begin
  if cxComboBox1.ItemIndex = 0 then
    gSnapPostItem[cxbPost.ItemIndex].FStatus := sFlag_Yes
  else
    gSnapPostItem[cxbPost.ItemIndex].FStatus := sFlag_No;
end;

initialization
  gControlManager.RegCtrl(TfFormSnapTruckSet, TfFormSnapTruckSet.FormID);
end.
