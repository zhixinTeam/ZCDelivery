{*******************************************************************************
  作者: dmzn@163.com 2013-11-27
  描述: 运行参数设置
*******************************************************************************}
unit UFrameParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFrameBase, ExtCtrls, Grids, ValEdit, UZnValueList, Menus;

{$I Link.Inc}
type
  TfFrameParam = class(TfFrameBase)
    ListParam: TZnValueList;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure ListParamDblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    procedure NewParamItem(const nKey,nFlag: string;
     nImage: Integer = cIcon_Key);
    procedure UpdateItem(const nFlag,nValue: string;
     nImage: Integer = -1);
    procedure UpdateParam;
    //更新摘要
    procedure LoadConfig(const nLoad: Boolean);
    //界面配置
  public
    { Public declarations }
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, IniFiles, UMgrControl, UMgrDBConn, UMgrParam, USAPConnection,
  UFormBase, USmallFunc, UMITConst;

class function TfFrameParam.FrameID: integer;
begin
  Result := cFI_FrameParam;
end;

procedure TfFrameParam.OnCreateFrame;
begin
  inherited;
  Name := MakeFrameName(FrameID);
  ListParam.DoubleBuffered := True;

  {$IFDEF DBPool}N2.Visible := True;{$ENDIF}
  {$IFDEF SAP}N3.Visible := True;{$ENDIF}

  LoadConfig(True);
  UpdateParam;
end;

//Desc: 刷新服务状态
procedure TfFrameParam.OnDestroyFrame;
begin
  inherited;
  LoadConfig(False);
end;

procedure TfFrameParam.LoadConfig(const nLoad: Boolean);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    if nLoad then
    begin
      ListParam.ColWidths[0] := nIni.ReadInteger(Name, 'ListCol0', 100);
    end else
    begin
      nIni.WriteInteger(Name, 'ListCol0', ListParam.ColWidths[0]);
    end;
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 添加列表项
procedure TfFrameParam.NewParamItem(const nKey, nFlag: string;
  nImage: Integer);
var nPic: PZnVLPicture;
begin
  nPic := ListParam.AddPicture(nKey, '', nFlag);
  if nImage < 0 then
    nImage := FDM.BaseIconRandomIndex;
  //xxxxx

  nPic.FKey.FLoop := 1;
  nPic.FKey.FIcon := TBitmap.Create;
  FDM.ImageBase.GetBitmap(nImage, nPic.FKey.FIcon);

  nPic.FValue.FLoop := 1;
  nPic.FValue.FIcon := TBitmap.Create;
end;

//Desc: 更新列表项数据
procedure TfFrameParam.UpdateItem(const nFlag,nValue: string;
  nImage: Integer);
var nData: PZnVLData;
    nPic: PZnVLPicture;
begin
  nData := ListParam.FindData(nFlag);
  nPic := nData.FData;

  if nImage < 0 then
    nImage := FDM.BaseIconRandomIndex;
  //xxxx

  if (nPic.FValue.FText <> nValue) or (nPic.FValue.FFlag <> nImage) then
  begin
    nPic.FValue.FText := nValue;
    if nPic.FValue.FFlag <> nImage then
    begin
      nPic.FValue.FFlag := nImage;
      FDM.ImageBase.GetBitmap(nImage, nPic.FValue.FIcon);
    end;
  end;
end;

//Desc: 更新列表
procedure TfFrameParam.UpdateParam;
var nStr: string;
    i,nIdx,nNum: Integer;
    nList: TStrings;
    nPack: PParamItemPack;
    nPerform: PPerformParam;
    {$IFDEF DBPool}nDB: PDBParam;{$ENDIF}
    {$IFDEF SAP}nSAP: PSAPParam;{$ENDIF}

    function ItemFlag(const nInc: Byte): string;
    begin
      Result := nStr + IntToStr(nIdx);
      Inc(nIdx, nInc);
    end;
