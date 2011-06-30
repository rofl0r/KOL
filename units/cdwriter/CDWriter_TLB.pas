unit CDWriter_TLB;

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
// File generated on 30.09.2003 20:13:14 from Type Library described below.

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
// Type Lib: c:\WINDOWS\system32\vfcdwriter.ocx (1)
// IID\LCID: {40B4C461-FE90-11D2-B1AA-E02862C10000}\0
// Helpfile: c:\WINDOWS\system32\vfcdwriter.hlp
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\STDVCL40.DLL)
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
  VFCDWRITERLibMajorVersion = 1;
  VFCDWRITERLibMinorVersion = 0;

  LIBID_VFCDWRITERLib: TGUID = '{40B4C461-FE90-11D2-B1AA-E02862C10000}';

  DIID__DVFcdwriter: TGUID = '{40B4C462-FE90-11D2-B1AA-E02862C10000}';
  DIID__DVFcdwriterEvents: TGUID = '{40B4C463-FE90-11D2-B1AA-E02862C10000}';
  CLASS_VFcdwriter: TGUID = '{40B4C464-FE90-11D2-B1AA-E02862C10000}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum enumBlankType
type
  enumBlankType = TOleEnum;
const
  EntireDisc = $00000000;
  Minimal = $00000001;
  Track = $00000002;
  Unreserve = $00000003;
  Trail = $00000004;
  Unclose = $00000005;
  LastSession = $00000006;

// Constants for enum session
type
  session = TOleEnum;
const
  SingleSession = $00000000;
  MultiSession = $00000001;
  CDI = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DVFcdwriter = dispinterface;
  _DVFcdwriterEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VFcdwriter = _DVFcdwriter;


// *********************************************************************//
// DispIntf:  _DVFcdwriter
// Flags:     (4112) Hidden Dispatchable
// GUID:      {40B4C462-FE90-11D2-B1AA-E02862C10000}
// *********************************************************************//
  _DVFcdwriter = dispinterface
    ['{40B4C462-FE90-11D2-B1AA-E02862C10000}']
    property SCSIController: Smallint dispid 1;
    property Target: Smallint dispid 2;
    property Lun: Smallint dispid 3;
    property useDriver: Smallint dispid 4;
    property Bibliography: WideString dispid 5;
    property Abstract: WideString dispid 6;
    property Copyright: WideString dispid 7;
    property Joliet: Smallint dispid 8;
    property PreparedBy: WideString dispid 9;
    property PublisherName: WideString dispid 10;
    property VolumeLabel: WideString dispid 11;
    property Blanktype: enumBlankType dispid 12;
    property TestMode: WordBool dispid 13;
    property Speed: Smallint dispid 14;
    property EjectAfterWriting: WordBool dispid 15;
    property SessionType: session dispid 16;
    property MSGProcess: WordBool dispid 17;
    function  AddWaveToCue(const WaveFile: WideString): WordBool; dispid 18;
    function  IsWaveInCue(const WaveFile: WideString): WordBool; dispid 19;
    function  WriteWavecueToCDR: WordBool; dispid 20;
    function  BlankDisk: WordBool; dispid 21;
    procedure ResetDrive; dispid 22;
    procedure ScanSCSIBus(Adapter: Smallint); dispid 23;
    function  WriteISOtoCDR(const ISOFile: WideString): WordBool; dispid 24;
    function  CreateISOFromCue(const ISOFilename: WideString): WordBool; dispid 25;
    function  AddFileOrPathToISOcue(const PathOrFile: WideString; withPath: WordBool; 
                                    const ISOPath: WideString): WordBool; dispid 26;
    procedure ClearISOCue; dispid 27;
    procedure ClearWaveCue; dispid 28;
    function  CreateMultiISOFromCue(const ISOFilename: WideString): WordBool; dispid 29;
    function  AppendISOFromCue(const ISOFilename: WideString; const ISOAppendFilename: WideString): WordBool; dispid 30;
    function  GetNumOfAdapters: Smallint; dispid 31;
    function  GetHostAdapterName(Adapter: Smallint): WideString; dispid 32;
    function  IsTaskRunning: WordBool; dispid 33;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  _DVFcdwriterEvents
