unit SAPLogonCtrl_TLB;

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
// File generated on 2012-3-12 16:27:22 from Type Library described below.

// ************************************************************************  //
// Type Lib: c:\program files\sap\frontend\sapgui\wdtlogu.ocx (1)
// LIBID: {D7206A1D-3F10-412A-9F8B-A99536EE68E7}
// LCID: 0
// Helpfile: 
// HelpString: SAP Logon Unicode Control
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: Symbol 'System' renamed to 'System_'
//   Hint: Symbol 'System' renamed to 'System_'
//   Error creating palette bitmap of (TSAPLogonControl) : Error reading control bitmap
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
  SAPLogonCtrlMajorVersion = 1;
  SAPLogonCtrlMinorVersion = 1;

  LIBID_SAPLogonCtrl: TGUID = '{D7206A1D-3F10-412A-9F8B-A99536EE68E7}';

  DIID__CSAPLogonControl: TGUID = '{B24944D7-1501-11CF-8981-0000E8A49FA0}';
  DIID__CSAPLogonControlEvents: TGUID = '{B24944D8-1501-11CF-8981-0000E8A49FA0}';
  CLASS_SAPLogonControl: TGUID = '{0AAF5A11-8C04-4385-A925-0B62F6632BEC}';
  DIID__CSAPLogonConnection: TGUID = '{E2D74A49-184A-11CF-8984-0000E8A49FA0}';
  CLASS_Connection: TGUID = '{E2D74A4A-184A-11CF-8984-0000E8A49FA0}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum CRfcConnectionStatus
type
  CRfcConnectionStatus = TOleEnum;
const
  tloRfcNotConnected = $00000000;
  tloRfcConnected = $00000001;
  tloRfcConnectCancel = $00000002;
  tloRfcConnectParameterMissing = $00000004;
  tloRfcConnectFailed = $00000008;

// Constants for enum CSAPLogonControlEvents
type
  CSAPLogonControlEvents = TOleEnum;
const
  tloDisableAllLogonEvents = $00000000;
  tloEnableOnClick = $00000001;
  tloEnableOnLogoff = $00000002;
  tloEnableOnError = $00000004;
  tloEnableOnCancel = $00000008;
  tloEnableOnLogon = $00000010;
  tloEnableAllLogonEvents = $00007FFF;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _CSAPLogonControl = dispinterface;
  _CSAPLogonControlEvents = dispinterface;
  _CSAPLogonConnection = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SAPLogonControl = _CSAPLogonControl;
  Connection = _CSAPLogonConnection;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PWideString1 = ^WideString; {*}
  PWordBool1 = ^WordBool; {*}


// *********************************************************************//
// DispIntf:  _CSAPLogonControl
// Flags:     (4112) Hidden Dispatchable
// GUID:      {B24944D7-1501-11CF-8981-0000E8A49FA0}
// *********************************************************************//
  _CSAPLogonControl = dispinterface
    ['{B24944D7-1501-11CF-8981-0000E8A49FA0}']
    procedure AboutBox; dispid -552;
    function NewConnection: IDispatch; dispid 14;
    procedure Enable3D; dispid 13;
    property BackColor: OLE_COLOR dispid -501;
    property Default: WordBool dispid 1;
    property Caption: WideString dispid -518;
    property Font: IFontDisp dispid -512;
    property Enabled: WordBool dispid -514;
    property ApplicationName: WideString dispid 2;
    property _Caption: WideString dispid 0;
    property User: WideString dispid 3;
    property System_: WideString dispid 4;
    property SystemNumber: Integer dispid 5;
    property Language: WideString dispid 8;
    property DefaultConnection: IDispatch dispid 15;
    property Client: WideString dispid 7;
    property Password: WideString dispid 9;
    property TraceLevel: Integer dispid 10;
    property GroupName: WideString dispid 6;
    property hWnd: OLE_HANDLE dispid -515;
    property ApplicationServer: WideString dispid 12;
    property Events: Integer dispid 16;
    property MessageServer: WideString dispid 11;
  end;

