unit SAPFunctionsOCX_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2012-3-12 16:27:37 from Type Library described below.

// ************************************************************************  //
// Type Lib: c:\program files\sap\frontend\sapgui\wdtfuncu.ocx (1)
// LIBID: {273D3599-E8A7-4674-A3B7-430B9E0A78BD}
// LCID: 0
// Helpfile: 
// HelpString: SAP Remote Function Call Unicode Control
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: TypeInfo 'Function' changed to 'Function_'
//   Hint: TypeInfo 'Exports' changed to 'Exports_'
//   Hint: Member 'Function' of 'IStructure' changed to 'Function_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Member 'Exports' of 'IFunction' changed to 'Exports_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Member 'Function' of 'IParameter' changed to 'Function_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SAPFunctionsOCXMajorVersion = 5;
  SAPFunctionsOCXMinorVersion = 0;

  LIBID_SAPFunctionsOCX: TGUID = '{273D3599-E8A7-4674-A3B7-430B9E0A78BD}';

  DIID_IStructure: TGUID = '{695B970A-2F2C-11CF-9AE5-0800096E19F4}';
  DIID_ISAPFunctions: TGUID = '{5B076C01-2F26-11CF-9AE5-0800096E19F4}';
  DIID_SAPFunctionsEvents: TGUID = '{5B076C02-2F26-11CF-9AE5-0800096E19F4}';
  CLASS_SAPFunctions: TGUID = '{0AF427E7-03B9-4673-8F21-F33A683BCE28}';
  DIID_IFunction: TGUID = '{695B9700-2F2C-11CF-9AE5-0800096E19F4}';
  CLASS_Function_: TGUID = '{695B9701-2F2C-11CF-9AE5-0800096E19F4}';
  DIID_IParameter: TGUID = '{695B9702-2F2C-11CF-9AE5-0800096E19F4}';
  CLASS_Parameter: TGUID = '{695B9703-2F2C-11CF-9AE5-0800096E19F4}';
  DIID_IExports: TGUID = '{695B9704-2F2C-11CF-9AE5-0800096E19F4}';
  CLASS_Exports_: TGUID = '{695B9705-2F2C-11CF-9AE5-0800096E19F4}';
  DIID_IImports: TGUID = '{695B9706-2F2C-11CF-9AE5-0800096E19F4}';
  CLASS_Imports: TGUID = '{695B9707-2F2C-11CF-9AE5-0800096E19F4}';
  CLASS_Structure: TGUID = '{695B970B-2F2C-11CF-9AE5-0800096E19F4}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum RFC_RC
type
  RFC_RC = TOleEnum;
const
  RFC_OK = $00000000;
  RFC_FAILURE = $00000001;
  RFC_EXCEPTION = $00000002;
  RFC_SYS_EXCEPTION = $00000003;
  RFC_CALL = $00000004;
  RFC_INTERNAL_COM = $00000005;
  RFC_CLOSED = $00000006;
  RFC_RETRY = $00000007;
  RFC_NO_TID = $00000008;
  RFC_EXECUTED = $00000009;
  RFC_SYNCHRONIZE = $0000000A;
  RFC_MEMORY_INSUFFICIENT = $0000000B;
  RFC_VERSION_MISMATCH = $0000000C;
  RFC_NOT_FOUND = $0000000D;
  RFC_CALL_NOT_SUPPORTED = $0000000E;
  RFC_NOT_OWNER = $0000000F;
  RFC_NOT_INITIALIZED = $00000010;

// Constants for enum CRFCType
type
  CRFCType = TOleEnum;
const
  RfcTypeChar = $00000000;
  RfcTypeDate = $00000001;
  RfcTypeBCD = $00000002;
  RfcTypeTime = $00000003;
  RfcTypeHex = $00000004;
  RfcTypeNum = $00000006;
  RfcTypeFloat = $00000007;
  RfcTypeLong = $00000008;
  RfcTypeShort = $00000009;
  RfcTypeByte = $0000000A;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IStructure = dispinterface;
  ISAPFunctions = dispinterface;
  SAPFunctionsEvents = dispinterface;
  IFunction = dispinterface;
  IParameter = dispinterface;
  IExports = dispinterface;
  IImports = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SAPFunctions = ISAPFunctions;
  Function_ = IFunction;
  Parameter = IParameter;
  Exports_ = IExports;
  Imports = IImports;
  Structure = IStructure;


// *********************************************************************//
// DispIntf:  IStructure
// Flags:     (4112) Hidden Dispatchable
// GUID:      {695B970A-2F2C-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  IStructure = dispinterface
    ['{695B970A-2F2C-11CF-9AE5-0800096E19F4}']
    property Value[index: OleVariant]: OleVariant dispid 9;
    property ColumnSAPType[index: Integer]: CRFCType readonly dispid 13;
    property ColumnLength[index: Integer]: Smallint readonly dispid 12;
    property _Value[index: OleVariant]: OleVariant dispid 0; default;
    procedure Clear; dispid 7;
    property ColumnOffset[index: Integer]: Smallint readonly dispid 11;
    property ColumnName[index: Smallint]: WideString readonly dispid 10;
    function Clone: IDispatch; dispid 6;
    property ColumnDecimals[index: Integer]: Smallint readonly dispid 14;
    function IsStructure: WordBool; dispid 8;
    property Width: Integer dispid 5;
    property Name: WideString dispid 4;
    property ColumnCount: Integer dispid 3;
    property Function_: IDispatch dispid 2;
    property type_: WideString dispid 1;
  end;

