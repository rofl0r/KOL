unit Flash_TLB;

{ converted by TLB2KOL utility }

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

// PASTLWTR : $Revision:   1.88  $
// File generated on 04.09.2003 14:51:13 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: C:\WINDOWS\system32\Macromed\Flash\Flash.ocx (1)
// IID\LCID: {D27CDB6B-AE6D-11CF-96B8-444553540000}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\STDVCL40.DLL)
// Errors:
//   Hint: Parameter 'label' of IShockwaveFlash.TGotoLabel changed to 'label_'
//   Hint: Parameter 'property' of IShockwaveFlash.TSetProperty changed to 'property_'
//   Hint: Parameter 'property' of IShockwaveFlash.TGetProperty changed to 'property_'
//   Hint: Parameter 'label' of IShockwaveFlash.TCallLabel changed to 'label_'
//   Hint: Parameter 'property' of IShockwaveFlash.TSetPropertyNum changed to 'property_'
//   Hint: Parameter 'property' of IShockwaveFlash.TGetPropertyNum changed to 'property_'
//   Hint: Parameter 'property' of IShockwaveFlash.TGetPropertyAsNumber changed to 'property_'
//   Error creating palette bitmap of (TFlashProp) : Server C:\WINDOWS\system32\Macromed\Flash\Flash.ocx contains no icons
//   Error creating palette bitmap of (TFlashObjectInterface) : Server C:\WINDOWS\system32\Macromed\Flash\Flash.ocx contains no icons
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses KOL, ActiveKOL, Windows, ActiveX, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ShockwaveFlashObjectsMajorVersion = 1;
  ShockwaveFlashObjectsMinorVersion = 0;

  LIBID_ShockwaveFlashObjects: TGUID = '{D27CDB6B-AE6D-11CF-96B8-444553540000}';

  IID_IShockwaveFlash: TGUID = '{D27CDB6C-AE6D-11CF-96B8-444553540000}';
  DIID__IShockwaveFlashEvents: TGUID = '{D27CDB6D-AE6D-11CF-96B8-444553540000}';
  CLASS_ShockwaveFlash: TGUID = '{D27CDB6E-AE6D-11CF-96B8-444553540000}';
  CLASS_FlashProp: TGUID = '{1171A62F-05D2-11D1-83FC-00A0C9089C5A}';
  IID_IFlashFactory: TGUID = '{D27CDB70-AE6D-11CF-96B8-444553540000}';
  IID_IDispatchEx: TGUID = '{A6EF9860-C720-11D0-9337-00A0C90DCAA9}';
  IID_IFlashObjectInterface: TGUID = '{D27CDB72-AE6D-11CF-96B8-444553540000}';
  IID_IServiceProvider: TGUID = '{6D5140C1-7436-11CE-8034-00AA006009FA}';
  CLASS_FlashObjectInterface: TGUID = '{D27CDB71-AE6D-11CF-96B8-444553540000}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IShockwaveFlash = interface;
  IShockwaveFlashDisp = dispinterface;
  _IShockwaveFlashEvents = dispinterface;
  IFlashFactory = interface;
  IDispatchEx = interface;
  IFlashObjectInterface = interface;
  IServiceProvider = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ShockwaveFlash = IShockwaveFlash;
  FlashProp = IUnknown;
  FlashObjectInterface = IFlashObjectInterface;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUserType1 = ^TGUID; {*}
  PSYSUINT1 = ^SYSUINT; {*}
  PUserType2 = ^TGUID; {*}


