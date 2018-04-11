{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}
interface

uses
  UClientWorker, UMITPacker, UFormBase,
  //base type
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormPassword, UFormTodo, UFormTodoSend, UFrameTodo, UFormAuthorize,
  UFrameAuthorize, UFormOptions, UFormBaseInfo, UFrameTrucks, UFormTruck,
  UFormRFIDCard, UFormReadCard, UFormMemo,
  //base info
  UFrameCustomer, UFormCustomer, UFormGetCustom,
  UFrameBill, UFormBill, UFormGetZhiKa, UFormGetTruck,
  UFormCard, UFrameBillCard, UFormTruckIn, UFrameTruckQuery,UFrameQueryDiapatch,
  UFramePoundAuto, UFramePoundManual, UFramePoundQuery, UFrameZTDispatch,
  UFormLadingDai, UFormLadingSan, UFormTruckOut,
  UFrameQuerySaleDetail, UFrameQuerySaleTotal,
  UFramePMaterails, UFormPMaterails,
  UFramePProvider, UFormPProvider,
  UFrameQueryOrderDetail,UFormModifyStock,
  UFormPoundKw, UFormTruckEmpty, UFormPoundKwOther, UFormSaleKw, UFormGetWTTruck,
  UFormSaleOrderOther, UFrameSaleOrderOther, UFormModifySaleStock, UFormSaleKwOther,
  UFormGetWechartAccount,UFramePoundQueryOther, uFormSaleBuDanOther,
  UFrameHYData, UFormHYData, UFrameBatcodeJ, UFormBatcodeJ, UFormGetStockNo,
  UFrameHYRecord, UFormHYRecord, UFrameHYStock, UFormHYStock,
  UFrameBatcodeRecord,
  //for huayan
  UFrameOrderCard,UFramePurchaseOrder,UFrameOrderDetail,UFrameOtherCard,
  UFormCardOther,UFormPurchaseOrder,UFormGetPOrderBase,UFormPurchasing;
  //for sale


procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  UMgrChannel, UChannelChooser, UDataModule, USysDB, USysMAC, SysUtils,
  USysLoger, USysConst, UMemDataPool, UMgrLEDDisp, UMgrRemotePrint;

//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger

  if not Assigned(gMemDataManager) then
    gMemDataManager := TMemDataManager.Create;
  //mem pool

  gChannelManager := TChannelManager.Create;
  gChannelManager.ChannelMax := 20;
  gChannelChoolser := TChannelChoolser.Create('');
  gChannelChoolser.AutoUpdateLocal := False;
  //channel
end;

//Desc: 运行系统对象
procedure RunSystemObject;
var nStr: string;
begin
  with gSysParam do
  begin
    FLocalMAC   := MakeActionID_MAC;
    GetLocalIPConfig(FLocalName, FLocalIP);
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);

  with FDM.QueryTemp(nStr),gSysParam do
  if RecordCount > 0 then
  begin
    First;
    while not Eof do
    begin
      nStr := Fields[1].AsString;
      if nStr = sFlag_PrinterBill then
        FPrinterBill := Fields[0].AsString;
      //xxxxx

      if nStr = sFlag_PrinterHYDan then
        FPrinterHYDan := Fields[0].AsString;
      //xxxxx

      if nStr = sFlag_WXServiceMIT then
        FWechatURL := Fields[0].AsString;
      //xxxxx

      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select W_Factory,W_Serial,W_Departmen,W_HardUrl,W_MITUrl From %s ' +
          'Where W_MAC=''%s'' And W_Valid=''%s''';
  nStr := Format(nStr, [sTable_WorkePC, gSysParam.FLocalMAC, sFlag_Yes]);

  with FDM.QueryTemp(nStr),gSysParam do
  if RecordCount > 0 then
  begin
    FFactNum := Fields[0].AsString;
    FSerialID := Fields[1].AsString;

    FDepartment := Fields[2].AsString;
    FHardMonURL := Trim(Fields[3].AsString);
    FMITServURL := Trim(Fields[4].AsString);
  end;

  //----------------------------------------------------------------------------
  with gSysParam do
  begin
    FPoundDaiZ := 0;
    FPoundDaiF := 0;
    FPoundSanF := 0;
    FTruckPWuCha := 0;
    FEmpTruckWc := 100;
    FDaiWCStop := False;
    FDaiPercent := False;
  end;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := Fields[1].AsString;
      if nStr = sFlag_PDaiWuChaZ then
        gSysParam.FPoundDaiZ := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiWuChaF then
        gSysParam.FPoundDaiF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiPercent then
        gSysParam.FDaiPercent := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PDaiWuChaStop then
        gSysParam.FDaiWCStop := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PSanWuChaF then
        gSysParam.FPoundSanF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PTruckPWuCha then
        gSysParam.FTruckPWuCha := Fields[0].AsFloat;

      if nStr = sFlag_PEmpTWuCha then
        gSysParam.FEmpTruckWc := Fields[0].AsFloat;
      Next;
    end;

    with gSysParam do
    begin
      FPoundDaiZ_1 := FPoundDaiZ;
      FPoundDaiF_1 := FPoundDaiF;
      //backup wucha value
    end;
  end;

  //----------------------------------------------------------------------------
  if gSysParam.FMITServURL = '' then  //使用默认URL
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_MITSrvURL]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;
      gSysParam.FMITServURL := Fields[0].AsString;

      while not Eof do
      begin
        gChannelChoolser.AddChannelURL(Fields[0].AsString);
        Next;
      end;

      {$IFNDEF DEBUG}
      //gChannelChoolser.StartRefresh;
      {$ENDIF}//update channel
    end;
  end else
  begin
    gChannelChoolser.AddChannelURL(gSysParam.FMITServURL);
    //电脑专用URL
  end;

  if gSysParam.FHardMonURL = '' then //采用系统默认硬件守护
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_HardSrvURL]);

    with FDM.QueryTemp(nStr) do
     if RecordCount > 0 then
      gSysParam.FHardMonURL := Fields[0].AsString;
    //xxxxx
  end;

  CreateBaseFormItem(cFI_FormTodo);
  //待处理事项

  {$IFNDEF DEBUG}
  if FileExists(gPath + cDisp_Config) then
  begin
    gDisplayManager.LoadConfig(gPath + cDisp_Config);
    gDisplayManager.StartDisplay;
  end;

  if FileExists(gPath + 'Printer.xml') then
  begin
    gRemotePrinter.LoadConfig(gPath + 'Printer.xml');
    gRemotePrinter.StartPrinter;
  end;
  {$ENDIF}
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  FreeAndNil(gSysLoger);
end;

end.
