{*******************************************************************************
  作者: dmzn 2008-8-31
  描述: 支持cxGrid的数据字典
*******************************************************************************}
unit USysDataDict;

interface

uses
  Windows, Classes, Controls, DB, SysUtils, StdCtrls, ULibFun, cxGridTableView,
  cxGridDBTableView, cxCustomData, cxImageComboBox, UMgrDataDict, UDataModule,
  USysConst, USysDB, UFormCtrl;

type
  TSysEntityManager = class(TBaseEntityManager)
  protected
    function QuerySQL(const nSQL: string;
      var nDS: TDataSet; var nAutoFree: Boolean): Boolean; override;
    function ExecSQL(const nSQL: string): integer; override;

    function GetItemValue(const nItem: integer): string; override;
    function IsTableExists(const nTable: string): Boolean; override;
    {*基类方法*}
    procedure BuildFormatStyle(const nColumn: TcxGridColumn; const nItem: PDictItemData);
    {*格式化数据*}
    procedure BuildFooterGroup(const nColumn: TcxGridColumn; const nItem: PDictItemData);
    {*合计分组*}
  public
    function BuildViewColumn(const nView: TcxGridTableView;
     const nEntity: string; const nFilter: string = ''): Boolean;
    {*构建表头*}
  end;

var
  gSysEntityManager: TSysEntityManager = nil;
  //全局使用

implementation

function TSysEntityManager.ExecSQL(const nSQL: string): integer;
begin
  FDM.Command.Close;
  FDM.Command.SQL.Text := nSQL;
  Result := FDM.Command.ExecSQL;
end;

function TSysEntityManager.GetItemValue(const nItem: integer): string;
begin
  case nItem of
    cDictTable_Entity    : Result := sTable_Entity;
    cDictTable_DataDict  : Result := sTable_DictItem;
  end;
end;

function TSysEntityManager.IsTableExists(const nTable: string): Boolean;
var nList: TStrings;
begin
  nList := TStringList.Create;
  try
    FDM.ADOConn.GetTableNames(nList);
    Result := nList.IndexOf(nTable) > -1;
  finally
    nList.Free;
  end;
end;

function TSysEntityManager.QuerySQL(const nSQL: string; var nDS: TDataSet;
  var nAutoFree: Boolean): Boolean;
begin
  FDM.SQLQuery.Close;
  FDM.SQLQuery.SQL.Text := nSQL;
  FDM.SQLQuery.Open;

  nDS := FDM.SQLQuery;
  Result := nDS.RecordCount > 0;
end;

//------------------------------------------------------------------------------
//Desc: 依据nEntity构建nView的表头
function TSysEntityManager.BuildViewColumn(const nView: TcxGridTableView;
  const nEntity,nFilter: string): Boolean;
var nList: TList;
    nSList: TStrings;
    i,nCount: integer;
    nItem : PDictItemData;
    nColumn: TcxGridColumn;
begin
  Result := False;
  nSList := nil;
  //init

  nView.BeginUpdate;
  try
    nView.ClearItems;
    ProgID := gSysParam.FProgID;
    if not LoadEntity(nEntity, False) then Exit;

    nList :=  ActiveEntity.FDictItem;
    if not Assigned(nList) then Exit;

    if nFilter <> '' then
    begin
      nSList := TStringList.Create;
      SplitStr(nFilter, nSList, 0);
    end;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      nItem := nList[i];
      if not nItem.FVisible then Continue;

      if Assigned(nSList) and (nSList.IndexOf(nItem.FDBItem.FField) >= 0) then
        Continue;
      //字段被过滤,不予显示

      nColumn := nView.CreateColumn;
      nColumn.Tag := i;
      nColumn.Caption := nItem.FTitle;
      nColumn.Width := nItem.FWidth;
      nColumn.HeaderAlignmentHorz := nItem.FAlign;

      if nView is TcxGridDBTableView then
        TcxGridDBColumn(nColumn).DataBinding.FieldName := nItem.FDBItem.FField;
      //xxxxx
      
      BuildFormatStyle(nColumn, nItem);
      //格式化数据
      BuildFooterGroup(nColumn, nItem);
      //合计分组
    end;

    Result := True;
  finally
    nSList.Free;
    nView.EndUpdate;
  end;
end;

//Desc: 依据nItem构建nColumn的格式化数据
procedure TSysEntityManager.BuildFormatStyle(const nColumn: TcxGridColumn;
  const nItem: PDictItemData);
var nStr: string;
    nList: TStrings;
    nPrefix,nTemp: string;
    i,nCount,nPos: integer;
    nComboBox: TcxImageComboBoxProperties;
