{*******************************************************************************
  作者: juner11212436@163.com 2017-12-28
  描述: 自助打印化验单
*******************************************************************************}
unit uZXHyPrint;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxLabel, Menus, StdCtrls, cxButtons, cxGroupBox,
  cxRadioGroup, cxTextEdit, cxCheckBox, ExtCtrls, dxLayoutcxEditAdapters,
  dxLayoutControl, cxDropDownEdit, cxMaskEdit, cxButtonEdit,
  USysConst, cxListBox, ComCtrls,Contnrs,UFormCtrl, CPort,UFormMain;

type
  TfFormZXHyPrint = class(TForm)
    editWebOrderNo: TcxTextEdit;
    labelIdCard: TcxLabel;
    btnOK: TcxButton;
    PanelTop: TPanel;
    Label1: TLabel;
    btnExit: TcxButton;
    TimerAutoClose: TTimer;
    BtnClear: TcxButton;
    procedure GetCard( Var message : TMessage ) ; message WM_HAVE_CARD ;
    procedure BtnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure editWebOrderNoPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FAutoClose:Integer; //窗口自动关闭倒计时（分钟）
    Fbegin:TDateTime;
    FProID: string;
    procedure Writelog(nMsg:string);
  public
    { Public declarations }
    procedure SetControlsClear;
  end;

var
  fFormZXHyPrint: TfFormZXHyPrint;

implementation
uses
  ULibFun,UBusinessPacker,USysLoger,UBusinessConst,USysBusiness,USysDB,
  UAdjustForm,UFormBase,UDataReport,UDataModule,NativeXml,UFormWait,
  DateUtils;
{$R *.dfm}

{ TfFormZXHyPrint }

procedure TfFormZXHyPrint.SetControlsClear;
var
  i:Integer;
begin
  editWebOrderNo.Clear;
end;

procedure TfFormZXHyPrint.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormZXHyPrint.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=  caFree;
  fFormZXHyPrint := nil;
end;

procedure TfFormZXHyPrint.btnClearClick(Sender: TObject);
begin
  FAutoClose := gSysParam.FAutoClose_Mintue;
  editWebOrderNo.Clear;
  ActiveControl := editWebOrderNo;
end;

procedure TfFormZXHyPrint.FormShow(Sender: TObject);
begin
  btnOK.Enabled := False;

  FAutoClose := gSysParam.FAutoClose_Mintue;
  TimerAutoClose.Interval := 60*1000;
  TimerAutoClose.Enabled := True;
end;

procedure TfFormZXHyPrint.TimerAutoCloseTimer(Sender: TObject);
begin
  if FAutoClose=0 then
  begin
    TimerAutoClose.Enabled := False;
    Close;
  end;
  Dec(FAutoClose);
end;

procedure TfFormZXHyPrint.FormCreate(Sender: TObject);
begin
  if not Assigned(FDR) then
  begin
    FDR := TFDR.Create(Application);
  end;
  gSysParam.FUserID := 'AICM';
end;

procedure TfFormZXHyPrint.Writelog(nMsg: string);
begin
  gSysLoger.AddLog(nMsg);
end;

procedure TfFormZXHyPrint.btnOKClick(Sender: TObject);
var nMsg, nStr, nID, nHYDan: string;
    nIdx: Integer;
begin
  btnOK.Enabled := False;
  nID := Trim(editWebOrderNo.Text);
  if nID = '' then
  begin
    ShowMsg('请输入提货单号', sHint);
    editWebOrderNo.SetFocus;
    editWebOrderNo.Clear;
    Exit;
  end;

  nStr := 'Select L_ID, L_HYDan From %s Where L_ID like ''%%%s%%''';
  nStr := Format(nStr, [sTable_Bill, nID]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nStr := '未找到单据,无法打印';
      ShowMsg(nStr, sHint);
      editWebOrderNo.SetFocus;
      editWebOrderNo.Clear;
      Exit;
    end;

    if RecordCount > 1 then
    begin
      nStr := '未匹配到唯一单据,请输入准确单据号';
      editWebOrderNo.SetFocus;
      editWebOrderNo.Clear;
      Exit;
    end;

    nID := Fields[0].AsString;
    nHYDan := Fields[1].AsString;
  end;
  editWebOrderNo.Clear;
  {$IFDEF AHZC}
  PrintHeGeReport(nID, nMsg, gSysParam.FHYDanPrinter);
  {$ELSE}
  if nHYDan = '' then
  begin
    nStr := '提货单[ %s ]批次号为空,无法打印';
    nStr := Format(nStr,[nID]);
    editWebOrderNo.SetFocus;
    editWebOrderNo.Clear;
    Exit;
  end;

//  if not SaveHYData(nHYDan) then
//  begin
//    nStr := '提货单[ %s ]批次号[ %s ]获取化验数据失败,请联系管理员';
//    nStr := Format(nStr,[nID, nHYDan]);
//    editWebOrderNo.SetFocus;
//    Exit;
//  end;

  PrintHuaYanReport(nID, nMsg, gSysParam.FHYDanPrinter);
  {$ENDIF}
  if nMsg <> '' then
  begin
    ShowMsg(nMsg, sHint);
    editWebOrderNo.SetFocus;
    editWebOrderNo.Clear;
    Exit;
  end;
  editWebOrderNo.Text := '';
  FAutoClose := 0;
end;

procedure TfFormZXHyPrint.editWebOrderNoPropertiesChange(Sender: TObject);
begin
  if Length(Trim(editWebOrderNo.Text)) > 6 then
    btnOK.Enabled := True
  else
    btnOK.Enabled := False;
end;

procedure TfFormZXHyPrint.GetCard( Var message : TMessage ) ;
Var nSql: string;
Begin
  editWebOrderNo.Clear;
  nSql := 'select top 1 L_ID from %s where L_Card=''%s'' order by R_ID desc';
  nSql := Format(nSql,[sTable_Bill,gCard]);
  with FDM.QuerySQL(nSql) do
  begin
    if RecordCount<=0 then
    begin
      ShowMsg('磁卡号无效', sHint);
      Exit;
    end;
    editWebOrderNo.Text := Fields[0].AsString;
  end;
End ;

end.