// *********************************************************************//
// DispIntf:  ISAPFunctions
// Flags:     (4112) Hidden Dispatchable
// GUID:      {5B076C01-2F26-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  ISAPFunctions = dispinterface
    ['{5B076C01-2F26-11CF-9AE5-0800096E19F4}']
    function CreateStructure(const StructName: WideString): IStructure; dispid 12;
    function CreateTransactionID: WideString; dispid 11;
    function Item(index: OleVariant): IDispatch; dispid 5;
    procedure AboutBox; dispid -552;
    function Add(const functionName: WideString): IDispatch; dispid 8;
    procedure RemoveAll; dispid 7;
    function Remove(index: OleVariant): WordBool; dispid 6;
    property AutoLogon: WordBool dispid 10;
    property RetrieveDescription: WordBool dispid 9;
    property Connection: IDispatch dispid 4;
    property LogFileName: WideString dispid 3;
    property LogLevel: Smallint dispid 2;
    property Count: Integer dispid 1;
  end;

// *********************************************************************//
// DispIntf:  SAPFunctionsEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {5B076C02-2F26-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  SAPFunctionsEvents = dispinterface
    ['{5B076C02-2F26-11CF-9AE5-0800096E19F4}']
  end;

// *********************************************************************//
// DispIntf:  IFunction
// Flags:     (4112) Hidden Dispatchable
// GUID:      {695B9700-2F2C-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  IFunction = dispinterface
    ['{695B9700-2F2C-11CF-9AE5-0800096E19F4}']
    function CallIndirect(const tranID: WideString): WordBool; dispid 11;
    property Imports[index: OleVariant]: IDispatch readonly dispid 10;
    property Exports_[index: OleVariant]: IDispatch readonly dispid 9;
    function Call: WordBool; dispid 6;
    property Description: WideString readonly dispid 5;
    property Exception: WideString readonly dispid 1;
    property _Name: WideString dispid 0;
    property Tables: IDispatch dispid 4;
    property WaitInCall: WordBool dispid 13;
    property ReturnCode: RFC_RC readonly dispid 12;
    property Parent: IDispatch readonly dispid 2;
    property Name: WideString readonly dispid 3;
  end;

// *********************************************************************//
// DispIntf:  IParameter
// Flags:     (4112) Hidden Dispatchable
// GUID:      {695B9702-2F2C-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  IParameter = dispinterface
    ['{695B9702-2F2C-11CF-9AE5-0800096E19F4}']
    property Decimals: Smallint readonly dispid 10;
    procedure Clear; dispid 9;
    function IsStructure: WordBool; dispid 8;
    property Value: OleVariant dispid 3;
    property type_: WideString dispid 1;
    property _Value: OleVariant dispid 0;
    property Name: WideString dispid 4;
    property Description: WideString dispid 7;
    property SAPType: CRFCType dispid 6;
    property Function_: IDispatch dispid 2;
    property Length: Integer dispid 5;
  end;

// *********************************************************************//
// DispIntf:  IExports
// Flags:     (4112) Hidden Dispatchable
// GUID:      {695B9704-2F2C-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  IExports = dispinterface
    ['{695B9704-2F2C-11CF-9AE5-0800096E19F4}']
    procedure RemoveAll; dispid 4;
    function Remove(index: OleVariant): WordBool; dispid 3;
    function Insert(where: OleVariant; what: OleVariant): IDispatch; dispid 8;
    function Unload(index: OleVariant): IDispatch; dispid 6;
    property Item[idx: OleVariant]: IDispatch readonly dispid 7;
    property Parent: IDispatch dispid 2;
    property Count: Integer dispid 1;
  end;

// *********************************************************************//
// DispIntf:  IImports
// Flags:     (4112) Hidden Dispatchable
// GUID:      {695B9706-2F2C-11CF-9AE5-0800096E19F4}
// *********************************************************************//
  IImports = dispinterface
    ['{695B9706-2F2C-11CF-9AE5-0800096E19F4}']
    procedure RemoveAll; dispid 4;
    function Remove(index: OleVariant): WordBool; dispid 3;
    function Insert(where: OleVariant; what: OleVariant): IDispatch; dispid 8;
    function Unload(index: OleVariant): IDispatch; dispid 6;
    property Item[idx: OleVariant]: IDispatch readonly dispid 7;
    property Parent: IDispatch dispid 2;
    property Count: Integer dispid 1;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSAPFunctions
// Help String      : Remote Function Call Unicode
// Default Interface: ISAPFunctions
// Def. Intf. DISP? : Yes
// Event   Interface: SAPFunctionsEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TSAPFunctions = class(TOleControl)
  private
    FIntf: ISAPFunctions;
    function  GetControlInterface: ISAPFunctions;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_Connection: IDispatch;
    procedure Set_Connection(const Value: IDispatch);
  public
    function CreateStructure(const StructName: WideString): IStructure;
    function CreateTransactionID: WideString;
    function Item(index: OleVariant): IDispatch;
    procedure AboutBox;
    function Add(const functionName: WideString): IDispatch;
    procedure RemoveAll;
    function Remove(index: OleVariant): WordBool;
    property  ControlInterface: ISAPFunctions read GetControlInterface;
    property  DefaultInterface: ISAPFunctions read GetControlInterface;
    property Connection: IDispatch index 4 read GetIDispatchProp write SetIDispatchProp;
  published
    property Anchors;
    property AutoLogon: WordBool index 10 read GetWordBoolProp write SetWordBoolProp stored False;
    property RetrieveDescription: WordBool index 9 read GetWordBoolProp write SetWordBoolProp stored False;
    property LogFileName: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property LogLevel: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
    property Count: Integer index 1 read GetIntegerProp write SetIntegerProp stored False;
  end;

// *********************************************************************//
// The Class CoFunction_ provides a Create and CreateRemote method to          
// create instances of the default interface IFunction exposed by              
// the CoClass Function_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFunction_ = class
    class function Create: IFunction;
    class function CreateRemote(const MachineName: string): IFunction;
  end;

// *********************************************************************//
// The Class CoParameter provides a Create and CreateRemote method to          
// create instances of the default interface IParameter exposed by              
// the CoClass Parameter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoParameter = class
    class function Create: IParameter;
    class function CreateRemote(const MachineName: string): IParameter;
  end;

// *********************************************************************//
// The Class CoExports_ provides a Create and CreateRemote method to          
// create instances of the default interface IExports exposed by              
// the CoClass Exports_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoExports_ = class
    class function Create: IExports;
    class function CreateRemote(const MachineName: string): IExports;
  end;

// *********************************************************************//
// The Class CoImports provides a Create and CreateRemote method to          
// create instances of the default interface IImports exposed by              
// the CoClass Imports. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoImports = class
    class function Create: IImports;
    class function CreateRemote(const MachineName: string): IImports;
  end;

// *********************************************************************//
// The Class CoStructure provides a Create and CreateRemote method to          
// create instances of the default interface IStructure exposed by              
// the CoClass Structure. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoStructure = class
    class function Create: IStructure;
    class function CreateRemote(const MachineName: string): IStructure;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TSAPFunctions.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{0AF427E7-03B9-4673-8F21-F33A683BCE28}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TSAPFunctions.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ISAPFunctions;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSAPFunctions.GetControlInterface: ISAPFunctions;
begin
  CreateControl;
  Result := FIntf;
end;

function TSAPFunctions.Get_Connection: IDispatch;
begin
  Result := DefaultInterface.Connection;
end;

procedure TSAPFunctions.Set_Connection(const Value: IDispatch);
begin
  DefaultInterface.Connection := Value;
end;

function TSAPFunctions.CreateStructure(const StructName: WideString): IStructure;
begin
  Result := DefaultInterface.CreateStructure(StructName);
end;

function TSAPFunctions.CreateTransactionID: WideString;
begin
  Result := DefaultInterface.CreateTransactionID;
end;

function TSAPFunctions.Item(index: OleVariant): IDispatch;
begin
  Result := DefaultInterface.Item(index);
end;

procedure TSAPFunctions.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

function TSAPFunctions.Add(const functionName: WideString): IDispatch;
begin
  Result := DefaultInterface.Add(functionName);
end;

procedure TSAPFunctions.RemoveAll;
begin
  DefaultInterface.RemoveAll;
end;

function TSAPFunctions.Remove(index: OleVariant): WordBool;
begin
  Result := DefaultInterface.Remove(index);
end;

class function CoFunction_.Create: IFunction;
begin
  Result := CreateComObject(CLASS_Function_) as IFunction;
end;

class function CoFunction_.CreateRemote(const MachineName: string): IFunction;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Function_) as IFunction;
end;

class function CoParameter.Create: IParameter;
begin
  Result := CreateComObject(CLASS_Parameter) as IParameter;
end;

class function CoParameter.CreateRemote(const MachineName: string): IParameter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Parameter) as IParameter;
end;

class function CoExports_.Create: IExports;
begin
  Result := CreateComObject(CLASS_Exports_) as IExports;
end;

class function CoExports_.CreateRemote(const MachineName: string): IExports;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Exports_) as IExports;
end;

class function CoImports.Create: IImports;
begin
  Result := CreateComObject(CLASS_Imports) as IImports;
end;

class function CoImports.CreateRemote(const MachineName: string): IImports;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Imports) as IImports;
end;

class function CoStructure.Create: IStructure;
begin
  Result := CreateComObject(CLASS_Structure) as IStructure;
end;

class function CoStructure.CreateRemote(const MachineName: string): IStructure;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Structure) as IStructure;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TSAPFunctions]);
end;

end.