// Flags:     (4096) Dispatchable
// GUID:      {40B4C463-FE90-11D2-B1AA-E02862C10000}
// *********************************************************************//
  _DVFcdwriterEvents = dispinterface
    ['{40B4C463-FE90-11D2-B1AA-E02862C10000}']
    procedure OnError(errorcode: Smallint; const errmsg: WideString); dispid 1;
    procedure OnSCSIScan(Adapter: Smallint; ID: Smallint; Lun: Smallint; const Product: WideString; 
                         const ProductIdent: WideString; const ProductRevision: WideString; 
                         devType: Smallint); dispid 2;
    procedure CommandDone; dispid 3;
    procedure OnWritingProcess(Track: Smallint; byteswritten: Integer; totalamount: Integer); dispid 4;
    procedure OnStatus(Code: Smallint; const Message: WideString); dispid 5;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCDWriter
// Help String      : VFcdwriter Control
// Default Interface: _DVFcdwriter
// Def. Intf. DISP? : Yes
// Event   Interface: _DVFcdwriterEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TCDWriterOnError = procedure(Sender: TObject; ErrorCode: Smallint; const ErrMsg: WideString) of object;
  TCDWriterOnSCSIScan = procedure(Sender: TObject; Adapter: smallint; ID: smallint; Lun: smallint; 
                                                   const Product: WideString; 
                                                   const ProductIdent: WideString; 
                                                   const ProductRevision: WideString; 
                                                   devType: smallint) of object;
  TCDWriterOnWritingProcess = procedure(Sender: TObject; Track: smallint; BytesWritten: integer; 
                                                         TotalAmount: integer) of object;
  TCDWriterOnStatus = procedure(Sender: TObject; Code: smallint; const Message: WideString) of object;

  PCDWriter = ^TCDWriter;
  TCDWriter = object(TOleCtl)
  private
    FOnError: TCDWriterOnError;
    FOnSCSIScan: TCDWriterOnSCSIScan;
    FOnCommandDone: TOnEvent;
    FOnWritingProcess: TCDWriterOnWritingProcess;
    FOnStatus: TCDWriterOnStatus;
    FIntf: _DVFcdwriter;
    function  GetControlInterface: _DVFcdwriter;
  protected
    procedure CreateControl;
    procedure InitControlData; virtual;
  public
    function  AddWaveToCue(const WaveFile: WideString): WordBool;
    function  IsWaveInCue(const WaveFile: WideString): WordBool;
    function  WriteWavecueToCDR: WordBool;
    function  BlankDisk: WordBool;
    procedure ResetDrive;
    procedure ScanSCSIBus(Adapter: Smallint);
    function  WriteISOtoCDR(const ISOFile: WideString): WordBool;
    function  CreateISOFromCue(const ISOFilename: WideString): WordBool;
    function  AddFileOrPathToISOcue(const PathOrFile: WideString; withPath: WordBool; 
                                    const ISOPath: WideString): WordBool;
    procedure ClearISOCue;
    procedure ClearWaveCue;
    function  CreateMultiISOFromCue(const ISOFilename: WideString): WordBool;
    function  AppendISOFromCue(const ISOFilename: WideString; const ISOAppendFilename: WideString): WordBool;
    function  GetNumOfAdapters: Smallint;
    function  GetHostAdapterName(Adapter: Smallint): WideString;
    function  IsTaskRunning: WordBool;
    procedure AboutBox;
    property  ControlInterface: _DVFcdwriter read GetControlInterface;
    property  DefaultInterface: _DVFcdwriter read GetControlInterface;
  //  published
    property SCSIController: Smallint index 1 read GetSmallintProp write SetSmallintProp stored False;
    property Target: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
    property Lun: Smallint index 3 read GetSmallintProp write SetSmallintProp stored False;
    property useDriver: Smallint index 4 read GetSmallintProp write SetSmallintProp stored False;
    property Bibliography: WideString index 5 read GetWideStringProp write SetWideStringProp stored False;
    property Abstract: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property Copyright: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
    property Joliet: Smallint index 8 read GetSmallintProp write SetSmallintProp stored False;
    property PreparedBy: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property PublisherName: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property VolumeLabel: WideString index 11 read GetWideStringProp write SetWideStringProp stored False;
    property Blanktype: TOleEnum index 12 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property TestMode: WordBool index 13 read GetWordBoolProp write SetWordBoolProp stored False;
    property Speed: Smallint index 14 read GetSmallintProp write SetSmallintProp stored False;
    property EjectAfterWriting: WordBool index 15 read GetWordBoolProp write SetWordBoolProp stored False;
    property SessionType: TOleEnum index 16 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property MSGProcess: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnError: TCDWriterOnError read FOnError write FOnError;
    property OnSCSIScan: TCDWriterOnSCSIScan read FOnSCSIScan write FOnSCSIScan;
    property OnCommandDone: TOnEvent read FOnCommandDone write FOnCommandDone;
    property OnWritingProcess: TCDWriterOnWritingProcess read FOnWritingProcess write FOnWritingProcess;
    property OnStatus: TCDWriterOnStatus read FOnStatus write FOnStatus;
  end;