begin
  nList := TStringList.Create;
  try
    ListParam.ClearAll;
    ListParam.TitleCaptions.Clear;

    nNum := 1;
    gParamManager.LoadParam(nList, ptPack);

    for i:=0 to nList.Count - 1 do
    begin
      nPack := gParamManager.GetParamPack(nList[i]);
      if not nPack.FEnable then Continue;

      nIdx := 1;
      nStr := Format('pack_%d_', [nNum]);
      
      ListParam.AddData('参数组:' + IntToStr(nNum), '', nil, nStr, vtGroup);
      Inc(nNum);

      NewParamItem('ID', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPack.FID);

      NewParamItem('Name', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPack.FName);

      NewParamItem('DB', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPack.FNameDB);

      NewParamItem('SAP', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPack.FNameSAP);

      NewParamItem('Perform', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPack.FNamePerform);
    end; //pack

    //--------------------------------------------------------------------------
    {$IFDEF DBPool}
    nNum := 1;
    gParamManager.LoadParam(nList, ptDB);

    for i:=0 to nList.Count - 1 do
    begin
      nDB := gParamManager.GetDB(nList[i]);
      if not nDB.FEnable then Continue;

      nIdx := 1;
      nStr := Format('db_%d_', [nNum]);
      
      ListParam.AddData('数据库:' + IntToStr(nNum), '', nil, nStr, vtGroup);
      Inc(nNum);

      NewParamItem('ID', ItemFlag(0));
      UpdateItem(ItemFlag(1), nDB.FID);

      NewParamItem('Name', ItemFlag(0));
      UpdateItem(ItemFlag(1), nDB.FName);

      NewParamItem('Host', ItemFlag(0));
      UpdateItem(ItemFlag(1), nDB.FHost);

      NewParamItem('Port', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nDB.FPort));

      NewParamItem('User', ItemFlag(0));
      UpdateItem(ItemFlag(1), nDB.FUser);

      NewParamItem('Password', ItemFlag(0));
      UpdateItem(ItemFlag(1), StringOfChar('*', Length(nDB.FPwd)));

      NewParamItem('Worker', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nDB.FNumWorker) + '个');

      NewParamItem('ConnStr', ItemFlag(0));
      UpdateItem(ItemFlag(1), nDB.FConn);
    end; //db
    {$ENDIF}
    
    //--------------------------------------------------------------------------
    nNum := 1;
    gParamManager.LoadParam(nList, ptPerform);

    for i:=0 to nList.Count - 1 do
    begin
      nPerform := gParamManager.GetPerform(nList[i]);
      if not nPerform.FEnable then Continue;

      nIdx := 1;
      nStr := Format('perform_%d_', [nNum]);
      
      ListParam.AddData('性能配置:' + IntToStr(nNum), '', nil, nStr, vtGroup);
      Inc(nNum);

      NewParamItem('ID', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPerform.FID);

      NewParamItem('Name', ItemFlag(0));
      UpdateItem(ItemFlag(1), nPerform.FName);

      NewParamItem('PortTCP', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPortTCP));

      NewParamItem('PortHttp', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPortHttp));

      NewParamItem('PoolConn', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPoolSizeConn));

      NewParamItem('PoolBus', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPoolSizeBusiness));

      NewParamItem('PoolSAP', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPoolSizeSAP));

      NewParamItem('BehaviorConn', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPoolBehaviorConn));

      NewParamItem('BehaviorBus', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FPoolBehaviorBusiness));

      NewParamItem('MaxRecord', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FMaxRecordCount));

      NewParamItem('MonInterval', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nPerform.FMonInterval));
    end; //perform

    //--------------------------------------------------------------------------
    {$IFDEF SAP}
    nNum := 1;
    gParamManager.LoadParam(nList, ptSAP);

    for i:=0 to nList.Count - 1 do
    begin
      nSAP := gParamManager.GetSAP(nList[i]);
      if not nSAP.FEnable then Continue;

      nIdx := 1;
      nStr := Format('sap_%d_', [nNum]);
      
      ListParam.AddData('SAP:' + IntToStr(nNum), '', nil, nStr, vtGroup);
      Inc(nNum);

      NewParamItem('ID', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FID);

      NewParamItem('Name', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FName);

      NewParamItem('Host', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FHost);

      NewParamItem('User', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FUser);

      NewParamItem('Password', ItemFlag(0));
      UpdateItem(ItemFlag(1), StringOfChar('*', Length(nSAP.FPwd)));

      NewParamItem('System', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FSystem);

      NewParamItem('SysNum', ItemFlag(0));
      UpdateItem(ItemFlag(1), IntToStr(nSAP.FSysNum));

      NewParamItem('Client', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FClient);

      NewParamItem('Lang', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FLang);

      NewParamItem('CodePage', ItemFlag(0));
      UpdateItem(ItemFlag(1), nSAP.FCodePage);
    end; //sap
    {$ENDIF}

    //--------------------------------------------------------------------------
    nIdx := 1;
    nStr := 'url_0_';
    ListParam.AddData('服务URL', '', nil, nStr, vtGroup);

    nNum := 1;
    for i:=0 to gParamManager.URLLocal.Count - 1 do
    begin
      NewParamItem('本地URL ' + IntToStr(nNum), ItemFlag(0));
      UpdateItem(ItemFlag(1), gParamManager.URLLocal[i]);
      Inc(nNum);
    end;
    
    nNum := 1;
    for i:=0 to gParamManager.URLRemote.Count - 1 do
    begin
      NewParamItem('远程URL ' + IntToStr(nNum), ItemFlag(0));
      UpdateItem(ItemFlag(1), gParamManager.URLRemote[i]);
      Inc(nNum);
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 编辑内容
procedure TfFrameParam.ListParamDblClick(Sender: TObject);
var nStr: string;
    nPos: Integer;
    nData: PZnVLData;
    nParam: TFormCommandParam;
    nResult: TFormCreateResult;
