{*******************************************************************************
  作者: dmzn@163.com 2013-11-19
  描述: 数据共享模块
*******************************************************************************}
unit UDataModule;

{$I Link.Inc}
interface

uses
  SysUtils, Classes, ImgList, Controls, cxGraphics;

const
  cIcon_Run      = 0;
  cIcon_Stop     = 1;
  cIcon_Value    = 2;
  cIcon_Key      = 7;
  cIcon_Star     = 8;
  cIcon_Timer    = 9;
  cIcon_Anchor   = 17; //图标索引

  cIcon_Random: array[0..4] of Integer = (2,3,4,5,6);
  //random icon index

type
  TFDM = class(TDataModule)
    ImageBig: TcxImageList;
    ImageSmall: TcxImageList;
    ImageMid: TcxImageList;
    ImageBar: TcxImageList;
    ImageBase: TcxImageList;
  private
    { Private declarations }
  public
    { Public declarations }
    function BaseIconRandomIndex: Integer;
    function IconIndex(const nName: string): integer;
    procedure LoadSystemIcons(const nIconFile: string);
    {*载入图标*}
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  Variants, UMgrIni, cxImageListEditor;

//------------------------------------------------------------------------------
//Date: 2009-5-27
//Parm: 图标配置文件
//Desc: 载入nIconFile对应的图标列表
procedure TFDM.LoadSystemIcons(const nIconFile: string);
var nStr,nPath: string;
    i,nCount: integer;
    nItem: PIniDataItem;
    nBig,nMid,nSmall: TStrings;
    nEditor: TcxImageListEditor;
begin
  if gIniManager.LoadIni(nIconFile) then
  begin
    ImageBig.Clear;
    ImageMid.Clear;
    ImageSmall.Clear;
  end else Exit;

  nPath := ExtractFilePath(nIconFile);
  nCount := gIniManager.Items.Count - 1;

  nEditor := nil;
  nBig := TStringList.Create;
  nMid := TStringList.Create;
  nSmall := TStringList.Create;
  try
    for i:=0 to nCount do
    begin
      nItem := gIniManager.Items[i];
      nStr := nPath + nItem.FKeyValue;

      if FileExists(nStr) then
       if CompareText(nItem.FSection, 'Large') = 0 then
         nItem.FExtValue := nBig.Add(nStr) else
       if CompareText(nItem.FSection, 'Middle') = 0 then
         nItem.FExtValue := nMid.Add(nStr) else
       if CompareText(nItem.FSection, 'Small') = 0 then
         nItem.FExtValue := nSmall.Add(nStr);
    end;

    if nBig.Count > 0 then
    begin
      {$IFDEF cxLibrary42}
        nEditor := TcxImageListEditor.Create;
      {$ELSE}
        nEditor := TcxImageListEditor.Create(Self);
      {$ENDIF}
      nEditor.ImageList := ImageBig;
      nEditor.AddImages(nBig, amAdd);
      nEditor.ApplyChanges;
      FreeAndNil(nEditor);
    end;

    if nMid.Count > 0 then
    begin
      {$IFDEF cxLibrary42}
        nEditor := TcxImageListEditor.Create;
      {$ELSE}
        nEditor := TcxImageListEditor.Create(Self);
      {$ENDIF}
      nEditor.ImageList := ImageMid;
      nEditor.AddImages(nMid, amAdd);
      nEditor.ApplyChanges;
      FreeAndNil(nEditor);
    end;

    if nSmall.Count > 0 then
    begin
      {$IFDEF cxLibrary42}
        nEditor := TcxImageListEditor.Create;
      {$ELSE}
        nEditor := TcxImageListEditor.Create(Self);
      {$ENDIF}
      nEditor.ImageList := ImageSmall;
      nEditor.AddImages(nSmall, amAdd);
      nEditor.ApplyChanges;
      FreeAndNil(nEditor);
    end;
  finally
    nBig.Free;
    nMid.Free;
    nSmall.Free;
    if Assigned(nEditor) then nEditor.Free;
  end;
end;

//Date: 2009-5-27
//Parm: 图标名称
//Desc: 获取nName图标的索引
function TFDM.IconIndex(const nName: string): integer;
var nItem: PIniDataItem;
begin
  nItem := gIniManager.FindItem(nName);
  if Assigned(nItem) and (not VarIsEmpty(nItem.FExtValue)) then
       Result := nItem.FExtValue
  else Result := -1;
end;

//Desc: 随机图标索引
function TFDM.BaseIconRandomIndex: Integer;
var nIdx: Integer;
begin
  while True do
  begin
    Result := Random(ImageBase.Count);
    for nIdx:=Low(cIcon_Random) to High(cIcon_Random) do
     if Result = cIcon_Random[nIdx] then Exit;
  end;
end;

end.