implementation

uses KOLComObj;

procedure TCDWriter.InitControlData;
const
  CEventDispIDs: array [0..4] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005);
  CLicenseKey: array[0..32] of Word = ( $0043, $006F, $0070, $0079, $0072, $0069, $0067, $0068, $0074, $0020, $0028
    , $0063, $0029, $0020, $0031, $0039, $0039, $0039, $0020, $0056, $0069
    , $0073, $0069, $006F, $006E, $0046, $0061, $0063, $0074, $006F, $0072
    , $0079, $0000);
  CControlData: TControlData2 = (
    ClassID: '{40B4C464-FE90-11D2-B1AA-E02862C10000}';
    EventIID: '{40B4C463-FE90-11D2-B1AA-E02862C10000}';
    EventCount: 5;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnError) - Cardinal(@Self);
end;

procedure TCDWriter.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DVFcdwriter;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCDWriter.GetControlInterface: _DVFcdwriter;
begin
  CreateControl;
  Result := FIntf;
end;

function  TCDWriter.AddWaveToCue(const WaveFile: WideString): WordBool;
begin
  Result := DefaultInterface.AddWaveToCue(WaveFile);
end;

function  TCDWriter.IsWaveInCue(const WaveFile: WideString): WordBool;
begin
  Result := DefaultInterface.IsWaveInCue(WaveFile);
end;

function  TCDWriter.WriteWavecueToCDR: WordBool;
begin
  Result := DefaultInterface.WriteWavecueToCDR;
end;

function  TCDWriter.BlankDisk: WordBool;
begin
  Result := DefaultInterface.BlankDisk;
end;

procedure TCDWriter.ResetDrive;
begin
  DefaultInterface.ResetDrive;
end;

procedure TCDWriter.ScanSCSIBus(Adapter: Smallint);
begin
  DefaultInterface.ScanSCSIBus(Adapter);
end;

function  TCDWriter.WriteISOtoCDR(const ISOFile: WideString): WordBool;
begin
  Result := DefaultInterface.WriteISOtoCDR(ISOFile);
end;

function  TCDWriter.CreateISOFromCue(const ISOFilename: WideString): WordBool;
begin
  Result := DefaultInterface.CreateISOFromCue(ISOFilename);
end;

function  TCDWriter.AddFileOrPathToISOcue(const PathOrFile: WideString; withPath: WordBool; 
                                          const ISOPath: WideString): WordBool;
begin
  Result := DefaultInterface.AddFileOrPathToISOcue(PathOrFile, withPath, ISOPath);
end;

procedure TCDWriter.ClearISOCue;
begin
  DefaultInterface.ClearISOCue;
end;

procedure TCDWriter.ClearWaveCue;
begin
  DefaultInterface.ClearWaveCue;
end;

function  TCDWriter.CreateMultiISOFromCue(const ISOFilename: WideString): WordBool;
begin
  Result := DefaultInterface.CreateMultiISOFromCue(ISOFilename);
end;

function  TCDWriter.AppendISOFromCue(const ISOFilename: WideString; 
                                     const ISOAppendFilename: WideString): WordBool;
begin
  Result := DefaultInterface.AppendISOFromCue(ISOFilename, ISOAppendFilename);
end;

function  TCDWriter.GetNumOfAdapters: Smallint;
begin
  Result := DefaultInterface.GetNumOfAdapters;
end;

function  TCDWriter.GetHostAdapterName(Adapter: Smallint): WideString;
begin
  Result := DefaultInterface.GetHostAdapterName(Adapter);
end;

function  TCDWriter.IsTaskRunning: WordBool;
begin
  Result := DefaultInterface.IsTaskRunning;
end;

procedure TCDWriter.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

end.