begin
  if (nItem.FFormat.FStyle = fsNone) or (nItem.FFormat.FData = '') then Exit;
  nList := TStringList.Create;
  try
    if nItem.FFormat.FStyle = fsSQL then
    begin
      nStr := nItem.FFormat.FData;
      //KeyField=Select A,B,C From Table

      nPos := Pos('=', nStr);
      if nPos < 1 then Exit;

      nPrefix := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos);

      try
        FDM.SQLTemp.Close;
        FDM.SQLTemp.SQL.Text := nStr;
        FDM.SQLTemp.Open;

        if (FDm.SQLTemp.RecordCount < 1) or
           (not Assigned(FDM.SQLTemp.FindField(nPreFix))) then Exit;
        //invalid data
      except
        Exit; //ignor any error
      end;

      FDM.SQLTemp.First;
      nCount := FDM.SQLTemp.FieldCount - 1;

      while not FDM.SQLTemp.Eof do
      begin
        nStr := nItem.FFormat.FFormat;
        for i:=0 to nCount do
        begin
          nTemp := Trim(FDM.SQLTemp.Fields[i].AsString);
          //field data

          if nItem.FFormat.FFormat <> '' then
          begin
            nStr := MacroValue(nStr, [MI(FDM.SQLTemp.Fields[i].FieldName, nTemp)]);
            Continue;
          end;
          //Ex: FFormat = 'ID Is (FID) and Name is (FName)' 

          if CompareText(FDM.SQLTemp.Fields[i].FieldName, nPrefix) <> 0 then
          begin
            if nStr = '' then
                 nStr := nTemp
            else nStr := nStr + ' | ' + nTemp;
          end;
        end;

        nTemp := Trim(FDM.SQLTemp.FieldByName(nPrefix).AsString);
        nList.Add(nTemp + '=' + nStr);  
        FDM.SQLTemp.Next;
      end;
      FDM.SQLTemp.Close;
    end else

    if nItem.FFormat.FStyle = fsFixed then
    begin
      nList.Text := StringReplace(nItem.FFormat.FData, ';', #13, [rfReplaceAll]);
    end;

    if nList.Count < 1 then Exit;
    nColumn.PropertiesClass := TcxImageComboBoxProperties;
    nComboBox := TcxImageComboBoxProperties(nColumn.Properties);

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      nPos := Pos('=', nList[i]);
      if nPos > 1 then
      with nComboBox.Items.Add do
      begin
        Value := Copy(nList[i], 1, nPos - 1);
        Description := Copy(nList[i], nPos + 1, MaxInt);
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 依据nItem构建nColumn的合计分组信息
procedure TSysEntityManager.BuildFooterGroup(const nColumn: TcxGridColumn;
  const nItem: PDictItemData);
var nFooter: TDictGroupFooter;
    nSummary: TcxDataSummaryItem;

    //Desc: 初始化nSItem的属性
    procedure InitSummaryItem(const nSItem: TcxDataSummaryItem);
    var nDBSummary: TcxGridDBTableSummaryItem;
    begin
      case nItem.FFooter.FKind of
        fkSum     : nSItem.Kind := skSum;
        fkMin     : nSItem.Kind := skMin;
        fkMax     : nSItem.Kind := skMax;
        fkCount   : nSItem.Kind := skCount;
        fkAverage : nSItem.Kind := skAverage;
      end;

      nSItem.Format := nItem.FFooter.FFormat;
      if nSItem is TcxGridDBTableSummaryItem then
      begin
        nDBSummary := nSItem as TcxGridDBTableSummaryItem;
        nDBSummary.Column := nColumn;
        nDBSummary.DisplayText := nItem.FFooter.FDisplay;
      end;
    end; 
begin
  nFooter := nItem.FFooter;
  if (nFooter.FKind = fkNone) or (nFooter.FPosition = fpNone) then Exit;
  
  with nColumn.GridView do
  begin
    OptionsView.Footer := True;
    OptionsView.GroupFooters := gfVisibleWhenExpanded;
    OptionsView.GroupRowStyle := grsOffice11;

    if (nFooter.FPosition = fpFooter) or (nFooter.FPosition = fpAll) then
    begin
      nSummary := DataController.Summary.FooterSummaryItems.Add;
      nSummary.Position := spFooter;
      InitSummaryItem(nSummary);

      nSummary := DataController.Summary.DefaultGroupSummaryItems.Add;
      nSummary.Position := spFooter;
      InitSummaryItem(nSummary);
    end;

    if (nFooter.FPosition = fpGroup) or (nFooter.FPosition = fpAll) then
    begin
      nSummary := DataController.Summary.FooterSummaryItems.Add;
      nSummary.Position := spGroup;
      InitSummaryItem(nSummary);

      nSummary := DataController.Summary.DefaultGroupSummaryItems.Add;
      nSummary.Position := spGroup;
      InitSummaryItem(nSummary);
    end;
  end;
end;

initialization
  gSysEntityManager := TSysEntityManager.Create;
finalization
  FreeAndNil(gSysEntityManager);
end.