// *********************************************************************//
// Interface: IShockwaveFlash
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D27CDB6C-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlash = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function  Get_ReadyState: Integer; safecall;
    function  Get_TotalFrames: Integer; safecall;
    function  Get_Playing: WordBool; safecall;
    procedure Set_Playing(pVal: WordBool); safecall;
    function  Get_Quality: SYSINT; safecall;
    procedure Set_Quality(pVal: SYSINT); safecall;
    function  Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(pVal: SYSINT); safecall;
    function  Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(pVal: SYSINT); safecall;
    function  Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(pVal: Integer); safecall;
    function  Get_Loop: WordBool; safecall;
    procedure Set_Loop(pVal: WordBool); safecall;
    function  Get_Movie: WideString; safecall;
    procedure Set_Movie(const pVal: WideString); safecall;
    function  Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(pVal: Integer); safecall;
    procedure SetZoomRect(aleft: Integer; atop: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(NFrame: Integer); safecall;
    function  CurrentFrame: Integer; safecall;
    function  IsPlaying: WordBool; safecall;
    function  PercentLoaded: Integer; safecall;
    function  FrameLoaded(NFrame: Integer): WordBool; safecall;
    function  FlashVersion: Integer; safecall;
    function  Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function  Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function  Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function  Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function  Get_Scale: WideString; safecall;
    procedure Set_Scale(const pVal: WideString); safecall;
    function  Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function  Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function  Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function  Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; NFrame: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function  TCurrentFrame(const target: WideString): Integer; safecall;
    function  TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const aname: WideString; const value: WideString); safecall;
    function  GetVariable(const aname: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function  TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; NFrame: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function  TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function  TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; safecall;
    function  Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function  Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const pVal: WideString); safecall;
    function  Get_AllowScriptAccess: WideString; safecall;
    procedure Set_AllowScriptAccess(const pVal: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property Scale: WideString read Get_Scale write Set_Scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
    property FlashVars: WideString read Get_FlashVars write Set_FlashVars;
    property AllowScriptAccess: WideString read Get_AllowScriptAccess write Set_AllowScriptAccess;
  end;

// *********************************************************************//
// DispIntf:  IShockwaveFlashDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D27CDB6C-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlashDisp = dispinterface
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    property ReadyState: Integer readonly dispid -525;
    property TotalFrames: Integer readonly dispid 124;
    property Playing: WordBool dispid 125;
    property Quality: SYSINT dispid 105;
    property ScaleMode: SYSINT dispid 120;
    property AlignMode: SYSINT dispid 121;
    property BackgroundColor: Integer dispid 123;
    property Loop: WordBool dispid 106;
    property Movie: WideString dispid 102;
    property FrameNum: Integer dispid 107;
    procedure SetZoomRect(aleft: Integer; atop: Integer; right: Integer; bottom: Integer); dispid 109;
    procedure Zoom(factor: SYSINT); dispid 118;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); dispid 119;
    procedure Play; dispid 112;
    procedure Stop; dispid 113;
    procedure Back; dispid 114;
    procedure Forward; dispid 115;
    procedure Rewind; dispid 116;
    procedure StopPlay; dispid 126;
    procedure GotoFrame(NFrame: Integer); dispid 127;
    function  CurrentFrame: Integer; dispid 128;
    function  IsPlaying: WordBool; dispid 129;
    function  PercentLoaded: Integer; dispid 130;
    function  FrameLoaded(NFrame: Integer): WordBool; dispid 131;
    function  FlashVersion: Integer; dispid 132;
    property WMode: WideString dispid 133;
    property SAlign: WideString dispid 134;
    property Menu: WordBool dispid 135;
    property Base: WideString dispid 136;
    property Scale: WideString dispid 137;
    property DeviceFont: WordBool dispid 138;
    property EmbedMovie: WordBool dispid 139;
    property BGColor: WideString dispid 140;
    property Quality2: WideString dispid 141;
    procedure LoadMovie(layer: SYSINT; const url: WideString); dispid 142;
    procedure TGotoFrame(const target: WideString; NFrame: Integer); dispid 143;
    procedure TGotoLabel(const target: WideString; const label_: WideString); dispid 144;
    function  TCurrentFrame(const target: WideString): Integer; dispid 145;
    function  TCurrentLabel(const target: WideString): WideString; dispid 146;
    procedure TPlay(const target: WideString); dispid 147;
    procedure TStopPlay(const target: WideString); dispid 148;
    procedure SetVariable(const aname: WideString; const value: WideString); dispid 151;
    function  GetVariable(const aname: WideString): WideString; dispid 152;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); dispid 153;
    function  TGetProperty(const target: WideString; property_: SYSINT): WideString; dispid 154;
    procedure TCallFrame(const target: WideString; NFrame: SYSINT); dispid 155;
    procedure TCallLabel(const target: WideString; const label_: WideString); dispid 156;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); dispid 157;
    function  TGetPropertyNum(const target: WideString; property_: SYSINT): Double; dispid 158;
    function  TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; dispid 172;
    property SWRemote: WideString dispid 159;
    property FlashVars: WideString dispid 170;
    property AllowScriptAccess: WideString dispid 171;
  end;

