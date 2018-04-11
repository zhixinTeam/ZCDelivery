{*******************************************************************************
  作者: dmzn@163.com 2009-6-5
  描述: 日期筛选框
*******************************************************************************}
unit UFormDateFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, dxLayoutControl, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxControls;

type
  TfFormDateFilter = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditStart: TcxDateEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditEnd: TcxDateEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item3: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowDateFilterForm(var nStart,nEnd: TDate; nTime: Boolean = False): Boolean;
procedure InitDateRange(const nID: string; var nS,nE: TDate);
procedure SaveDateRange(const nID: string; const nS,nE: TDate);
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, USysConst;

//Date: 2009-6-5
//Parm: 开始日期;结束日期
//Desc: 显示时间段筛选窗口
function ShowDateFilterForm(var nStart,nEnd: TDate; nTime: Boolean): Boolean;
begin
  with TfFormDateFilter.Create(Application) do
  begin
    Caption := '日期筛选';
    EditStart.Date := nStart;
    EditEnd.Date := nEnd;

    if nTime then
    begin
      EditStart.Properties.Kind := ckDateTime;
      EditEnd.Properties.Kind := ckDateTime;
    end else
    begin
      EditStart.Properties.Kind := ckDate;
      EditEnd.Properties.Kind := ckDate;
    end;

    Result := ShowModal = mrOK;
    if Result then
    begin
      nStart := EditStart.Date;
      nEnd := EditEnd.Date;
    end;
    Free;
  end;
end;

//Desc: 载入nID标识的日期区间
procedure InitDateRange(const nID: string; var nS,nE: TDate);
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := nIni.ReadString(nID, 'DateRange_Last', '');
    if nStr = Date2Str(Now) then
    begin
      nStr := nIni.ReadString(nID, 'DateRange_S', Date2Str(Now));
      nS := Str2Date(nStr);

      nStr := nIni.ReadString(nID, 'DateRange_E', Date2Str(Now));
      nE := Str2Date(nStr);
    end else
    begin
      nS := Date; nE := Date;
    end;
  finally
    nIni.Free;
  end;
end;

//Desc: 将日期区间存入nID标识中
procedure SaveDateRange(const nID: string; const nS,nE: TDate);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteString(nID, 'DateRange_S', Date2Str(nS));
    nIni.WriteString(nID, 'DateRange_E', Date2Str(nE));
    nIni.WriteString(nID, 'DateRange_Last', Date2Str(Now));
  finally
    nIni.Free;
  end;
end;

//Desc: 日期选择
procedure TfFormDateFilter.BtnOKClick(Sender: TObject);
begin
  if EditEnd.Date < EditStart.Date then
  begin
    EditEnd.SetFocus;
    ShowMsg('结束日期不能小于开始日期', sHint);
  end else ModalResult := mrOK;
end;

end.