begin
  nData := ListParam.GetSelectData();
  if not Assigned(nData) then Exit;

  nStr := nData.FFlag;
  nPos := StrPosR('_', nStr);
  System.Delete(nStr, nPos + 1, Length(nStr) - nPos);

  nData := ListParam.FindData(nStr + '1');
  if not Assigned(nData) then Exit;
  nStr := PZnVLPicture(nData.FData).FValue.FText;

  nParam.FCommand := cCmd_ViewData;
  nParam.FParamA := nStr;
  //param
  
  if Pos('pack', nData.FFlag) = 1 then
    nResult := CreateBaseFormItem(cFI_FormPack, '', @nParam) else
  //pack

  if Pos('db', nData.FFlag)  = 1 then
    nResult := CreateBaseFormItem(cFI_FormDB, '', @nParam)else
  //db

  if Pos('sap', nData.FFlag)  = 1 then
    nResult := CreateBaseFormItem(cFI_FormSAP, '', @nParam) else
  //sap
  
  if Pos('perform', nData.FFlag)  = 1 then
       nResult := CreateBaseFormItem(cFI_FormPerform, '', @nParam)
  else nResult.FModalResult := mrNone;

  if nResult.FModalResult = mrOk  then
    UpdateParam;
  //refresh list
end;

//Desc: 快捷菜单
procedure TfFrameParam.N1Click(Sender: TObject);
var nForm: Integer;
begin
  if not gSysParam.FIsAdmin then
  begin
    ShowMsg('请以管理员身份登录', sHint);
    Exit;
  end;

  case TComponent(Sender).Tag of
   10: nForm := cFI_FormPack;
   20: nForm := cFI_FormDB;
   30: nForm := cFI_FormSAP;
   40: nForm := cFI_FormPerform;
   50: nForm := cFI_FormServiceURL else Exit;
  end;

  if CreateBaseFormItem(nForm).FModalResult = mrOk then
    UpdateParam;
  //refresh list
end;

initialization
  gControlManager.RegCtrl(TfFrameParam, TfFrameParam.FrameID);
end.