// *********************************************************************//
// DispIntf:  _CSAPLogonControlEvents
// Flags:     (4096) Dispatchable
// GUID:      {B24944D8-1501-11CF-8981-0000E8A49FA0}
// *********************************************************************//
  _CSAPLogonControlEvents = dispinterface
    ['{B24944D8-1501-11CF-8981-0000E8A49FA0}']
    procedure Click; dispid -600;
    procedure Error(Number: Smallint; var Description: WideString; Scode: Integer; 
                    const Source: WideString; const HelpFile: WideString; HelpContext: Integer; 
                    var CancelDisplay: WordBool); dispid -608;
    procedure Logon(const Connection: IDispatch); dispid 1;
    procedure Cancel(const Connection: IDispatch); dispid 2;
    procedure Logoff(const Connection: IDispatch); dispid 3;
  end;

// *********************************************************************//
// DispIntf:  _CSAPLogonConnection
// Flags:     (4096) Dispatchable
// GUID:      {E2D74A49-184A-11CF-8984-0000E8A49FA0}
// *********************************************************************//
  _CSAPLogonConnection = dispinterface
    ['{E2D74A49-184A-11CF-8984-0000E8A49FA0}']
    procedure Copy(bServer: WordBool); dispid 34;
    procedure SystemMessages; dispid 33;
    function Logon(hWnd: OleVariant; bSilent: WordBool): WordBool; dispid 22;
    procedure Logoff; dispid 21;
    function Reconnect: WordBool; dispid 20;
    procedure SystemInformation(hWnd: OleVariant); dispid 19;
    procedure LastError; dispid 18;
    property User: WideString dispid 5;
    property GroupName: WideString dispid 3;
    property GroupSelection: WordBool dispid 17;
    property Language: WideString dispid 4;
    property Parent: IDispatch dispid 9;
    property MessageServer: WideString dispid 10;
    property Client: WideString dispid 1;
    property System_: WideString dispid 2;
    property RfcWithDialog: Integer dispid 16;
    property ApplicationServer: WideString dispid 13;
    property SystemNumber: Integer dispid 11;
    property IsConnected: CRfcConnectionStatus dispid 14;
    property Password: WideString dispid 15;
    property ABAPDebug: WordBool dispid 25;
    property UseSAPRFCIni: WordBool dispid 23;
    property SAPRelease: WideString dispid 12;
    property UseSAPLogonIni: WordBool dispid 24;
    property HostName: WideString dispid 29;
    property Destination: WideString dispid 28;
    property SNCName: WideString dispid 39;
    property AutoLogon: Integer dispid 35;
    property GatewayService: WideString dispid 31;
    property GatewayHost: WideString dispid 30;
    property SystemID: WideString dispid 27;
    property UseDefaultSystem: WordBool dispid 32;
    property SNCQuality: WideString dispid 40;
    property ConnectionHandle: Integer dispid 7;
    property GRTData: WideString dispid 26;
    property SAPRouter: WideString dispid 8;
    property TraceLevel: Integer dispid 6;
    property CodePage: WideString dispid 36;
    property Ticket: WideString dispid 41;
    property SNC: WordBool dispid 38;
    property LowSpeedConnection: WordBool dispid 37;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TSAPLogonControl