// *********************************************************************//
// DispIntf:  _IShockwaveFlashEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {D27CDB6D-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  _IShockwaveFlashEvents = dispinterface
    ['{D27CDB6D-AE6D-11CF-96B8-444553540000}']
    procedure OnReadyStateChange(newState: Integer); dispid -609;
    procedure OnProgress(percentDone: Integer); dispid 1958;
    procedure FSCommand(const command: WideString; const args: WideString); dispid 150;
  end;

// *********************************************************************//
// Interface: IFlashFactory
// Flags:     (0)
// GUID:      {D27CDB70-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IFlashFactory = interface(IUnknown)
    ['{D27CDB70-AE6D-11CF-96B8-444553540000}']
  end;

// *********************************************************************//
// Interface: IDispatchEx
// Flags:     (4096) Dispatchable
// GUID:      {A6EF9860-C720-11D0-9337-00A0C90DCAA9}
// *********************************************************************//
  IDispatchEx = interface(IDispatch)
    ['{A6EF9860-C720-11D0-9337-00A0C90DCAA9}']
    function  GetDispID(const bstrName: WideString; grfdex: LongWord; out pid: Integer): HResult; stdcall;
    function  RemoteInvokeEx(id: Integer; lcid: LongWord; dwFlags: LongWord; var pdp: TGUID; 
                             out pvarRes: OleVariant; out pei: TGUID; 
                             const pspCaller: IServiceProvider; cvarRefArg: SYSUINT; 
                             var rgiRefArg: SYSUINT; var rgvarRefArg: OleVariant): HResult; stdcall;
    function  DeleteMemberByName(const bstrName: WideString; grfdex: LongWord): HResult; stdcall;
    function  DeleteMemberByDispID(id: Integer): HResult; stdcall;
    function  GetMemberProperties(id: Integer; grfdexFetch: LongWord; out pgrfdex: LongWord): HResult; stdcall;
    function  GetMemberName(id: Integer; out pbstrName: WideString): HResult; stdcall;
    function  GetNextDispID(grfdex: LongWord; id: Integer; out pid: Integer): HResult; stdcall;
    function  GetNameSpaceParent(out ppunk: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFlashObjectInterface
// Flags:     (4096) Dispatchable
// GUID:      {D27CDB72-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IFlashObjectInterface = interface(IDispatchEx)
    ['{D27CDB72-AE6D-11CF-96B8-444553540000}']
  end;

// *********************************************************************//
// Interface: IServiceProvider
// Flags:     (0)
// GUID:      {6D5140C1-7436-11CE-8034-00AA006009FA}
// *********************************************************************//
  IServiceProvider = interface(IUnknown)
    ['{6D5140C1-7436-11CE-8034-00AA006009FA}']
    function  RemoteQueryService(var guidService: TGUID; var riid: TGUID; out ppvObject: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TShockwaveFlash
// Help String      : Shockwave Flash
// Default Interface: IShockwaveFlash
// Def. Intf. DISP? : No
// Event   Interface: _IShockwaveFlashEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TShockwaveFlashOnReadyStateChange = procedure(Sender: TObject; newState: Integer) of object;
  TShockwaveFlashOnProgress = procedure(Sender: TObject; percentDone: Integer) of object;
  TShockwaveFlashFSCommand = procedure(Sender: TObject; const command: WideString; const args: WideString) of object;

  PShockwaveFlash = ^TShockwaveFlash;
  TShockwaveFlash = object(TOleCtl)
  private
    FOnReadyStateChange: TShockwaveFlashOnReadyStateChange;
    FOnSFProgress: TShockwaveFlashOnProgress;
    FOnFSCommand: TShockwaveFlashFSCommand;
    FIntf: IShockwaveFlash;
    function  GetControlInterface: IShockwaveFlash;
  protected
    procedure CreateControl;
    procedure InitControlData; virtual;
  public
    procedure SetZoomRect(aleft: Integer; atop: Integer; right: Integer; bottom: Integer);
    procedure Zoom(factor: SYSINT);
    procedure Pan(x: Integer; y: Integer; mode: SYSINT);
    procedure Play;
    procedure Stop;
    procedure Back;
    procedure Forward;
    procedure Rewind;
    procedure StopPlay;
    procedure GotoFrame(NFrame: Integer);
    function  CurrentFrame: Integer;
    function  IsPlaying: WordBool;
    function  PercentLoaded: Integer;
    function  FrameLoaded(NFrame: Integer): WordBool;
    function  FlashVersion: Integer;
    procedure LoadMovie(layer: SYSINT; const url: WideString);
    procedure TGotoFrame(const target: WideString; NFrame: Integer);
    procedure TGotoLabel(const target: WideString; const label_: WideString);
    function  TCurrentFrame(const target: WideString): Integer;
    function  TCurrentLabel(const target: WideString): WideString;
    procedure TPlay(const target: WideString);
    procedure TStopPlay(const target: WideString);
    procedure SetVariable(const aname: WideString; const value: WideString);
    function  GetVariable(const aname: WideString): WideString;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString);
    function  TGetProperty(const target: WideString; property_: SYSINT): WideString;
    procedure TCallFrame(const target: WideString; NFrame: SYSINT);
    procedure TCallLabel(const target: WideString; const label_: WideString);
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double);
    function  TGetPropertyNum(const target: WideString; property_: SYSINT): Double;
    function  TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double;
    property  ControlInterface: IShockwaveFlash read GetControlInterface;
    property  DefaultInterface: IShockwaveFlash read GetControlInterface;
    property ReadyState: Integer index -525 read GetIntegerProp;
    property TotalFrames: Integer index 124 read GetIntegerProp;
  //  published
    property TabStop;
    property Align;
    property DragCursor;
    property DragMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;
    property Playing: WordBool index 125 read GetWordBoolProp write SetWordBoolProp stored False;
    property Quality: Integer index 105 read GetIntegerProp write SetIntegerProp stored False;
    property ScaleMode: Integer index 120 read GetIntegerProp write SetIntegerProp stored False;
    property AlignMode: Integer index 121 read GetIntegerProp write SetIntegerProp stored False;
    property BackgroundColor: Integer index 123 read GetIntegerProp write SetIntegerProp stored False;
    property Loop: WordBool index 106 read GetWordBoolProp write SetWordBoolProp stored False;
    property Movie: WideString index 102 read GetWideStringProp write SetWideStringProp stored False;
    property FrameNum: Integer index 107 read GetIntegerProp write SetIntegerProp stored False;
    property WMode: WideString index 133 read GetWideStringProp write SetWideStringProp stored False;
    property SAlign: WideString index 134 read GetWideStringProp write SetWideStringProp stored False;
    property Menu: WordBool index 135 read GetWordBoolProp write SetWordBoolProp stored False;
    property Base: WideString index 136 read GetWideStringProp write SetWideStringProp stored False;
    property Scale: WideString index 137 read GetWideStringProp write SetWideStringProp stored False;
    property DeviceFont: WordBool index 138 read GetWordBoolProp write SetWordBoolProp stored False;
    property EmbedMovie: WordBool index 139 read GetWordBoolProp write SetWordBoolProp stored False;
    property BGColor: WideString index 140 read GetWideStringProp write SetWideStringProp stored False;
    property Quality2: WideString index 141 read GetWideStringProp write SetWideStringProp stored False;
    property SWRemote: WideString index 159 read GetWideStringProp write SetWideStringProp stored False;
    property FlashVars: WideString index 170 read GetWideStringProp write SetWideStringProp stored False;
    property AllowScriptAccess: WideString index 171 read GetWideStringProp write SetWideStringProp stored False;
    property OnReadyStateChange: TShockwaveFlashOnReadyStateChange read FOnReadyStateChange write FOnReadyStateChange;
    property OnProgress: TShockwaveFlashOnProgress read FOnSFProgress write FOnSFProgress;
    property OnFSCommand: TShockwaveFlashFSCommand read FOnFSCommand write FOnFSCommand;
  end;

// *********************************************************************//
// The Class CoFlashProp provides a Create and CreateRemote method to          
// create instances of the default interface IUnknown exposed by              
// the CoClass FlashProp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFlashProp = class
    class function Create: IUnknown;
    class function CreateRemote(const MachineName: string): IUnknown;
  end;

// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFlashProp
// Help String      : Macromedia Flash Player Properties
// Default Interface: IUnknown
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFlashPropProperties= class;
{$ENDIF}
  TFlashProp = class(TOleServer)
  private
    FIntf:        IUnknown;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFlashPropProperties;
    function      GetServerProperties: TFlashPropProperties;
{$ENDIF}
    function      GetDefaultInterface: IUnknown;
  protected
    procedure InitServerData; override;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IUnknown);
    procedure Disconnect; override;
    property  DefaultInterface: IUnknown read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFlashPropProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TFlashProp
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TFlashPropProperties = class(TPersistent)
  private
    FServer:    TFlashProp;
    function    GetDefaultInterface: IUnknown;
    constructor Create;
  protected
  public
    property DefaultInterface: IUnknown read GetDefaultInterface;
  published
  end;
{$ENDIF}

// *********************************************************************//
// The Class CoFlashObjectInterface provides a Create and CreateRemote method to          
// create instances of the default interface IFlashObjectInterface exposed by              
// the CoClass FlashObjectInterface. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFlashObjectInterface = class
    class function Create: IFlashObjectInterface;
    class function CreateRemote(const MachineName: string): IFlashObjectInterface;
  end;

// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TFlashObjectInterface
// Help String      : IFlashObjectInterface Interface
// Default Interface: IFlashObjectInterface
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TFlashObjectInterfaceProperties= class;
{$ENDIF}
  TFlashObjectInterface = class(TOleServer)
  private
    FIntf:        IFlashObjectInterface;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TFlashObjectInterfaceProperties;
    function      GetServerProperties: TFlashObjectInterfaceProperties;
{$ENDIF}
    function      GetDefaultInterface: IFlashObjectInterface;
  protected
    procedure InitServerData; override;
  public
    constructor Create;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IFlashObjectInterface);
    procedure Disconnect; override;
    function  GetDispID(const bstrName: WideString; grfdex: LongWord; out pid: Integer): HResult;
    function  RemoteInvokeEx(id: Integer; lcid: LongWord; dwFlags: LongWord; var pdp: TGUID; 
                             out pvarRes: OleVariant; out pei: TGUID;
                             const pspCaller: IServiceProvider; cvarRefArg: SYSUINT; 
                             var rgiRefArg: SYSUINT; var rgvarRefArg: OleVariant): HResult;
    function  DeleteMemberByName(const bstrName: WideString; grfdex: LongWord): HResult;
    function  DeleteMemberByDispID(id: Integer): HResult;
    function  GetMemberProperties(id: Integer; grfdexFetch: LongWord; out pgrfdex: LongWord): HResult;
    function  GetMemberName(id: Integer; out pbstrName: WideString): HResult;
    function  GetNextDispID(grfdex: LongWord; id: Integer; out pid: Integer): HResult;
    function  GetNameSpaceParent(out ppunk: IUnknown): HResult;
    property  DefaultInterface: IFlashObjectInterface read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TFlashObjectInterfaceProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TFlashObjectInterface
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TFlashObjectInterfaceProperties = class(TPersistent)
  private
    FServer:    TFlashObjectInterface;
    function    GetDefaultInterface: IFlashObjectInterface;
    constructor Create;
  protected
  public
    property DefaultInterface: IFlashObjectInterface read GetDefaultInterface;
  published
  end;
{$ENDIF}

implementation

uses KOLComObj;

procedure TShockwaveFlash.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $FFFFFD9F, $000007A6, $00000096);
  CControlData: TControlData2 = (
    ClassID: '{D27CDB6E-AE6D-11CF-96B8-444553540000}';
    EventIID: '{D27CDB6D-AE6D-11CF-96B8-444553540000}';
    EventCount: 3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnReadyStateChange) - Cardinal(@Self);
end;

procedure TShockwaveFlash.CreateControl;
  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IShockwaveFlash;
  end;
begin
  if FIntf = nil then DoCreate;
end;

function TShockwaveFlash.GetControlInterface: IShockwaveFlash;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TShockwaveFlash.SetZoomRect(aleft: Integer; atop: Integer; right: Integer; bottom: Integer);
begin
  DefaultInterface.SetZoomRect(aleft, atop, right, bottom);
end;

procedure TShockwaveFlash.Zoom(factor: SYSINT);
begin
  DefaultInterface.Zoom(factor);
end;

procedure TShockwaveFlash.Pan(x: Integer; y: Integer; mode: SYSINT);
begin
  DefaultInterface.Pan(x, y, mode);