// Help String      : SAP Logon Control Unicode
// Default Interface: _CSAPLogonControl
// Def. Intf. DISP? : Yes
// Event   Interface: _CSAPLogonControlEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TSAPLogonControlError = procedure(ASender: TObject; Number: Smallint; 
                                                      var Description: WideString; Scode: Integer; 
                                                      const Source: WideString; 
                                                      const HelpFile: WideString; 
                                                      HelpContext: Integer; 
                                                      var CancelDisplay: WordBool) of object;
  TSAPLogonControlLogon = procedure(ASender: TObject; const Connection: IDispatch) of object;
  TSAPLogonControlCancel = procedure(ASender: TObject; const Connection: IDispatch) of object;
  TSAPLogonControlLogoff = procedure(ASender: TObject; const Connection: IDispatch) of object;

  TSAPLogonControl = class(TOleControl)
  private
    FOnError: TSAPLogonControlError;
    FOnLogon: TSAPLogonControlLogon;
    FOnCancel: TSAPLogonControlCancel;
    FOnLogoff: TSAPLogonControlLogoff;
    FIntf: _CSAPLogonControl;
    function  GetControlInterface: _CSAPLogonControl;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_DefaultConnection: IDispatch;
    procedure Set_DefaultConnection(const Value: IDispatch);
  public
    procedure AboutBox;
    function NewConnection: IDispatch;
    procedure Enable3D;
    property  ControlInterface: _CSAPLogonControl read GetControlInterface;
    property  DefaultInterface: _CSAPLogonControl read GetControlInterface;
    property DefaultConnection: IDispatch index 15 read GetIDispatchProp write SetIDispatchProp;
  published
    property Anchors;
    property  ParentColor;
    property  ParentFont;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property  OnClick;
    property BackColor: TColor index -501 read GetTColorProp write SetTColorProp stored False;
    property Default: WordBool index 1 read GetWordBoolProp write SetWordBoolProp stored False;
    property Caption: WideString index -518 read GetWideStringProp write SetWideStringProp stored False;
    property Font: TFont index -512 read GetTFontProp write SetTFontProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property ApplicationName: WideString index 2 read GetWideStringProp write SetWideStringProp stored False;
    property _Caption: WideString index 0 read GetWideStringProp write SetWideStringProp stored False;
    property User: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property System_: WideString index 4 read GetWideStringProp write SetWideStringProp stored False;
    property SystemNumber: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property Language: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property Client: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property Password: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property TraceLevel: Integer index 10 read GetIntegerProp write SetIntegerProp stored False;
    property GroupName: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property hWnd: Integer index -515 read GetIntegerProp write SetIntegerProp stored False;
    property ApplicationServer: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property Events: Integer index 16 read GetIntegerProp write SetIntegerProp stored False;
    property MessageServer: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property OnError: TSAPLogonControlError read FOnError write FOnError;
    property OnLogon: TSAPLogonControlLogon read FOnLogon write FOnLogon;
    property OnCancel: TSAPLogonControlCancel read FOnCancel write FOnCancel;
    property OnLogoff: TSAPLogonControlLogoff read FOnLogoff write FOnLogoff;
  end;

// *********************************************************************//
// The Class CoConnection provides a Create and CreateRemote method to          
// create instances of the default interface _CSAPLogonConnection exposed by              
// the CoClass Connection. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoConnection = class
    class function Create: _CSAPLogonConnection;
    class function CreateRemote(const MachineName: string): _CSAPLogonConnection;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TSAPLogonControl.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $FFFFFDA0, $00000001, $00000002, $00000003);
  CTFontIDs: array [0..0] of DWORD = (
    $FFFFFE00);
  CControlData: TControlData2 = (
    ClassID: '{0AAF5A11-8C04-4385-A925-0B62F6632BEC}';
    EventIID: '{B24944D8-1501-11CF-8981-0000E8A49FA0}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $0000001D;
    Version: 401;
    FontCount: 1;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnError) - Cardinal(Self);
end;

procedure TSAPLogonControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _CSAPLogonControl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TSAPLogonControl.GetControlInterface: _CSAPLogonControl;
begin
  CreateControl;
  Result := FIntf;
end;

function TSAPLogonControl.Get_DefaultConnection: IDispatch;
begin
  Result := DefaultInterface.DefaultConnection;
end;

procedure TSAPLogonControl.Set_DefaultConnection(const Value: IDispatch);
begin
  DefaultInterface.DefaultConnection := Value;
end;

procedure TSAPLogonControl.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

function TSAPLogonControl.NewConnection: IDispatch;
begin
  Result := DefaultInterface.NewConnection;
end;

procedure TSAPLogonControl.Enable3D;
begin
  DefaultInterface.Enable3D;
end;

class function CoConnection.Create: _CSAPLogonConnection;
begin
  Result := CreateComObject(CLASS_Connection) as _CSAPLogonConnection;
end;

class function CoConnection.CreateRemote(const MachineName: string): _CSAPLogonConnection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Connection) as _CSAPLogonConnection;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TSAPLogonControl]);
end;

end.