end;

procedure TShockwaveFlash.Play;
begin
  DefaultInterface.Play;
end;

procedure TShockwaveFlash.Stop;
begin
  DefaultInterface.Stop;
end;

procedure TShockwaveFlash.Back;
begin
  DefaultInterface.Back;
end;

procedure TShockwaveFlash.Forward;
begin
  DefaultInterface.Forward;
end;

procedure TShockwaveFlash.Rewind;
begin
  DefaultInterface.Rewind;
end;

procedure TShockwaveFlash.StopPlay;
begin
  DefaultInterface.StopPlay;
end;

procedure TShockwaveFlash.GotoFrame(NFrame: Integer);
begin
  DefaultInterface.GotoFrame(NFrame);
end;

function  TShockwaveFlash.CurrentFrame: Integer;
begin
  Result := DefaultInterface.CurrentFrame;
end;

function  TShockwaveFlash.IsPlaying: WordBool;
begin
  Result := DefaultInterface.IsPlaying;
end;

function  TShockwaveFlash.PercentLoaded: Integer;
begin
  Result := DefaultInterface.PercentLoaded;
end;

function  TShockwaveFlash.FrameLoaded(NFrame: Integer): WordBool;
begin
  Result := DefaultInterface.FrameLoaded(NFrame);
end;

function  TShockwaveFlash.FlashVersion: Integer;
begin
  Result := DefaultInterface.FlashVersion;
end;

procedure TShockwaveFlash.LoadMovie(layer: SYSINT; const url: WideString);
begin
  DefaultInterface.LoadMovie(layer, url);
end;

procedure TShockwaveFlash.TGotoFrame(const target: WideString; NFrame: Integer);
begin
  DefaultInterface.TGotoFrame(target, NFrame);
end;

procedure TShockwaveFlash.TGotoLabel(const target: WideString; const label_: WideString);
begin
  DefaultInterface.TGotoLabel(target, label_);
end;

function  TShockwaveFlash.TCurrentFrame(const target: WideString): Integer;
begin
  Result := DefaultInterface.TCurrentFrame(target);
end;

function  TShockwaveFlash.TCurrentLabel(const target: WideString): WideString;
begin
  Result := DefaultInterface.TCurrentLabel(target);
end;

procedure TShockwaveFlash.TPlay(const target: WideString);
begin
  DefaultInterface.TPlay(target);
end;

procedure TShockwaveFlash.TStopPlay(const target: WideString);
begin
  DefaultInterface.TStopPlay(target);
end;

procedure TShockwaveFlash.SetVariable(const aname: WideString; const value: WideString);
begin
  DefaultInterface.SetVariable(aname, value);
end;

function  TShockwaveFlash.GetVariable(const aname: WideString): WideString;
begin
  Result := DefaultInterface.GetVariable(aname);
end;

procedure TShockwaveFlash.TSetProperty(const target: WideString; property_: SYSINT; 
                                       const value: WideString);
begin
  DefaultInterface.TSetProperty(target, property_, value);
end;

function  TShockwaveFlash.TGetProperty(const target: WideString; property_: SYSINT): WideString;
begin
  Result := DefaultInterface.TGetProperty(target, property_);
end;

procedure TShockwaveFlash.TCallFrame(const target: WideString; NFrame: SYSINT);
begin
  DefaultInterface.TCallFrame(target, NFrame);
end;

procedure TShockwaveFlash.TCallLabel(const target: WideString; const label_: WideString);
begin
  DefaultInterface.TCallLabel(target, label_);
end;

procedure TShockwaveFlash.TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double);
begin
  DefaultInterface.TSetPropertyNum(target, property_, value);
end;

function  TShockwaveFlash.TGetPropertyNum(const target: WideString; property_: SYSINT): Double;
begin
  Result := DefaultInterface.TGetPropertyNum(target, property_);
end;

function  TShockwaveFlash.TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double;
begin
  Result := DefaultInterface.TGetPropertyAsNumber(target, property_);
end;

class function CoFlashProp.Create: IUnknown;
begin
  Result := CreateComObject(CLASS_FlashProp) as IUnknown;
end;

class function CoFlashProp.CreateRemote(const MachineName: string): IUnknown;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FlashProp) as IUnknown;
end;

procedure TFlashProp.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{1171A62F-05D2-11D1-83FC-00A0C9089C5A}';
    IntfIID:   '{00000000-0000-0000-C000-000000000046}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFlashProp.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IUnknown;
  end;
end;

procedure TFlashProp.ConnectTo(svrIntf: IUnknown);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFlashProp.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFlashProp.GetDefaultInterface: IUnknown;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TFlashProp.Create;
begin
  inherited Create;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFlashPropProperties.Create(@Self);
{$ENDIF}
end;

destructor TFlashProp.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFlashProp.GetServerProperties: TFlashPropProperties;
begin
  Result := FProps;
end;
{$ENDIF}

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFlashPropProperties.Create;
begin
  inherited Create;
  FServer := AServer;
end;

function TFlashPropProperties.GetDefaultInterface: IUnknown;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoFlashObjectInterface.Create: IFlashObjectInterface;
begin
  Result := CreateComObject(CLASS_FlashObjectInterface) as IFlashObjectInterface;
end;

class function CoFlashObjectInterface.CreateRemote(const MachineName: string): IFlashObjectInterface;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FlashObjectInterface) as IFlashObjectInterface;
end;

procedure TFlashObjectInterface.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D27CDB71-AE6D-11CF-96B8-444553540000}';
    IntfIID:   '{D27CDB72-AE6D-11CF-96B8-444553540000}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TFlashObjectInterface.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IFlashObjectInterface;
  end;
end;

procedure TFlashObjectInterface.ConnectTo(svrIntf: IFlashObjectInterface);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TFlashObjectInterface.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TFlashObjectInterface.GetDefaultInterface: IFlashObjectInterface;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TFlashObjectInterface.Create;
begin
  inherited Create;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TFlashObjectInterfaceProperties.Create(@Self);
{$ENDIF}
end;

destructor TFlashObjectInterface.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TFlashObjectInterface.GetServerProperties: TFlashObjectInterfaceProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TFlashObjectInterface.GetDispID(const bstrName: WideString; grfdex: LongWord; 
                                          out pid: Integer): HResult;
begin
  Result := DefaultInterface.GetDispID(bstrName, grfdex, pid);
end;

function  TFlashObjectInterface.RemoteInvokeEx(id: Integer; lcid: LongWord; dwFlags: LongWord; 
                                               var pdp: TGUID; out pvarRes: OleVariant; 
                                               out pei: TGUID; const pspCaller: IServiceProvider; 
                                               cvarRefArg: SYSUINT; var rgiRefArg: SYSUINT; 
                                               var rgvarRefArg: OleVariant): HResult;
begin
  Result := DefaultInterface.RemoteInvokeEx(id, lcid, dwFlags, pdp, pvarRes, pei, pspCaller, 
                                            cvarRefArg, rgiRefArg, rgvarRefArg);
end;

function  TFlashObjectInterface.DeleteMemberByName(const bstrName: WideString; grfdex: LongWord): HResult;
begin
  Result := DefaultInterface.DeleteMemberByName(bstrName, grfdex);
end;

function  TFlashObjectInterface.DeleteMemberByDispID(id: Integer): HResult;
begin
  Result := DefaultInterface.DeleteMemberByDispID(id);
end;

function  TFlashObjectInterface.GetMemberProperties(id: Integer; grfdexFetch: LongWord; 
                                                    out pgrfdex: LongWord): HResult;
begin
  Result := DefaultInterface.GetMemberProperties(id, grfdexFetch, pgrfdex);
end;

function  TFlashObjectInterface.GetMemberName(id: Integer; out pbstrName: WideString): HResult;
begin
  Result := DefaultInterface.GetMemberName(id, pbstrName);
end;

function  TFlashObjectInterface.GetNextDispID(grfdex: LongWord; id: Integer; out pid: Integer): HResult;
begin
  Result := DefaultInterface.GetNextDispID(grfdex, id, pid);
end;

function  TFlashObjectInterface.GetNameSpaceParent(out ppunk: IUnknown): HResult;
begin
  Result := DefaultInterface.GetNameSpaceParent(ppunk);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TFlashObjectInterfaceProperties.Create;
begin
  inherited Create;
  FServer := AServer;
end;

function TFlashObjectInterfaceProperties.GetDefaultInterface: IFlashObjectInterface;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

end.

