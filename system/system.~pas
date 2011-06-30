
{*******************************************************}  //  XCL version of System
{                                                       }  // unit. Created Jun-2000
{       Borland Delphi Runtime Library                  }  // (C) by Kladov Vladimir
{       System Unit                                     }  //
{                                                       }  // purpose: make XCL Delphi
{       Copyright (C) 1988,99 Inprise Corporation       }  // programs even smaller.
{                                                       }  //
{*******************************************************}  // Changes are marked as {X}

unit System; { Predefined constants, types, procedures, }
             { and functions (such as True, Integer, or }
             { Writeln) do not have actual declarations.}
             { Instead they are built into the compiler }
             { and are treated as if they were declared }
             { at the beginning of the System unit.     }

{$H+,I-,S-}

{ L- should never be specified.

  The IDE needs to find debug hook (through the C++
  compiler sometimes) for integrated debugging to
  function properly.

  ILINK will generate debug info for DebugHook if
  the object module has not been compiled with debug info.

  ILINK will not generate debug info for DebugHook if
  the object module has been compiled with debug info.

  Thus, the Pascal compiler must be responsible for
  generating the debug information for that symbol
  when a debug-enabled object file is produced.
}

interface

const

{ Variant type codes (wtypes.h) }

  varEmpty    = $0000; { vt_empty       }
  varNull     = $0001; { vt_null        }
  varSmallint = $0002; { vt_i2          }
  varInteger  = $0003; { vt_i4          }
  varSingle   = $0004; { vt_r4          }
  varDouble   = $0005; { vt_r8          }
  varCurrency = $0006; { vt_cy          }
  varDate     = $0007; { vt_date        }
  varOleStr   = $0008; { vt_bstr        }
  varDispatch = $0009; { vt_dispatch    }
  varError    = $000A; { vt_error       }
  varBoolean  = $000B; { vt_bool        }
  varVariant  = $000C; { vt_variant     }
  varUnknown  = $000D; { vt_unknown     }
                       { vt_decimal $e  }
                       { undefined  $f  }
                       { vt_i1      $10 }
  varByte     = $0011; { vt_ui1         }
                       { vt_ui2     $12 }
                       { vt_ui4     $13 }
                       { vt_i8      $14 }
  { if adding new items, update varLast, BaseTypeMap and OpTypeMap }
  varStrArg   = $0048; { vt_clsid    }
  varString   = $0100; { Pascal string; not OLE compatible }
  varAny      = $0101;
  varTypeMask = $0FFF;
  varArray    = $2000;
  varByRef    = $4000;

{ TVarRec.VType values }

  vtInteger    = 0;
  vtBoolean    = 1;
  vtChar       = 2;
  vtExtended   = 3;
  vtString     = 4;
  vtPointer    = 5;
  vtPChar      = 6;
  vtObject     = 7;
  vtClass      = 8;
  vtWideChar   = 9;
  vtPWideChar  = 10;
  vtAnsiString = 11;
  vtCurrency   = 12;
  vtVariant    = 13;
  vtInterface  = 14;
  vtWideString = 15;
  vtInt64      = 16;

{ Virtual method table entries }

  vmtSelfPtr           = -76;
  vmtIntfTable         = -72;
  vmtAutoTable         = -68;
  vmtInitTable         = -64;
  vmtTypeInfo          = -60;
  vmtFieldTable        = -56;
  vmtMethodTable       = -52;
  vmtDynamicTable      = -48;
  vmtClassName         = -44;
  vmtInstanceSize      = -40;
  vmtParent            = -36;
  vmtSafeCallException = -32;
  vmtAfterConstruction = -28;
  vmtBeforeDestruction = -24;
  vmtDispatch          = -20;
  vmtDefaultHandler    = -16;
  vmtNewInstance       = -12;
  vmtFreeInstance      = -8;
  vmtDestroy           = -4;

  vmtQueryInterface    = 0;
  vmtAddRef            = 4;
  vmtRelease           = 8;
  vmtCreateObject      = 12;

type

  TObject = class;

  TClass = class of TObject;

  {$EXTERNALSYM HRESULT}
  HRESULT = type Longint;  { from WTYPES.H }

{$EXTERNALSYM IUnknown}
{$EXTERNALSYM IDispatch}

  PGUID = ^TGUID;
  TGUID = packed record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

  PInterfaceEntry = ^TInterfaceEntry;
  TInterfaceEntry = packed record
    IID: TGUID;
    VTable: Pointer;
    IOffset: Integer;
    ImplGetter: Integer;
  end;

  PInterfaceTable = ^TInterfaceTable;
  TInterfaceTable = packed record
    EntryCount: Integer;
    Entries: array[0..9999] of TInterfaceEntry;
  end;

  TObject = class
    constructor Create;
    procedure Free;
    class function InitInstance(Instance: Pointer): TObject;
    procedure CleanupInstance;
    function ClassType: TClass;
    class function ClassName: ShortString;
    class function ClassNameIs(const Name: string): Boolean;
    class function ClassParent: TClass;
    class function ClassInfo: Pointer;
    class function InstanceSize: Longint;
    class function InheritsFrom(AClass: TClass): Boolean;
    class function MethodAddress(const Name: ShortString): Pointer;
    class function MethodName(Address: Pointer): ShortString;
    function FieldAddress(const Name: ShortString): Pointer;
    function GetInterface(const IID: TGUID; out Obj): Boolean;
    class function GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
    class function GetInterfaceTable: PInterfaceTable;
    function SafeCallException(ExceptObject: TObject;
      ExceptAddr: Pointer): HResult; virtual;
    procedure AfterConstruction; virtual;
    procedure BeforeDestruction; virtual;
    procedure Dispatch(var Message); virtual;
    procedure DefaultHandler(var Message); virtual;
    class function NewInstance: TObject; virtual;
    procedure FreeInstance; virtual;
    destructor Destroy; virtual;
  end;

  IUnknown = interface
    ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  IDispatch = interface(IUnknown)
    ['{00020400-0000-0000-C000-000000000046}']
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;

  TInterfacedObject = class(TObject, IUnknown)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    property RefCount: Integer read FRefCount;
  end;

  TInterfacedClass = class of TInterfacedObject;

  TVarArrayBound = packed record
    ElementCount: Integer;
    LowBound: Integer;
  end;

  PVarArray = ^TVarArray;
  TVarArray = packed record
    DimCount: Word;
    Flags: Word;
    ElementSize: Integer;
    LockCount: Integer;
    Data: Pointer;
    Bounds: array[0..255] of TVarArrayBound;
  end;

  PVarData = ^TVarData;
  TVarData = packed record
    VType: Word;
    Reserved1, Reserved2, Reserved3: Word;
    case Integer of
      varSmallint: (VSmallint: Smallint);
      varInteger:  (VInteger: Integer);
      varSingle:   (VSingle: Single);
      varDouble:   (VDouble: Double);
      varCurrency: (VCurrency: Currency);
      varDate:     (VDate: Double);
      varOleStr:   (VOleStr: PWideChar);
      varDispatch: (VDispatch: Pointer);
      varError:    (VError: LongWord);
      varBoolean:  (VBoolean: WordBool);
      varUnknown:  (VUnknown: Pointer);
      varByte:     (VByte: Byte);
      varString:   (VString: Pointer);
      varAny:      (VAny: Pointer);
      varArray:    (VArray: PVarArray);
      varByRef:    (VPointer: Pointer);
  end;

  PShortString = ^ShortString;
  PAnsiString = ^AnsiString;
  PWideString = ^WideString;
  PString = PAnsiString;

  PExtended = ^Extended;
  PCurrency = ^Currency;
  PVariant = ^Variant;
  POleVariant = ^OleVariant;
  PInt64 = ^Int64;

  TDateTime = type Double;
  PDateTime = ^TDateTime;

  PVarRec = ^TVarRec;
  TVarRec = record { do not pack this record; it is compiler-generated }
    case Byte of
      vtInteger:    (VInteger: Integer; VType: Byte);
      vtBoolean:    (VBoolean: Boolean);
      vtChar:       (VChar: Char);
      vtExtended:   (VExtended: PExtended);
      vtString:     (VString: PShortString);
      vtPointer:    (VPointer: Pointer);
      vtPChar:      (VPChar: PChar);
      vtObject:     (VObject: TObject);
      vtClass:      (VClass: TClass);
      vtWideChar:   (VWideChar: WideChar);
      vtPWideChar:  (VPWideChar: PWideChar);
      vtAnsiString: (VAnsiString: Pointer);
      vtCurrency:   (VCurrency: PCurrency);
      vtVariant:    (VVariant: PVariant);
      vtInterface:  (VInterface: Pointer);
      vtWideString: (VWideString: Pointer);
      vtInt64:      (VInt64: PInt64);
  end;

  PMemoryManager = ^TMemoryManager;
  TMemoryManager = record
    GetMem: function(Size: Integer): Pointer;
    FreeMem: function(P: Pointer): Integer;
    ReallocMem: function(P: Pointer; Size: Integer): Pointer;
  end;

  THeapStatus = record
    TotalAddrSpace: Cardinal;
    TotalUncommitted: Cardinal;
    TotalCommitted: Cardinal;
    TotalAllocated: Cardinal;
    TotalFree: Cardinal;
    FreeSmall: Cardinal;
    FreeBig: Cardinal;
    Unused: Cardinal;
    Overhead: Cardinal;
    HeapErrorCode: Cardinal;
  end;

  PackageUnitEntry = packed record
    Init, FInit : procedure;
  end;

  { Compiler generated table to be processed sequentially to init & finit all package units }
  { Init: 0..Max-1; Final: Last Initialized..0                                              }
  UnitEntryTable = array [0..9999999] of PackageUnitEntry;
  PUnitEntryTable = ^UnitEntryTable;

  PackageInfoTable = packed record
    UnitCount : Integer;      { number of entries in UnitInfo array; always > 0 }
    UnitInfo : PUnitEntryTable;
  end;

  PackageInfo = ^PackageInfoTable;

  { Each package exports a '@GetPackageInfoTable' which can be used to retrieve }
  { the table which contains compiler generated information about the package DLL }
  GetPackageInfoTable = function : PackageInfo;





const
  advapi32 = 'advapi32.dll';
  kernel = 'kernel32.dll';
  user = 'user32.dll';
  oleaut = 'oleaut32.dll';

{X+ moved here from SysInit.pas - by advise of Alexey Torgashin - to avoid
               creating of separate import block from kernel32.dll : }
//////////////////////////////////////////////////////////////////////////

function FreeLibrary(ModuleHandle: Longint): LongBool; stdcall;
  external kernel name 'FreeLibrary';

function GetModuleFileName(Module: Integer; Filename: PChar; Size: Integer): Integer; stdcall;
  external kernel name 'GetModuleFileNameA';

function GetModuleHandle(ModuleName: PChar): Integer; stdcall;
  external kernel name 'GetModuleHandleA';

function LocalAlloc(flags, size: Integer): Pointer; stdcall;
  external kernel name 'LocalAlloc';

function LocalFree(addr: Pointer): Pointer; stdcall;
  external kernel name 'LocalFree';

function TlsAlloc: Integer; stdcall;
  external kernel name 'TlsAlloc';

function TlsFree(TlsIndex: Integer): Boolean; stdcall;
  external kernel name 'TlsFree';

function TlsGetValue(TlsIndex: Integer): Pointer; stdcall;
  external kernel name 'TlsGetValue';

function TlsSetValue(TlsIndex: Integer; TlsValue: Pointer): Boolean; stdcall;
  external kernel name 'TlsSetValue';

function GetCommandLine: PChar; stdcall;
  external kernel name 'GetCommandLineA';

{X-}//////////////////////////////////////////////////////////////////////



{X} // following two procedures are optional and exclusive.
{X} // call it to provide error message: first - for GUI app,
{X} // second - for console app.
{X} procedure UseErrorMessageBox;
{X} procedure UseErrorMessageWrite;

{X} // call following procedure to initialize Input and Output
{X} // - for console app only:
{X} procedure UseInputOutput;

{X} // if your app uses FPU, call one of following procedures:
{X} procedure FpuInit;
{X} procedure FpuInitConsiderNECWindows;
{X} // the second additionally takes into consideration NEC
{X} // Windows keyboard (Japaneeze keyboard ???).

{X} // following variables are converted to a functions:
{X} function CmdShow : Integer;
{X} function CmdLine : PChar;

{X} procedure VarCastError;
{X} procedure VarInvalidOp;

{X} procedure DummyProc; // empty procedure

{X} procedure VariantAddRef;
{X} // procedure to refer to _VarAddRef if SysVarnt.pas is in use
{X} var VarAddRefProc : procedure = DummyProc;

{X} procedure VariantClr;
{X} // procedure to refer to _VarClr if SysVarnt.pas is in use
{X} var VarClrProc : procedure = DummyProc;

{X} procedure WStrAddRef;
{X} // procedure to refer to _WStrAddRef if SysWStr.pas is in use
{X} var WStrAddRefProc : procedure = DummyProc;

{X} procedure WStrClr;
{X} // procedure to refer to _WStrClr if SysWStr.pas is in use
{X} var WStrClrProc : procedure = DummyProc;

{X} procedure WStrArrayClr;
{X} // procedure to refer to _WStrArrayClr if SysWStr.pas is in use
{X} var WStrArrayClrProc : procedure = DummyProc;

{X} // By default, now system memory management routines are used
{X} // to allocate memory. This can be slow sometimes, so if You
{X} // want to use custom Borland Delphi memory manager, call follow:
{X} procedure UseDelphiMemoryManager;
{X} function IsDelphiMemoryManagerSet : Boolean;
{X} function MemoryManagerNotUsed : Boolean;

{X} // Standard Delphi units initialization/finalization uses
{X} // try-except and raise constructions, which leads to permanent
{X} // usage of all exception handling routines. In this XCL-aware
{X} // implementation, "light" version of initialization/finalization
{X} // is used by default. To use standard Delphi initialization and
{X} // finalization method, allowing to flow execution control even
{X} // in initalization sections, include reference to SysSfIni.pas
{X} // into uses clause *as first as possible*.
{X} procedure InitUnitsLight( Table : PUnitEntryTable; Idx, Count : Integer );
{X} procedure InitUnitsHard( Table : PUnitEntryTable; Idx, Count : Integer );
{X} var InitUnitsProc : procedure( Table : PUnitEntryTable; Idx, Count : Integer )
{X}        = InitUnitsLight;
{X} procedure FInitUnitsLight;
{X} procedure FInitUnitsHard;
{X} var FInitUnitsProc : procedure = FInitUnitsLight;
{X} procedure SetExceptionHandler;
{X} procedure UnsetExceptionHandler;
{X} var UnsetExceptionHandlerProc : procedure = DummyProc;

{X} var UnloadResProc: procedure = DummyProc;





function RaiseList: Pointer;  { Stack of current exception objects }
function SetRaiseList(NewPtr: Pointer): Pointer;  { returns previous value }
procedure SetInOutRes(NewValue: Integer);

var

  ExceptProc: Pointer;    { Unhandled exception handler }
  ErrorProc: Pointer;     { Error handler procedure }
  ExceptClsProc: Pointer; { Map an OS Exception to a Delphi class reference }
  ExceptObjProc: Pointer; { Map an OS Exception to a Delphi class instance }
  ExceptionClass: TClass; { Exception base class (must be Exception) }
  SafeCallErrorProc: Pointer; { Safecall error handler }
  AssertErrorProc: Pointer; { Assertion error handler }
  AbstractErrorProc: Pointer; { Abstract method error handler }
  HPrevInst: LongWord;    { Handle of previous instance - HPrevInst cannot be tested for multiple instances in Win32}
  MainInstance: LongWord; { Handle of the main(.EXE) HInstance }
  MainThreadID: LongWord; { ThreadID of thread that module was initialized in }
  IsLibrary: Boolean;     { True if module is a DLL }
{X  CmdShow: Integer;       { CmdShow parameter for CreateWindow - converted to a function X}
{X  CmdLine: PChar;         { Command line pointer               - converted to a function X}
  InitProc: Pointer;      { Last installed initialization procedure }
  ExitCode: Integer;      { Program result }
  ExitProc: Pointer;      { Last installed exit procedure }
  ErrorAddr: Pointer;     { Address of run-time error }
  RandSeed: Longint;      { Base for random number generator }
  IsConsole: Boolean;     { True if compiled as console app }
  IsMultiThread: Boolean; { True if more than one thread }
  FileMode: Byte {X} = 2; { Standard mode for opening files }
  Test8086: Byte {X} = 2; { Will always be 2 (386 or later) }
  Test8087: Byte {X} = 3; { Will always be 3 (387 or later) }
  TestFDIV: Shortint;     { -1: Flawed Pentium, 0: Not determined, 1: Ok }
  Input: Text;            { Standard input }
  Output: Text;           { Standard output }

  ClearAnyProc: Pointer;  { Handler clearing a varAny }
  ChangeAnyProc: Pointer; { Handler to change any to variant }
  RefAnyProc: Pointer;    { Handler to add a reference to an varAny }

var
  Default8087CW: Word = $1332;{ Default 8087 control word.  FPU control
                                register is set to this value.
                                CAUTION:  Setting this to an invalid value
                                          could cause unpredictable behavior. }

  HeapAllocFlags: Word = 2;   { Heap allocation flags, gmem_Moveable }
  DebugHook: Byte = 0;        { 1 to notify debugger of non-Delphi exceptions
                                >1 to notify debugger of exception unwinding }
  JITEnable: Byte = 0;        { 1 to call UnhandledExceptionFilter if the exception
                                  is not a Pascal exception.
                                >1 to call UnhandledExceptionFilter for all exceptions }
  NoErrMsg: Boolean = False;  { True causes the base RTL to not display the message box
                                when a run-time error occurs }

var
  (* {X-} moved to SysVarnt.pas

  Unassigned: Variant;    { Unassigned standard constant }
  Null: Variant;          { Null standard constant }
  EmptyParam: OleVariant; { "Empty parameter" standard constant which can be
                            passed as an optional parameter on a dual interface. }
  {X+} *)

  AllocMemCount: Integer; { Number of allocated memory blocks }
  AllocMemSize: Integer;  { Total size of allocated memory blocks }

{ Memory manager support }

procedure GetMemoryManager(var MemMgr: TMemoryManager);
procedure SetMemoryManager(const MemMgr: TMemoryManager);
{X} // following function is replaced with pointer to one
{X} // (initialized by another)
{X} //function IsMemoryManagerSet: Boolean;
var IsMemoryManagerSet : function : Boolean = MemoryManagerNotUsed;

function SysGetMem(Size: Integer): Pointer;
function SysFreeMem(P: Pointer): Integer;
function SysReallocMem(P: Pointer; Size: Integer): Pointer;

function GetHeapStatus: THeapStatus;

{ Thread support }
type
  TThreadFunc = function(Parameter: Pointer): Integer;

function BeginThread(SecurityAttributes: Pointer; StackSize: LongWord;
  ThreadFunc: TThreadFunc; Parameter: Pointer; CreationFlags: LongWord;
  var ThreadId: LongWord): Integer;

procedure EndThread(ExitCode: Integer);

{ Standard procedures and functions }

procedure _ChDir(const S: string);
procedure __Flush(var F: Text);
procedure _LGetDir(D: Byte; var S: string);
procedure _SGetDir(D: Byte; var S: ShortString);
function IOResult: Integer;
procedure _MkDir(const S: string);
procedure Move(const Source; var Dest; Count: Integer);
function ParamCount: Integer;
function ParamStr(Index: Integer): string;
procedure Randomize;
procedure _RmDir(const S: string);
function UpCase(Ch: Char): Char;

{ Control 8087 control word }

procedure Set8087CW(NewCW: Word);

{ Wide character support procedures and functions }

function WideCharToString(Source: PWideChar): string;
function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string;
procedure WideCharToStrVar(Source: PWideChar; var Dest: string);
procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer;
  var Dest: string);
function StringToWideChar(const Source: string; Dest: PWideChar;
  DestSize: Integer): PWideChar;

{ OLE string support procedures and functions }

function OleStrToString(Source: PWideChar): string;
procedure OleStrToStrVar(Source: PWideChar; var Dest: string);
function StringToOleStr(const Source: string): PWideChar;

{ Variant support procedures and functions }

procedure _VarClear(var V : Variant);
procedure _VarCopy(var Dest : Variant; const Source: Variant);
procedure _VarCast(var Dest : Variant; const Source: Variant; VarType: Integer);
procedure _VarCastOle(var Dest : Variant; const Source: Variant; VarType: Integer);
procedure VarCopyNoInd(var Dest: Variant; const Source: Variant);
function VarType(const V: Variant): Integer;
function VarAsType(const V: Variant; VarType: Integer): Variant;
function VarIsEmpty(const V: Variant): Boolean;
function VarIsNull(const V: Variant): Boolean;
function VarToStr(const V: Variant): string;
function VarFromDateTime(DateTime: TDateTime): Variant;
function VarToDateTime(const V: Variant): TDateTime;

{ Variant array support procedures and functions }

function VarArrayCreate(const Bounds: array of Integer;
  VarType: Integer): Variant;
function VarArrayOf(const Values: array of Variant): Variant;
procedure _VarArrayRedim(var A : Variant; HighBound: Integer);
function VarArrayDimCount(const A: Variant): Integer;
function VarArrayLowBound(const A: Variant; Dim: Integer): Integer;
function VarArrayHighBound(const A: Variant; Dim: Integer): Integer;
function VarArrayLock(const A: Variant): Pointer;
procedure VarArrayUnlock(const A: Variant);
function VarArrayRef(const A: Variant): Variant;
function VarIsArray(const A: Variant): Boolean;

{ Variant IDispatch call support }

procedure _DispInvokeError;

var
  VarDispProc: Pointer = @_DispInvokeError;
  DispCallByIDProc: Pointer = @_DispInvokeError;

{ Package/Module registration and unregistration }

type
  PLibModule = ^TLibModule;
  TLibModule = record
    Next: PLibModule;
    Instance: LongWord;
    CodeInstance: LongWord;
    DataInstance: LongWord;
    ResInstance: LongWord;
    Reserved: Integer;
  end;

  TEnumModuleFunc = function (HInstance: Integer; Data: Pointer): Boolean;
  {$EXTERNALSYM TEnumModuleFunc}
  TEnumModuleFuncLW = function (HInstance: LongWord; Data: Pointer): Boolean;
  {$EXTERNALSYM TEnumModuleFuncLW}
  TModuleUnloadProc = procedure (HInstance: Integer);
  {$EXTERNALSYM TModuleUnloadProc}
  TModuleUnloadProcLW = procedure (HInstance: LongWord);
  {$EXTERNALSYM TModuleUnloadProcLW}

  PModuleUnloadRec = ^TModuleUnloadRec;
  TModuleUnloadRec = record
    Next: PModuleUnloadRec;
    Proc: TModuleUnloadProcLW;
  end;

var
  LibModuleList: PLibModule = nil;
  ModuleUnloadList: PModuleUnloadRec = nil;

procedure RegisterModule(LibModule: PLibModule);
{X procedure UnregisterModule(LibModule: PLibModule); -replaced with pointer to procedure }
{X} procedure UnregisterModuleLight(LibModule: PLibModule);
{X} procedure UnregisterModuleSafely(LibModule: PLibModule);
var UnregisterModule : procedure(LibModule: PLibModule) = UnregisterModuleLight;
function FindHInstance(Address: Pointer): LongWord;
function FindClassHInstance(ClassType: TClass): LongWord;
function FindResourceHInstance(Instance: LongWord): LongWord;
function LoadResourceModule(ModuleName: PChar): LongWord;
procedure EnumModules(Func: TEnumModuleFunc; Data: Pointer); overload;
procedure EnumResourceModules(Func: TEnumModuleFunc; Data: Pointer); overload;
procedure EnumModules(Func: TEnumModuleFuncLW; Data: Pointer); overload;
procedure EnumResourceModules(Func: TEnumModuleFuncLW; Data: Pointer); overload;
procedure AddModuleUnloadProc(Proc: TModuleUnloadProc); overload;
procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProc); overload;
procedure AddModuleUnloadProc(Proc: TModuleUnloadProcLW); overload;
procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProcLW); overload;

{ ResString support function/record }

type
  PResStringRec = ^TResStringRec;
  TResStringRec = packed record
    Module: ^Longint;
    Identifier: Integer;
  end;

function LoadResString(ResStringRec: PResStringRec): string;

{ Procedures and functions that need compiler magic }

procedure _COS;
procedure _EXP;
procedure _INT;
procedure _SIN;
procedure _FRAC;
procedure _ROUND;
procedure _TRUNC;

procedure _AbstractError;
procedure _Assert(const Message, Filename: AnsiString; LineNumber: Integer);
procedure _Append;
procedure _Assign(var T: Text; S: ShortString);
procedure _BlockRead;
procedure _BlockWrite;
procedure _Close;
procedure _PStrCat;
procedure _PStrNCat;
procedure _PStrCpy;
procedure _PStrNCpy;
procedure _EofFile;
procedure _EofText;
procedure _Eoln;
procedure _Erase;
procedure _FilePos;
procedure _FileSize;
procedure _FillChar;
procedure _FreeMem;
procedure _GetMem;
procedure _ReallocMem;
procedure _Halt;
procedure _Halt0;
procedure _Mark;
procedure _PStrCmp;
procedure _AStrCmp;
procedure _RandInt;
procedure _RandExt;
procedure _ReadRec;
procedure _ReadChar;
procedure _ReadLong;
procedure _ReadString;
procedure _ReadCString;
procedure _ReadLString;
procedure _ReadExt;
procedure _ReadLn;
procedure _Rename;
procedure _Release;
procedure _ResetText(var T: Text);
procedure _ResetFile;
procedure _RewritText(var T: Text);
procedure _RewritFile;
procedure _RunError;
procedure _Run0Error;
procedure _Seek;
procedure _SeekEof;
procedure _SeekEoln;
procedure _SetTextBuf;
procedure _StrLong;
procedure _Str0Long;
procedure _Truncate;
procedure _ValLong;
procedure _WriteRec;
procedure _WriteChar;
procedure _Write0Char;
procedure _WriteBool;
procedure _Write0Bool;
procedure _WriteLong;
procedure _Write0Long;
procedure _WriteString;
procedure _Write0String;
procedure _WriteCString;
procedure _Write0CString;
procedure _WriteLString;
procedure _Write0LString;
function _WriteVariant(var T: Text; const V: Variant; Width: Integer): Pointer;
function _Write0Variant(var T: Text; const V: Variant): Pointer;
procedure _Write2Ext;
procedure _Write1Ext;
procedure _Write0Ext;
procedure _WriteLn;

procedure __CToPasStr;
procedure __CLenToPasStr;
procedure __ArrayToPasStr;
procedure __PasToCStr;

procedure __IOTest;
procedure _Flush(var F: Text);

procedure _SetElem;
procedure _SetRange;
procedure _SetEq;
procedure _SetLe;
procedure _SetIntersect;
procedure _SetIntersect3; { BEG only }
procedure _SetUnion;
procedure _SetUnion3; { BEG only }
procedure _SetSub;
procedure _SetSub3; { BEG only }
procedure _SetExpand;

procedure _Str2Ext;
procedure _Str0Ext;
procedure _Str1Ext;
procedure _ValExt;
procedure _Pow10;
procedure _Real2Ext;
procedure _Ext2Real;

procedure _ObjSetup;
procedure _ObjCopy;
procedure _Fail;
procedure _BoundErr;
procedure _IntOver;
procedure _StartExe;
procedure _StartLib;
procedure _PackageLoad  (const Table : PackageInfo);
procedure _PackageUnload(const Table : PackageInfo);
procedure _InitResStrings;
procedure _InitResStringImports;
procedure _InitImports;
procedure _InitWideStrings;

procedure _ClassCreate;
procedure _ClassDestroy;
procedure _AfterConstruction;
procedure _BeforeDestruction;
procedure _IsClass;
procedure _AsClass;

procedure _RaiseExcept;
procedure _RaiseAgain;
procedure _DoneExcept;
procedure _TryFinallyExit;

procedure _CallDynaInst;
procedure _CallDynaClass;
procedure _FindDynaInst;
procedure _FindDynaClass;

procedure _LStrClr(var S: AnsiString);
procedure _LStrArrayClr{var str: AnsiString; cnt: longint};
procedure _LStrAsg{var dest: AnsiString; source: AnsiString};
procedure _LStrLAsg{var dest: AnsiString; source: AnsiString};
procedure _LStrFromPCharLen(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
procedure _LStrFromPWCharLen(var Dest: AnsiString; Source: PWideChar; Length: Integer);
procedure _LStrFromChar(var Dest: AnsiString; Source: AnsiChar);
procedure _LStrFromWChar(var Dest: AnsiString; Source: WideChar);
procedure _LStrFromPChar(var Dest: AnsiString; Source: PAnsiChar);
procedure _LStrFromPWChar(var Dest: AnsiString; Source: PWideChar);
procedure _LStrFromString(var Dest: AnsiString; const Source: ShortString);
procedure _LStrFromArray(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
procedure _LStrFromWArray(var Dest: AnsiString; Source: PWideChar; Length: Integer);
procedure _LStrFromWStr(var Dest: AnsiString; const Source: WideString);
procedure _LStrToString{(var Dest: ShortString; const Source: AnsiString; MaxLen: Integer)};
function _LStrLen{str: AnsiString}: Longint;
procedure _LStrCat{var dest: AnsiString; source: AnsiString};
procedure _LStrCat3{var dest:AnsiString; source1: AnsiString; source2: AnsiString};
procedure _LStrCatN{var dest:AnsiString; argCnt: Integer; ...};
procedure _LStrCmp{left: AnsiString; right: AnsiString};
procedure _LStrAddRef{str: AnsiString};
procedure _LStrToPChar{str: AnsiString): PChar};
procedure _Copy{ s : ShortString; index, count : Integer ) : ShortString};
procedure _Delete{ var s : openstring; index, count : Integer };
procedure _Insert{ source : ShortString; var s : openstring; index : Integer };
procedure _Pos{ substr : ShortString; s : ShortString ) : Integer};
procedure _SetLength{var s: ShortString; newLength: Integer};
procedure _SetString{var s: ShortString: buffer: PChar; len: Integer};

procedure UniqueString(var str: string);
procedure _NewAnsiString{length: Longint};      { for debugger purposes only }

procedure _LStrCopy  { const s : AnsiString; index, count : Integer) : AnsiString};
procedure _LStrDelete{ var s : AnsiString; index, count : Integer };
procedure _LStrInsert{ const source : AnsiString; var s : AnsiString; index : Integer };
procedure _LStrPos{ const substr : AnsiString; const s : AnsiString ) : Integer};
procedure _LStrSetLength{ var str: AnsiString; newLength: Integer};
procedure _LStrOfChar{ c: Char; count: Integer): AnsiString };

procedure _WStrClr(var S: WideString);
procedure _WStrArrayClr(var StrArray; Count: Integer);
procedure _WStrAsg(var Dest: WideString; const Source: WideString);
procedure _WStrFromPCharLen(var Dest: WideString; Source: PAnsiChar; Length: Integer);
procedure _WStrFromPWCharLen(var Dest: WideString; Source: PWideChar; Length: Integer);
procedure _WStrFromChar(var Dest: WideString; Source: AnsiChar);
procedure _WStrFromWChar(var Dest: WideString; Source: WideChar);
procedure _WStrFromPChar(var Dest: WideString; Source: PAnsiChar);
procedure _WStrFromPWChar(var Dest: WideString; Source: PWideChar);
procedure _WStrFromString(var Dest: WideString; const Source: ShortString);
procedure _WStrFromArray(var Dest: WideString; Source: PAnsiChar; Length: Integer);
procedure _WStrFromWArray(var Dest: WideString; Source: PWideChar; Length: Integer);
procedure _WStrFromLStr(var Dest: WideString; const Source: AnsiString);
procedure _WStrToString(Dest: PShortString; const Source: WideString; MaxLen: Integer);
function _WStrToPWChar(const S: WideString): PWideChar;
function _WStrLen(const S: WideString): Integer;
procedure _WStrCat(var Dest: WideString; const Source: WideString);
procedure _WStrCat3(var Dest: WideString; const Source1, Source2: WideString);
procedure _WStrCatN{var dest:WideString; argCnt: Integer; ...};
procedure _WStrCmp{left: WideString; right: WideString};
function _NewWideString(Length: Integer): PWideChar;
function _WStrCopy(const S: WideString; Index, Count: Integer): WideString;
procedure _WStrDelete(var S: WideString; Index, Count: Integer);
procedure _WStrInsert(const Source: WideString; var Dest: WideString; Index: Integer);
procedure _WStrPos{ const substr : WideString; const s : WideString ) : Integer};
procedure _WStrSetLength(var S: WideString; NewLength: Integer);
function _WStrOfWChar(Ch: WideChar; Count: Integer): WideString;
procedure _WStrAddRef{var str: WideString};

procedure _Initialize;
procedure _InitializeArray;
procedure _InitializeRecord;
procedure _Finalize;
procedure _FinalizeArray;
procedure _FinalizeRecord;
procedure _AddRef;
procedure _AddRefArray;
procedure _AddRefRecord;
procedure _CopyArray;
procedure _CopyRecord;
procedure _CopyObject;

procedure _New;
procedure _Dispose;

procedure _DispInvoke; cdecl;
procedure _IntfDispCall; cdecl;
procedure _IntfVarCall; cdecl;

procedure _VarToInt;
procedure _VarToBool;
procedure _VarToReal;
procedure _VarToCurr;
procedure _VarToPStr(var S; const V: Variant);
procedure _VarToLStr(var S: string; const V: Variant);
procedure _VarToWStr(var S: WideString; const V: Variant);
procedure _VarToIntf(var Unknown: IUnknown; const V: Variant);
procedure _VarToDisp(var Dispatch: IDispatch; const V: Variant);
procedure _VarToDynArray(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);

procedure _VarFromInt;
procedure _VarFromBool;
procedure _VarFromReal;
procedure _VarFromTDateTime;
procedure _VarFromCurr;
procedure _VarFromPStr(var V: Variant; const Value: ShortString);
procedure _VarFromLStr(var V: Variant; const Value: string);
procedure _VarFromWStr(var V: Variant; const Value: WideString);
procedure _VarFromIntf(var V: Variant; const Value: IUnknown);
procedure _VarFromDisp(var V: Variant; const Value: IDispatch);
procedure _VarFromDynArray(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
procedure _OleVarFromPStr(var V: OleVariant; const Value: ShortString);
procedure _OleVarFromLStr(var V: OleVariant; const Value: string);
procedure _OleVarFromVar(var V: OleVariant; const Value: Variant);

procedure _VarAdd;
procedure _VarSub;
procedure _VarMul;
procedure _VarDiv;
procedure _VarMod;
procedure _VarAnd;
procedure _VarOr;
procedure _VarXor;
procedure _VarShl;
procedure _VarShr;
procedure _VarRDiv;
procedure _VarCmp;

procedure _VarNeg;
procedure _VarNot;

procedure _VarCopyNoInd;
procedure _VarClr;
procedure _VarAddRef;

{ 64-bit Integer helper routines }

procedure __llmul;
procedure __lldiv;
procedure __lludiv;
procedure __llmod;
procedure __llmulo;
procedure __lldivo;
procedure __llmodo;
procedure __llumod;
procedure __llshl;
procedure __llushr;
procedure _WriteInt64;
procedure _Write0Int64;
procedure _ReadInt64;
function _StrInt64(val: Int64; width: Integer): ShortString;
function _Str0Int64(val: Int64): ShortString;
function _ValInt64(const s: AnsiString; var code: Integer): Int64;

{ Dynamic array helper functions }

procedure _DynArrayHigh;
procedure _DynArrayClear(var a: Pointer; typeInfo: Pointer);
procedure _DynArrayLength;
procedure _DynArraySetLength;
procedure _DynArrayCopy(a: Pointer; typeInfo: Pointer; var Result: Pointer);
procedure _DynArrayCopyRange(a: Pointer; typeInfo: Pointer; index, count : Integer; var Result: Pointer);
procedure _DynArrayAsg;
procedure _DynArrayAddRef;
procedure  DynArrayToVariant(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
procedure  DynArrayFromVariant(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);

procedure _IntfClear(var Dest: IUnknown);
procedure _IntfCopy(var Dest: IUnknown; const Source: IUnknown);
procedure _IntfCast(var Dest: IUnknown; const Source: IUnknown; const IID: TGUID);
procedure _IntfAddRef(const Dest: IUnknown);

function _VarArrayGet(var A: Variant; IndexCount: Integer;
  Indices: Integer): Variant; cdecl;
procedure _VarArrayPut(var A: Variant; const Value: Variant;
  IndexCount: Integer; Indices: Integer); cdecl;

procedure _HandleAnyException;
procedure _HandleOnException;
procedure _HandleFinally;
procedure _HandleAutoException;

procedure _FSafeDivide;
procedure _FSafeDivideR;

procedure _CheckAutoResult;

procedure FPower10;

procedure TextStart;

function  CompToDouble(acomp: Comp): Double; cdecl;
procedure DoubleToComp(adouble: Double; var result: Comp); cdecl;
function  CompToCurrency(acomp: Comp): Currency; cdecl;
procedure CurrencyToComp(acurrency: Currency; var result: Comp); cdecl;

function GetMemory(Size: Integer): Pointer; cdecl;
function FreeMemory(P: Pointer): Integer; cdecl;
function ReallocMemory(P: Pointer; Size: Integer): Pointer; cdecl;

(* =================================================================== *)

implementation

uses
  SysInit;

{ Internal runtime error codes }

const
  reOutOfMemory       = 1;
  reInvalidPtr        = 2;
  reDivByZero         = 3;
  reRangeError        = 4;
  reIntOverflow       = 5;
  reInvalidOp         = 6;
  reZeroDivide        = 7;
  reOverflow          = 8;
  reUnderflow         = 9;
  reInvalidCast       = 10;
  reAccessViolation   = 11;
  reStackOverflow     = 12;
  reControlBreak      = 13;
  rePrivInstruction   = 14;
  reVarTypeCast       = 15;
  reVarInvalidOp      = 16;
  reVarDispatch       = 17;
  reVarArrayCreate    = 18;
  reVarNotArray       = 19;
  reVarArrayBounds    = 20;
  reAssertionFailed   = 21;
  reExternalException = 22;     { not used here; in SysUtils }
  reIntfCastError     = 23;
  reSafeCallError     = 24;

{ this procedure should be at the very beginning of the }
{ text segment. it is only used by _RunError to find    }
{ start address of the text segment so a nice error     }
{ location can be shown.                                                                }

procedure TextStart;
begin
end;

{ ----------------------------------------------------- }
{       NT Calls necessary for the .asm files           }
{ ----------------------------------------------------- }

type
  PMemInfo = ^TMemInfo;
  TMemInfo = packed record
    BaseAddress: Pointer;
    AllocationBase: Pointer;
    AllocationProtect: Longint;
    RegionSize: Longint;
    State: Longint;
    Protect: Longint;
    Type_9 : Longint;
  end;

  PStartupInfo = ^TStartupInfo;
  TStartupInfo = record
    cb: Longint;
    lpReserved: Pointer;
    lpDesktop: Pointer;
    lpTitle: Pointer;
    dwX: Longint;
    dwY: Longint;
    dwXSize: Longint;
    dwYSize: Longint;
    dwXCountChars: Longint;
    dwYCountChars: Longint;
    dwFillAttribute: Longint;
    dwFlags: Longint;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: ^Byte;
    hStdInput: Integer;
    hStdOutput: Integer;
    hStdError: Integer;
  end;

  TWin32FindData = packed record
    dwFileAttributes: Integer;
    ftCreationTime: Int64;
    ftLastAccessTime: Int64;
    ftLastWriteTime: Int64;
    nFileSizeHigh: Integer;
    nFileSizeLow: Integer;
    dwReserved0: Integer;
    dwReserved1: Integer;
    cFileName: array[0..259] of Char;
    cAlternateFileName: array[0..13] of Char;
  end;




procedure CloseHandle;                  external kernel name 'CloseHandle';
procedure CreateFileA;                  external kernel name 'CreateFileA';
procedure DeleteFileA;                  external kernel name 'DeleteFileA';
procedure GetFileType;                  external kernel name 'GetFileType';
procedure GetSystemTime;                external kernel name 'GetSystemTime';
procedure GetFileSize;                  external kernel name 'GetFileSize';
procedure GetStdHandle;                 external kernel name 'GetStdHandle';
//procedure GetStartupInfo;               external kernel name 'GetStartupInfo';
procedure MoveFileA;                    external kernel name 'MoveFileA';
procedure RaiseException;               external kernel name 'RaiseException';
procedure ReadFile;                     external kernel name 'ReadFile';
procedure RtlUnwind;                    external kernel name 'RtlUnwind';
procedure SetEndOfFile;                 external kernel name 'SetEndOfFile';
procedure SetFilePointer;               external kernel name 'SetFilePointer';
procedure UnhandledExceptionFilter;     external kernel name 'UnhandledExceptionFilter';
procedure WriteFile;                    external kernel name 'WriteFile';

function CharNext(lpsz: PChar): PChar; stdcall;
  external user name 'CharNextA';

function CreateThread(SecurityAttributes: Pointer; StackSize: LongWord;
                     ThreadFunc: TThreadFunc; Parameter: Pointer;
                     CreationFlags: LongWord; var ThreadId: LongWord): Integer; stdcall;
  external kernel name 'CreateThread';

procedure ExitThread(ExitCode: Integer); stdcall;
  external kernel name 'ExitThread';

procedure ExitProcess(ExitCode: Integer); stdcall;
  external kernel name 'ExitProcess';

procedure MessageBox(Wnd: Integer; Text: PChar; Caption: PChar; Typ: Integer); stdcall;
  external user   name 'MessageBoxA';

function CreateDirectory(PathName: PChar; Attr: Integer): WordBool; stdcall;
  external kernel name 'CreateDirectoryA';

function FindClose(FindFile: Integer): LongBool; stdcall;
  external kernel name 'FindClose';

function FindFirstFile(FileName: PChar; var FindFileData: TWIN32FindData): Integer; stdcall;
  external kernel name 'FindFirstFileA';

{X} //function FreeLibrary(ModuleHandle: Longint): LongBool; stdcall;
{X} //  external kernel name 'FreeLibrary';

{X} //function GetCommandLine: PChar; stdcall;
{X} //  external kernel name 'GetCommandLineA';

function GetCurrentDirectory(BufSize: Integer; Buffer: PChar): Integer; stdcall;
  external kernel name 'GetCurrentDirectoryA';

function GetLastError: Integer; stdcall;
  external kernel name 'GetLastError';

function GetLocaleInfo(Locale: Longint; LCType: Longint; lpLCData: PChar; cchData: Integer): Integer; stdcall;
  external kernel name 'GetLocaleInfoA';

{X} //function GetModuleFileName(Module: Integer; Filename: PChar;
{X} //  Size: Integer): Integer; stdcall;
{X} //  external kernel name 'GetModuleFileNameA';

{X} //function GetModuleHandle(ModuleName: PChar): Integer; stdcall;
{X} //  external kernel name 'GetModuleHandleA';

function GetProcAddress(Module: Integer; ProcName: PChar): Pointer; stdcall;
  external kernel name 'GetProcAddress';

procedure GetStartupInfo(var lpStartupInfo: TStartupInfo); stdcall;
  external kernel name 'GetStartupInfoA';

function GetThreadLocale: Longint; stdcall;
  external kernel name 'GetThreadLocale';

function LoadLibraryEx(LibName: PChar; hFile: Longint; Flags: Longint): Longint; stdcall;
  external kernel name 'LoadLibraryExA';

function LoadString(Instance: Longint; IDent: Integer; Buffer: PChar;
  Size: Integer): Integer; stdcall;
  external user name 'LoadStringA';

{function lstrcat(lpString1, lpString2: PChar): PChar; stdcall;
  external kernel name 'lstrcatA';}

function lstrcpy(lpString1, lpString2: PChar): PChar; stdcall;
  external kernel name 'lstrcpyA';

function lstrcpyn(lpString1, lpString2: PChar;
  iMaxLength: Integer): PChar; stdcall;
  external kernel name 'lstrcpynA';

function lstrlen(lpString: PChar): Integer; stdcall;
  external kernel name 'lstrlenA';

function MultiByteToWideChar(CodePage, Flags: Integer; MBStr: PChar;
  MBCount: Integer; WCStr: PWideChar; WCCount: Integer): Integer; stdcall;
  external kernel name 'MultiByteToWideChar';

function RegCloseKey(hKey: Integer): Longint; stdcall;
  external advapi32 name 'RegCloseKey';

function RegOpenKeyEx(hKey: LongWord; lpSubKey: PChar; ulOptions,
  samDesired: LongWord; var phkResult: LongWord): Longint; stdcall;
  external advapi32 name 'RegOpenKeyExA';

function RegQueryValueEx(hKey: LongWord; lpValueName: PChar;
  lpReserved: Pointer; lpType: Pointer; lpData: PChar; lpcbData: Pointer): Integer; stdcall;
  external advapi32 name 'RegQueryValueExA';

function RemoveDirectory(PathName: PChar): WordBool; stdcall;
  external kernel name 'RemoveDirectoryA';

function SetCurrentDirectory(PathName: PChar): WordBool; stdcall;
  external kernel name 'SetCurrentDirectoryA';

function WideCharToMultiByte(CodePage, Flags: Integer; WCStr: PWideChar;
  WCCount: Integer; MBStr: PChar; MBCount: Integer; DefaultChar: PChar;
  UsedDefaultChar: Pointer): Integer; stdcall;
  external kernel name 'WideCharToMultiByte';

function VirtualQuery(lpAddress: Pointer;
  var lpBuffer: TMemInfo; dwLength: Longint): Longint; stdcall;
  external kernel name 'VirtualQuery';

//function SysAllocString(P: PWideChar): PWideChar; stdcall;
//  external oleaut name 'SysAllocString';

function SysAllocStringLen(P: PWideChar; Len: Integer): PWideChar; stdcall;
  external oleaut name 'SysAllocStringLen';

function SysReAllocStringLen(var S: WideString; P: PWideChar;
  Len: Integer): LongBool; stdcall;
  external oleaut name 'SysReAllocStringLen';

procedure SysFreeString(const S: WideString); stdcall;
  external oleaut name 'SysFreeString';

function SysStringLen(const S: WideString): Integer; stdcall;
  external oleaut name 'SysStringLen';

//procedure VariantInit(var V: Variant); stdcall;
//  external oleaut name 'VariantInit';

function VariantClear(var V: Variant): Integer; stdcall;
  external oleaut name 'VariantClear';

function VariantCopy(var Dest: Variant; const Source: Variant): Integer; stdcall;
  external oleaut name 'VariantCopy';

function VariantCopyInd(var Dest: Variant; const Source: Variant): Integer; stdcall;
  external oleaut name 'VariantCopyInd';

//function VariantChangeType(var Dest: Variant; const Source: Variant;
//  Flags: Word; VarType: Word): Integer; stdcall;
//  external oleaut name 'VariantChangeType';

function VariantChangeTypeEx(var Dest: Variant; const Source: Variant;
  LCID: Integer; Flags: Word; VarType: Word): Integer; stdcall;
  external oleaut name 'VariantChangeTypeEx';

function SafeArrayCreate(VarType, DimCount: Integer;
  const Bounds): PVarArray; stdcall;
  external oleaut name 'SafeArrayCreate';

function SafeArrayRedim(VarArray: PVarArray;
  var NewBound: TVarArrayBound): Integer; stdcall;
  external oleaut name 'SafeArrayRedim';

function SafeArrayGetLBound(VarArray: PVarArray; Dim: Integer;
  var LBound: Integer): Integer; stdcall;
  external oleaut name 'SafeArrayGetLBound';

function SafeArrayGetUBound(VarArray: PVarArray; Dim: Integer;
  var UBound: Integer): Integer; stdcall;
  external oleaut name 'SafeArrayGetUBound';

function SafeArrayAccessData(VarArray: PVarArray;
  var Data: Pointer): Integer; stdcall;
  external oleaut name 'SafeArrayAccessData';

function SafeArrayUnaccessData(VarArray: PVarArray): Integer; stdcall;
  external oleaut name 'SafeArrayUnaccessData';

function SafeArrayGetElement(VarArray: PVarArray; Indices,
  Data: Pointer): Integer; stdcall;
  external oleaut name 'SafeArrayGetElement';

function SafeArrayPtrOfIndex(VarArray: PVarArray; Indices: Pointer;
  var pvData: Pointer): HResult; stdcall;
  external oleaut name 'SafeArrayPtrOfIndex';

function SafeArrayPutElement(VarArray: PVarArray; Indices,
  Data: Pointer): Integer; stdcall;
  external oleaut name 'SafeArrayPutElement';

function InterlockedIncrement(var Addend: Integer): Integer; stdcall;
  external kernel name 'InterlockedIncrement';

function InterlockedDecrement(var Addend: Integer): Integer; stdcall;
  external kernel name 'InterlockedDecrement';

var SaveCmdShow : Integer = -1;
function CmdShow: Integer;
var
  SI: TStartupInfo;
begin
  if SaveCmdShow < 0 then
  begin
    SaveCmdShow := 10;                  { SW_SHOWDEFAULT }
    GetStartupInfo(SI);
    if SI.dwFlags and 1 <> 0 then  { STARTF_USESHOWWINDOW }
      SaveCmdShow := SI.wShowWindow;
  end;
  Result := SaveCmdShow;
end;

{ ----------------------------------------------------- }
{       Memory manager                                                                          }
{ ----------------------------------------------------- }

procedure Error(errorCode: Byte); forward;

{$I GETMEM.INC }

{X- by default, system memory allocation routines (API calls)
    are used. To use Inprise's memory manager (Delphi standard)
    call UseDelphiMemoryManager procedure. }
var
  MemoryManager: TMemoryManager = (
    GetMem: DfltGetMem;
    FreeMem: DfltFreeMem;
    ReallocMem: DfltReallocMem);

const
  DelphiMemoryManager: TMemoryManager = (
    GetMem: SysGetMem;
    FreeMem: SysFreeMem;
    ReallocMem: SysReallocMem);

procedure UseDelphiMemoryManager;
begin
  IsMemoryManagerSet := IsDelphiMemoryManagerSet; 
  SetMemoryManager( DelphiMemoryManager );
end;
{X+}

procedure _GetMem;
asm
        TEST    EAX,EAX
        JE      @@1
        CALL    MemoryManager.GetMem
        OR      EAX,EAX
        JE      @@2
@@1:    RET
@@2:    MOV     AL,reOutOfMemory
        JMP     Error
end;

procedure _FreeMem;
asm
        TEST    EAX,EAX
        JE      @@1
        CALL    MemoryManager.FreeMem
        OR      EAX,EAX
        JNE     @@2
@@1:    RET
@@2:    MOV     AL,reInvalidPtr
        JMP     Error
end;

procedure _ReallocMem;
asm
        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      @@alloc
        TEST    EDX,EDX
        JE      @@free
@@resize:
        PUSH    EAX
        MOV     EAX,ECX
        CALL    MemoryManager.ReallocMem
        POP     ECX
        OR      EAX,EAX
        JE      @@allocError
        MOV     [ECX],EAX
        RET
@@freeError:
        MOV     AL,reInvalidPtr
        JMP     Error
@@free:
        MOV     [EAX],EDX
        MOV     EAX,ECX
        CALL    MemoryManager.FreeMem
        OR      EAX,EAX
        JNE     @@freeError
        RET
@@allocError:
        MOV     AL,reOutOfMemory
        JMP     Error
@@alloc:
        TEST    EDX,EDX
        JE      @@exit
        PUSH    EAX
        MOV     EAX,EDX
        CALL    MemoryManager.GetMem
        POP     ECX
        OR      EAX,EAX
        JE      @@allocError
        MOV     [ECX],EAX
@@exit:
end;

procedure GetMemoryManager(var MemMgr: TMemoryManager);
begin
  MemMgr := MemoryManager;
end;

procedure SetMemoryManager(const MemMgr: TMemoryManager);
begin
  MemoryManager := MemMgr;
end;

//{X} - function is replaced with pointer to one.
//  function IsMemoryManagerSet: Boolean;
function IsDelphiMemoryManagerSet;
begin
  with MemoryManager do
    Result := (@GetMem <> @SysGetMem) or (@FreeMem <> @SysFreeMem) or
      (@ReallocMem <> @SysReallocMem);
end;

{X+ always returns False. Initial handler for IsMemoryManagerSet }
function MemoryManagerNotUsed : Boolean;
begin
  Result := False;
end;
{X-}

threadvar
  RaiseListPtr: pointer;
  InOutRes: Integer;

function RaiseList: Pointer;
asm
        CALL    SysInit.@GetTLS
        MOV     EAX, [EAX].RaiseListPtr
end;

function SetRaiseList(NewPtr: Pointer): Pointer;
asm
        MOV     ECX, EAX
        CALL    SysInit.@GetTLS
        MOV     EDX, [EAX].RaiseListPtr
        MOV     [EAX].RaiseListPtr, ECX
        MOV     EAX, EDX
end;

{ ----------------------------------------------------- }
{    local functions & procedures of the system unit    }
{ ----------------------------------------------------- }

procedure Error(errorCode: Byte);
asm
        AND     EAX,127
        MOV     ECX,ErrorProc
        TEST    ECX,ECX
        JE      @@term
        POP     EDX
        CALL    ECX
@@term:
        DEC     EAX
        MOV     AL,byte ptr @@errorTable[EAX]
        JNS     @@skip
        CALL    SysInit.@GetTLS
        MOV     EAX,[EAX].InOutRes
@@skip:
        JMP     _RunError

@@errorTable:
        DB      203     { reOutOfMemory }
        DB      204     { reInvalidPtr }
        DB      200     { reDivByZero }
        DB      201     { reRangeError }
{               210       abstract error }
        DB      215     { reIntOverflow }
        DB      207     { reInvalidOp }
        DB      200     { reZeroDivide }
        DB      205     { reOverflow }
        DB      206     { reUnderflow }
        DB      219     { reInvalidCast }
        DB      216     { Access violation }
        DB      202     { Stack overflow }
        DB      217     { Control-C }
        DB      218     { Privileged instruction }
        DB      220     { Invalid variant type cast }
        DB      221     { Invalid variant operation }
        DB      222     { No variant method call dispatcher }
        DB      223     { Cannot create variant array }
        DB      224     { Variant does not contain an array }
        DB      225     { Variant array bounds error }
{               226       thread init failure }
        DB      227     { reAssertionFailed }
        DB      0       { reExternalException not used here; in SysUtils }
        DB      228     { reIntfCastError }
        DB      229     { reSafeCallError }
end;

procedure       __IOTest;
asm
        PUSH    EAX
        PUSH    EDX
        PUSH    ECX
        CALL    SysInit.@GetTLS
        CMP     [EAX].InOutRes,0
        POP     ECX
        POP     EDX
        POP     EAX
        JNE     @error
        RET
@error:
        XOR     EAX,EAX
        JMP     Error
end;

procedure SetInOutRes;
asm
        PUSH    EAX
        CALL    SysInit.@GetTLS
        POP     [EAX].InOutRes
end;


procedure InOutError;
asm
        CALL    GetLastError
        JMP     SetInOutRes
end;

procedure _ChDir(const S: string);
begin
  if not SetCurrentDirectory(PChar(S)) then InOutError;
end;

procedure       _Copy{ s : ShortString; index, count : Integer ) : ShortString};
asm
{     ->EAX     Source string                   }
{       EDX     index                           }
{       ECX     count                           }
{       [ESP+4] Pointer to result string        }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,[ESP+8+4]

        XOR     EAX,EAX
        OR      AL,[ESI]
        JZ      @@srcEmpty

{       limit index to satisfy 1 <= index <= Length(src) }

        TEST    EDX,EDX
        JLE     @@smallInx
        CMP     EDX,EAX
        JG      @@bigInx
@@cont1:

{       limit count to satisfy 0 <= count <= Length(src) - index + 1    }

        SUB     EAX,EDX { calculate Length(src) - index + 1     }
        INC     EAX
        TEST    ECX,ECX
        JL      @@smallCount
        CMP     ECX,EAX
        JG      @@bigCount
@@cont2:

        ADD     ESI,EDX

        MOV     [EDI],CL
        INC     EDI
        REP     MOVSB
        JMP     @@exit

@@smallInx:
        MOV     EDX,1
        JMP     @@cont1
@@bigInx:
{       MOV     EDX,EAX
        JMP     @@cont1 }
@@smallCount:
        XOR     ECX,ECX
        JMP     @@cont2
@@bigCount:
        MOV     ECX,EAX
        JMP     @@cont2
@@srcEmpty:
        MOV     [EDI],AL
@@exit:
        POP     EDI
        POP     ESI
    RET 4
end;

procedure       _Delete{ var s : openstring; index, count : Integer };
asm
{     ->EAX     Pointer to s    }
{       EDX     index           }
{       ECX     count           }

        PUSH    ESI
        PUSH    EDI

        MOV     EDI,EAX

        XOR     EAX,EAX
        MOV     AL,[EDI]

{       if index not in [1 .. Length(s)] do nothing     }

        TEST    EDX,EDX
        JLE     @@exit
        CMP     EDX,EAX
        JG      @@exit

{       limit count to [0 .. Length(s) - index + 1]     }

        TEST    ECX,ECX
        JLE     @@exit
        SUB     EAX,EDX         { calculate Length(s) - index + 1       }
        INC     EAX
        CMP     ECX,EAX
        JLE     @@1
        MOV     ECX,EAX
@@1:
        SUB     [EDI],CL        { reduce Length(s) by count                     }
        ADD     EDI,EDX         { point EDI to first char to be deleted }
        LEA     ESI,[EDI+ECX]   { point ESI to first char to be preserved       }
        SUB     EAX,ECX         { #chars = Length(s) - index + 1 - count        }
        MOV     ECX,EAX

        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI
end;

procedure       __Flush( var f : Text );
external;       {   Assign  }

procedure       _Flush( var f : Text );
external;       {   Assign  }

procedure _LGetDir(D: Byte; var S: string);
var
  Drive: array[0..3] of Char;
  DirBuf, SaveBuf: array[0..259] of Char;
begin
  if D <> 0 then
  begin
        Drive[0] := Chr(D + Ord('A') - 1);
        Drive[1] := ':';
        Drive[2] := #0;
        GetCurrentDirectory(SizeOf(SaveBuf), SaveBuf);
        SetCurrentDirectory(Drive);
  end;
  GetCurrentDirectory(SizeOf(DirBuf), DirBuf);
  if D <> 0 then SetCurrentDirectory(SaveBuf);
  S := DirBuf;
end;

procedure _SGetDir(D: Byte; var S: ShortString);
var
  L: string;
begin
  GetDir(D, L);
  S := L;
end;

procedure       _Insert{ source : ShortString; var s : openstring; index : Integer };
asm
{     ->EAX     Pointer to source string        }
{       EDX     Pointer to destination string   }
{       ECX     Length of destination string    }
{       [ESP+4] Index                   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    ECX
        MOV     ECX,[ESP+16+4]
        SUB     ESP,512         { VAR buf: ARRAY [0..511] of Char       }

        MOV     EBX,EDX         { save pointer to s for later   }
        MOV     ESI,EDX

        XOR     EDX,EDX
        MOV     DL,[ESI]
        INC     ESI

{       limit index to [1 .. Length(s)+1]       }

        INC     EDX
        TEST    ECX,ECX
        JLE     @@smallInx
        CMP     ECX,EDX
        JG      @@bigInx
@@cont1:
        DEC     EDX     { EDX = Length(s)               }
                        { EAX = Pointer to src  }
                        { ESI = EBX = Pointer to s      }
                        { ECX = Index           }

{       copy index-1 chars from s to buf        }

        MOV     EDI,ESP
        DEC     ECX
        SUB     EDX,ECX { EDX = remaining length of s   }
        REP     MOVSB

{       copy Length(src) chars from src to buf  }

        XCHG    EAX,ESI { save pointer into s, point ESI to src         }
        MOV     CL,[ESI]        { ECX = Length(src) (ECX was zero after rep)    }
        INC     ESI
        REP     MOVSB

{       copy remaining chars of s to buf        }

        MOV     ESI,EAX { restore pointer into s                }
        MOV     ECX,EDX { copy remaining bytes of s             }
        REP     MOVSB

{       calculate total chars in buf    }

        SUB     EDI,ESP         { length = bufPtr - buf         }
        MOV     ECX,[ESP+512]   { ECX = Min(length, destLength) }
{       MOV     ECX,[EBP-16]   }{ ECX = Min(length, destLength) }
        CMP     ECX,EDI
        JB      @@1
        MOV     ECX,EDI
@@1:
        MOV     EDI,EBX         { Point EDI to s                }
        MOV     ESI,ESP         { Point ESI to buf              }
        MOV     [EDI],CL        { Store length in s             }
        INC     EDI
        REP     MOVSB           { Copy length chars to s        }
        JMP     @@exit

@@smallInx:
        MOV     ECX,1
        JMP     @@cont1
@@bigInx:
        MOV     ECX,EDX
        JMP     @@cont1

@@exit:
        ADD     ESP,512+4
        POP     EDI
        POP     ESI
        POP     EBX
    RET 4
end;

function IOResult: Integer;
asm
        CALL    SysInit.@GetTLS
        XOR     EDX,EDX
        MOV     ECX,[EAX].InOutRes
        MOV     [EAX].InOutRes,EDX
        MOV     EAX,ECX
end;

procedure _MkDir(const S: string);
begin
  if not CreateDirectory(PChar(S), 0) then InOutError;
end;

procedure       Move( const Source; var Dest; count : Integer );
asm
{     ->EAX     Pointer to source       }
{       EDX     Pointer to destination  }
{       ECX     Count                   }

(*{X-} // original code.

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EAX,ECX

        CMP     EDI,ESI
        JA      @@down
        JE      @@exit

        SAR     ECX,2           { copy count DIV 4 dwords       }
        JS      @@exit

        REP     MOVSD

        MOV     ECX,EAX
        AND     ECX,03H
        REP     MOVSB           { copy count MOD 4 bytes        }
        JMP     @@exit

@@down:
        LEA     ESI,[ESI+ECX-4] { point ESI to last dword of source     }
        LEA     EDI,[EDI+ECX-4] { point EDI to last dword of dest       }

        SAR     ECX,2           { copy count DIV 4 dwords       }
        JS      @@exit
        STD
        REP     MOVSD

        MOV     ECX,EAX
        AND     ECX,03H         { copy count MOD 4 bytes        }
        ADD     ESI,4-1         { point to last byte of rest    }
        ADD     EDI,4-1
        REP     MOVSB
        CLD
@@exit:
        POP     EDI
        POP     ESI
*){X+}
//---------------------------------------
(* {X+} // Let us write smaller:
        JCXZ    @@fin

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EAX,ECX

        AND     ECX,3           { copy count mod 4 dwords       }

        CMP     EDI,ESI
        JE      @@exit
        JA      @@up

//down:
        LEA     ESI,[ESI+EAX-1] { point ESI to last byte of source     }
        LEA     EDI,[EDI+EAX-1] { point EDI to last byte of dest       }
        STD

        CMP     EAX, 4
        JL      @@up
        ADD     ECX, 3          { move 3 bytes more to correct pos }

@@up:
        REP     MOVSB

        SAR     EAX, 2
        JS      @@exit

        MOV     ECX, EAX
        REP     MOVSD

@@exit:
        CLD
        POP     EDI
        POP     ESI

@@fin:
*) {X-}
//---------------------------------------
{X+} // And now, let us write speedy:
        CMP      ECX, 4
        JGE      @@long
        JCXZ     @@fin

        CMP      EAX, EDX
        JE       @@fin

        PUSH     ESI
        PUSH     EDI
        MOV      ESI, EAX
        MOV      EDI, EDX
        JA       @@short_up

        LEA     ESI,[ESI+ECX-1] { point ESI to last byte of source     }
        LEA     EDI,[EDI+ECX-1] { point EDI to last byte of dest       }
        STD

@@short_up:
        REP     MOVSB
        JMP     @@exit_up

@@long:
        CMP     EAX, EDX
        JE      @@fin

        PUSH    ESI
        PUSH    EDI
        MOV     ESI, EAX
        MOV     EDI, EDX
        MOV     EAX, ECX

        JA      @@long_up

        {
        SAR     ECX, 2
        JS      @@exit

        LEA     ESI,[ESI+EAX-4]
        LEA     EDI,[EDI+EAX-4]
        STD
        REP     MOVSD

        MOV     ECX, EAX
        MOV     EAX, 3
        AND     ECX, EAX
        ADD     ESI, EAX
        ADD     EDI, EAX
        REP     MOVSB
        } // let's do it in other order - faster if data are aligned...

        AND     ECX, 3
        LEA     ESI,[ESI+EAX-1]
        LEA     EDI,[EDI+EAX-1]
        STD
        REP     MOVSB

        SAR     EAX, 2
        //JS    @@exit         // why to test this? but what does PC do?
        MOV     ECX, EAX
        MOV     EAX, 3
        SUB     ESI, EAX
        SUB     EDI, EAX
        REP     MOVSD

@@exit_up:
        CLD
        //JMP     @@exit
        DEC     ECX     // the same - loosing 2 tacts... but conveyer!

@@long_up:
        SAR     ECX, 2
        JS      @@exit

        REP     MOVSD

        AND     EAX, 3
        MOV     ECX, EAX
        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI

@@fin:
{X-}
end;

function GetParamStr(P: PChar; var Param: string): PChar;
var
  Len: Integer;
  Buffer: array[0..4095] of Char;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do Inc(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  while (P[0] > ' ') and (Len < SizeOf(Buffer)) do
    if P[0] = '"' then
    begin
      Inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Buffer[Len] := P[0];
        Inc(Len);
        Inc(P);
      end;
      if P[0] <> #0 then Inc(P);
    end else
    begin
      Buffer[Len] := P[0];
      Inc(Len);
      Inc(P);
    end;
  SetString(Param, Buffer, Len);
  Result := P;
end;

function ParamCount: Integer;
var
  P: PChar;
  S: string;
begin
  P := GetParamStr(GetCommandLine, S);
  Result := 0;
  while True do
  begin
    P := GetParamStr(P, S);
    if S = '' then Break;
    Inc(Result);
  end;
end;

function ParamStr(Index: Integer): string;
var
  P: PChar;
  Buffer: array[0..260] of Char;
begin
  if Index = 0 then
    SetString(Result, Buffer, GetModuleFileName(0, Buffer, SizeOf(Buffer)))
  else
  begin
    P := GetCommandLine;
    while True do
    begin
      P := GetParamStr(P, Result);
      if (Index = 0) or (Result = '') then Break;
      Dec(Index);
    end;
  end;
end;

procedure       _Pos{ substr : ShortString; s : ShortString ) : Integer};
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in s or 0    }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX { Point ESI to substr           }
        MOV     EDI,EDX { Point EDI to s                }

        XOR     ECX,ECX { ECX = Length(s)               }
        MOV     CL,[EDI]
        INC     EDI             { Point EDI to first char of s  }

        PUSH    EDI             { remember s position to calculate index        }

        XOR     EDX,EDX { EDX = Length(substr)          }
        MOV     DL,[ESI]
        INC     ESI             { Point ESI to first char of substr     }

        DEC     EDX             { EDX = Length(substr) - 1              }
        JS      @@fail  { < 0 ? return 0                        }
        MOV     AL,[ESI]        { AL = first char of substr             }
        INC     ESI             { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX { #positions in s to look at    }
                        { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASB
        JNE     @@fail
        MOV     EBX,ECX { save outer loop counter               }
        PUSH    ESI             { save outer loop substr pointer        }
        PUSH    EDI             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSB
        POP     EDI             { restore outer loop s pointer  }
        POP     ESI             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@found:
        POP     EDX             { restore pointer to first char of s    }
        MOV     EAX,EDI { EDI points of char after match        }
        SUB     EAX,EDX { the difference is the correct index   }
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _SetLength{var s: ShortString; newLength: Integer};
asm
        { ->    EAX pointer to string   }
        {       EDX new length          }

        MOV     [EAX],DL        { should also fill new space, parameter should be openstring }

end;

procedure       _SetString{var s: ShortString: buffer: PChar; len: Integer};
asm
        { ->    EAX pointer to string           }
        {       EDX pointer to buffer   }
        {       ECX len                         }

        MOV     [EAX],CL
        TEST    EDX,EDX
        JE      @@noMove
        XCHG    EAX,EDX
        INC     EDX
        CALL    Move
@@noMove:
end;

procedure       Randomize;
var
        systemTime :
        record
                wYear   : Word;
                wMonth  : Word;
                wDayOfWeek      : Word;
                wDay    : Word;
                wHour   : Word;
                wMinute : Word;
                wSecond : Word;
                wMilliSeconds: Word;
                reserved        : array [0..7] of char;
        end;
asm
        LEA     EAX,systemTime
        PUSH    EAX
        CALL    GetSystemTime
        MOVZX   EAX,systemTime.wHour
        IMUL    EAX,60
        ADD     AX,systemTime.wMinute   { sum = hours * 60 + minutes    }
        IMUL    EAX,60
        XOR     EDX,EDX
        MOV     DX,systemTime.wSecond
        ADD     EAX,EDX                 { sum = sum * 60 + seconds              }
        IMUL    EAX,1000
        MOV     DX,systemTime.wMilliSeconds
        ADD     EAX,EDX                 { sum = sum * 1000 + milliseconds       }
        MOV     RandSeed,EAX
end;

procedure _RmDir(const S: string);
begin
  if not RemoveDirectory(PChar(S)) then InOutError;
end;

function        UpCase( ch : Char ) : Char;
asm
{ ->    AL      Character       }
{ <-    AL      Result          }

        CMP     AL,'a'
        JB      @@exit
        CMP     AL,'z'
        JA      @@exit
        SUB     AL,'a' - 'A'
@@exit:
end;


procedure Set8087CW(NewCW: Word);
asm
        MOV     Default8087CW,AX
        FNCLEX  // don't raise pending exceptions enabled by the new flags
        FLDCW   Default8087CW
end;

{ ----------------------------------------------------- }
{       functions & procedures that need compiler magic }
{ ----------------------------------------------------- }

const cwChop : Word = $1F32;

procedure       _COS;
asm
        FCOS
        FNSTSW  AX
        SAHF
        JP      @@outOfRange
        RET
@@outOfRange:
        FSTP    st(0)   { for now, return 0. result would }
        FLDZ            { have little significance anyway }
end;

procedure       _EXP;
asm
        {       e**x = 2**(x*log2(e))   }

        FLDL2E              { y := x*log2e;      }
        FMUL
        FLD     ST(0)       { i := round(y);     }
        FRNDINT
        FSUB    ST(1), ST   { f := y - i;        }
        FXCH    ST(1)       { z := 2**f          }
        F2XM1
        FLD1
        FADD
        FSCALE              { result := z * 2**i }
        FSTP    ST(1)
end;

procedure       _INT;
asm
        SUB     ESP,4
        FSTCW   [ESP]
        FWAIT
        FLDCW   cwChop
        FRNDINT
        FWAIT
        FLDCW   [ESP]
        ADD     ESP,4
end;

procedure       _SIN;
asm
        FSIN
        FNSTSW  AX
        SAHF
        JP      @@outOfRange
        RET
@@outOfRange:
        FSTP    st(0)   { for now, return 0. result would       }
        FLDZ            { have little significance anyway       }
end;

procedure       _FRAC;
asm
        FLD     ST(0)
        SUB     ESP,4
        FSTCW   [ESP]
        FWAIT
        FLDCW   cwChop
        FRNDINT
        FWAIT
        FLDCW   [ESP]
        ADD     ESP,4
        FSUB
end;

procedure       _ROUND;
asm
        { ->    FST(0)  Extended argument       }
        { <-    EDX:EAX Result                  }

        SUB     ESP,8
        FISTP   qword ptr [ESP]
        FWAIT
        POP     EAX
        POP     EDX
end;

procedure       _TRUNC;
asm
        { ->    FST(0)   Extended argument       }
        { <-    EDX:EAX  Result                  }

        SUB     ESP,12
        FSTCW   [ESP]
        FWAIT
        FLDCW   cwChop
        FISTP   qword ptr [ESP+4]
        FWAIT
        FLDCW   [ESP]
        POP     ECX
        POP     EAX
        POP     EDX
end;

procedure       _AbstractError;
asm
        CMP     AbstractErrorProc, 0
        JE      @@NoAbstErrProc
        CALL    AbstractErrorProc

@@NoAbstErrProc:
        MOV     EAX,210
        JMP     _RunError
end;

procedure       _Append;                                external;       {   OpenText}
procedure       _Assign(var t: text; s: ShortString);   external;       {$L Assign  }
procedure       _BlockRead;                             external;       {$L BlockRea}
procedure       _BlockWrite;                            external;       {$L BlockWri}
procedure       _Close;                                 external;       {$L Close   }

procedure       _PStrCat;
asm
{     ->EAX = Pointer to destination string     }
{       EDX = Pointer to source string  }

        PUSH    ESI
        PUSH    EDI

{       load dest len into EAX  }

        MOV     EDI,EAX
        XOR     EAX,EAX
        MOV     AL,[EDI]

{       load source address in ESI, source len in ECX   }

        MOV     ESI,EDX
        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ESI

{       calculate final length in DL and store it in the destination    }

        MOV     DL,AL
        ADD     DL,CL
        JC      @@trunc

@@cont:
        MOV     [EDI],DL

{       calculate final dest address    }

        INC     EDI
        ADD     EDI,EAX

{       do the copy     }

        REP     MOVSB

{       done    }

        POP     EDI
        POP     ESI
        RET

@@trunc:
        INC     DL      {       DL = #chars to truncate                 }
        SUB     CL,DL   {       CL = source len - #chars to truncate    }
        MOV     DL,255  {       DL = maximum length                     }
        JMP     @@cont
end;

procedure       _PStrNCat;
asm
{     ->EAX = Pointer to destination string                     }
{       EDX = Pointer to source string                          }
{       CL  = max length of result (allocated size of dest - 1) }

        PUSH    ESI
        PUSH    EDI

{       load dest len into EAX  }

        MOV     EDI,EAX
        XOR     EAX,EAX
        MOV     AL,[EDI]

{       load source address in ESI, source len in EDX   }

        MOV     ESI,EDX
        XOR     EDX,EDX
        MOV     DL,[ESI]
        INC     ESI

{       calculate final length in AL and store it in the destination    }

        ADD     AL,DL
        JC      @@trunc
        CMP     AL,CL
        JA      @@trunc

@@cont:
        MOV     ECX,EDX
        MOV     DL,[EDI]
        MOV     [EDI],AL

{       calculate final dest address    }

        INC     EDI
        ADD     EDI,EDX

{       do the copy     }

        REP     MOVSB

@@done:
        POP     EDI
        POP     ESI
        RET

@@trunc:
{       CL = maxlen     }

        MOV     AL,CL   { AL = final length = maxlen            }
        SUB     CL,[EDI]        { CL = length to copy = maxlen - destlen        }
        JBE     @@done
        MOV     DL,CL
        JMP     @@cont
end;

procedure       _PStrCpy;
asm
{     ->EAX = Pointer to dest string    }
{       EDX = Pointer to source string  }

        XOR     ECX,ECX

        PUSH    ESI
        PUSH    EDI

        MOV     CL,[EDX]

        MOV     EDI,EAX

        INC     ECX             { we must copy len+1 bytes      }

        MOV     ESI,EDX

        MOV     EAX,ECX
        SHR     ECX,2
        AND     EAX,3
        REP     MOVSD

        MOV     ECX,EAX
        REP     MOVSB

        POP     EDI
        POP     ESI
end;

procedure       _PStrNCpy;
asm
{     ->EAX = Pointer to dest string                            }
{       EDX = Pointer to source string                          }
{       CL  = Maximum length to copy (allocated size of dest - 1)       }

        PUSH    ESI
        PUSH    EDI

        MOV     EDI,EAX
        XOR     EAX,EAX
        MOV     ESI,EDX

        MOV     AL,[EDX]
        CMP     AL,CL
        JA      @@trunc

        INC     EAX

        MOV     ECX,EAX
        AND     EAX,3
        SHR     ECX,2
        REP     MOVSD

        MOV     ECX,EAX
        REP     MOVSB

        POP     EDI
        POP     ESI
        RET

@@trunc:
        MOV     [EDI],CL        { result length is maxLen       }
        INC     ESI             { advance pointers              }
        INC     EDI
        AND     ECX,0FFH        { should be cheaper than MOVZX  }
        REP     MOVSB   { copy maxLen bytes             }

        POP     EDI
        POP     ESI
end;

procedure       _PStrCmp;
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        XOR     EAX,EAX
        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[EDI]
        INC     ESI
        INC     EDI

        SUB     EAX,EDX { eax = len1 - len2 }
        JA      @@skip1
        ADD     EDX,EAX { edx = len2 + (len1 - len2) = len1     }

@@skip1:
        PUSH    EDX
        SHR     EDX,2
        JE      @@cmpRest
@@longLoop:
        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     EDX
        JE      @@cmpRestP4
        MOV     ECX,[ESI+4]
        MOV     EBX,[EDI+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     ESI,8
        ADD     EDI,8
        DEC     EDX
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestP4:
        ADD     ESI,4
        ADD     EDI,4
@@cmpRest:
        POP     EDX
        AND     EDX,3
        JE      @@equal

        MOV     CL,[ESI]
        CMP     CL,[EDI]
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        MOV     CL,[ESI+1]
        CMP     CL,[EDI+1]
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        MOV     CL,[ESI+2]
        CMP     CL,[EDI+2]
        JNE     @@exit

@@equal:
        ADD     EAX,EAX
        JMP     @@exit

@@misMatch:
        POP     EDX
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _AStrCmp;
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }
{       ECX = Number of chars to compare}

        PUSH    EBX
        PUSH    ESI
        PUSH    ECX
        MOV     ESI,ECX
        SHR     ESI,2
        JE      @@cmpRest

@@longLoop:
        MOV     ECX,[EAX]
        MOV     EBX,[EDX]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     ESI
        JE      @@cmpRestP4
        MOV     ECX,[EAX+4]
        MOV     EBX,[EDX+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     EAX,8
        ADD     EDX,8
        DEC     ESI
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestp4:
        ADD     EAX,4
        ADD     EDX,4
@@cmpRest:
        POP     ESI
        AND     ESI,3
        JE      @@exit

        MOV     CL,[EAX]
        CMP     CL,[EDX]
        JNE     @@exit
        DEC     ESI
        JE      @@equal
        MOV     CL,[EAX+1]
        CMP     CL,[EDX+1]
        JNE     @@exit
        DEC     ESI
        JE      @@equal
        MOV     CL,[EAX+2]
        CMP     CL,[EDX+2]
        JNE     @@exit

@@equal:
        XOR     EAX,EAX
        JMP     @@exit

@@misMatch:
        POP     ESI
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH

@@exit:
        POP     ESI
        POP     EBX
end;

procedure       _EofFile;                               external;       {$L EofFile }
procedure       _EofText;                               external;       {$L EofText }
procedure       _Eoln;                          external;       {$L Eoln    }
procedure       _Erase;                         external;       {$L Erase   }

procedure       _FSafeDivide;                           external;       {$L FDIV    }
procedure       _FSafeDivideR;                          external;       {   FDIV    }

procedure       _FilePos;                               external;       {$L FilePos }
procedure       _FileSize;                              external;       {$L FileSize}

procedure       _FillChar;
asm
{     ->EAX     Pointer to destination  }
{       EDX     count   }
{       CL      value   }

        PUSH    EDI

        MOV     EDI,EAX { Point EDI to destination              }

        MOV     CH,CL   { Fill EAX with value repeated 4 times  }
        MOV     EAX,ECX
        SHL     EAX,16
        MOV     AX,CX

        MOV     ECX,EDX
        SAR     ECX,2
        JS      @@exit

        REP     STOSD   { Fill count DIV 4 dwords       }

        MOV     ECX,EDX
        AND     ECX,3
        REP     STOSB   { Fill count MOD 4 bytes        }

@@exit:
        POP     EDI
end;

procedure       _Mark;
begin
  Error(reInvalidPtr);
end;

procedure       _RandInt;
asm
{     ->EAX     Range   }
{     <-EAX     Result  }
        IMUL    EDX,RandSeed,08088405H
        INC     EDX
        MOV     RandSeed,EDX
        MUL     EDX
        MOV     EAX,EDX
end;

procedure       _RandExt;
const two2neg32: double = ((1.0/$10000) / $10000);  // 2^-32
asm
{       FUNCTION _RandExt: Extended;    }

        IMUL    EDX,RandSeed,08088405H
        INC     EDX
        MOV     RandSeed,EDX

        FLD     two2neg32
        PUSH    0
        PUSH    EDX
        FILD    qword ptr [ESP]
        ADD     ESP,8
        FMULP  ST(1), ST(0)
end;

procedure       _ReadRec;                               external;       {$L ReadRec }

procedure       _ReadChar;                              external;       {$L ReadChar}
procedure       _ReadLong;                              external;       {$L ReadLong}
procedure       _ReadString;                    external;       {$L ReadStri}
procedure       _ReadCString;                   external;       {   ReadStri}

procedure       _ReadExt;                               external;       {$L ReadExt }
procedure       _ReadLn;                                external;       {$L ReadLn  }

procedure       _Rename;                                external;       {$L Rename  }

procedure       _Release;
begin
  Error(reInvalidPtr);
end;

procedure       _ResetText(var t: text);                external;       {$L OpenText}
procedure       _ResetFile;                             external;       {$L OpenFile}
procedure       _RewritText(var t: text);               external;       {   OpenText}
procedure       _RewritFile;                    external;       {   OpenFile}

procedure       _Seek;                          external;       {$L Seek    }
procedure       _SeekEof;                               external;       {$L SeekEof }
procedure       _SeekEoln;                              external;       {$L SeekEoln}

procedure       _SetTextBuf;                    external;       {$L SetTextB}

procedure       _StrLong;
asm
{       PROCEDURE _StrLong( val: Longint; width: Longint; VAR s: ShortString );
      ->EAX     Value
        EDX     Width
        ECX     Pointer to string       }

        PUSH    EBX             { VAR i: Longint;               }
        PUSH    ESI             { VAR sign : Longint;           }
        PUSH    EDI
        PUSH    EDX             { store width on the stack      }
        SUB     ESP,20          { VAR a: array [0..19] of Char; }

        MOV     EDI,ECX

        MOV     ESI,EAX         { sign := val                   }

        CDQ                     { val := Abs(val);  canned sequence }
        XOR     EAX,EDX
        SUB     EAX,EDX

        MOV     ECX,10
        XOR     EBX,EBX         { i := 0;                       }

@@repeat1:                      { repeat                        }
        XOR     EDX,EDX         {   a[i] := Chr( val MOD 10 + Ord('0') );}

        DIV     ECX             {   val := val DIV 10;          }

        ADD     EDX,'0'
        MOV     [ESP+EBX],DL
        INC     EBX             {   i := i + 1;                 }
        TEST    EAX,EAX         { until val = 0;                }
        JNZ     @@repeat1

        TEST    ESI,ESI
        JGE     @@2
        MOV     byte ptr [ESP+EBX],'-'
        INC     EBX
@@2:
        MOV     [EDI],BL        { s^++ := Chr(i);               }
        INC     EDI

        MOV     ECX,[ESP+20]    { spaceCnt := width - i;        }
        CMP     ECX,255
        JLE     @@3
        MOV     ECX,255
@@3:
        SUB     ECX,EBX
        JLE     @@repeat2       { for k := 1 to spaceCnt do s^++ := ' ';        }
        ADD     [EDI-1],CL
        MOV     AL,' '
        REP     STOSB

@@repeat2:                      { repeat                        }
        MOV     AL,[ESP+EBX-1]  {   s^ := a[i-1];               }
        MOV     [EDI],AL
        INC     EDI             {   s := s + 1                  }
        DEC     EBX             {   i := i - 1;                 }
        JNZ     @@repeat2       { until i = 0;                  }

        ADD     ESP,20+4
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _Str0Long;
asm
{     ->EAX     Value           }
{       EDX     Pointer to string       }

        MOV     ECX,EDX
        XOR     EDX,EDX
        JMP     _StrLong
end;

procedure       _Truncate;                              external;       {$L Truncate}

procedure       _ValLong;
asm
{       FUNCTION _ValLong( s: AnsiString; VAR code: Integer ) : Longint;        }
{     ->EAX     Pointer to string       }
{       EDX     Pointer to code result  }
{     <-EAX     Result                  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        PUSH    EAX             { save for the error case       }

        TEST    EAX,EAX
        JE      @@empty

        XOR     EAX,EAX
        XOR     EBX,EBX
        MOV     EDI,07FFFFFFFH / 10     { limit }

@@blankLoop:
        MOV     BL,[ESI]
        INC     ESI
        CMP     BL,' '
        JE      @@blankLoop

@@endBlanks:
        MOV     CH,0
        CMP     BL,'-'
        JE      @@minus
        CMP     BL,'+'
        JE      @@plus
        CMP     BL,'$'
        JE      @@dollar

        CMP     BL, 'x'
        JE      @@dollar
        CMP     BL, 'X'
        JE      @@dollar
        CMP     BL, '0'
        JNE     @@firstDigit
        MOV     BL, [ESI]
        INC     ESI
        CMP     BL, 'x'
        JE      @@dollar
        CMP     BL, 'X'
        JE      @@dollar
        TEST    BL, BL
        JE      @@endDigits
        JMP     @@digLoop

@@firstDigit:
        TEST    BL,BL
        JE      @@error

@@digLoop:
        SUB     BL,'0'
        CMP     BL,9
        JA      @@error
        CMP     EAX,EDI         { value > limit ?       }
        JA      @@overFlow
        LEA     EAX,[EAX+EAX*4]
        ADD     EAX,EAX
        ADD     EAX,EBX         { fortunately, we can't have a carry    }

        MOV     BL,[ESI]
        INC     ESI

        TEST    BL,BL
        JNE     @@digLoop

@@endDigits:
        DEC     CH
        JE      @@negate
        TEST    EAX,EAX
        JL      @@overFlow

@@successExit:

        POP     ECX                     { saved copy of string pointer  }

        XOR     ESI,ESI         { signal no error to caller     }

@@exit:
        MOV     [EDX],ESI

        POP     EDI
        POP     ESI
        POP     EBX
        RET

@@empty:
        INC     ESI
        JMP     @@error

@@negate:
        NEG     EAX
        JLE     @@successExit
        JS      @@successExit           { to handle 2**31 correctly, where the negate overflows }

@@error:
@@overFlow:
        POP     EBX
        SUB     ESI,EBX
        JMP     @@exit

@@minus:
        INC     CH
@@plus:
        MOV     BL,[ESI]
        INC     ESI
        JMP     @@firstDigit

@@dollar:
        MOV     EDI,0FFFFFFFH

        MOV     BL,[ESI]
        INC     ESI
        TEST    BL,BL
        JZ      @@empty

@@hDigLoop:
        CMP     BL,'a'
        JB      @@upper
        SUB     BL,'a' - 'A'
@@upper:
        SUB     BL,'0'
        CMP     BL,9
        JBE     @@digOk
        SUB     BL,'A' - '0'
        CMP     BL,5
        JA      @@error
        ADD     BL,10
@@digOk:
        CMP     EAX,EDI
        JA      @@overFlow
        SHL     EAX,4
        ADD     EAX,EBX

        MOV     BL,[ESI]
        INC     ESI

        TEST    BL,BL
        JNE     @@hDigLoop

        JMP     @@successExit
end;

procedure       _WriteRec;                              external;       {$L WriteRec}

procedure       _WriteChar;                             external;       {   WriteStr}
procedure       _Write0Char;                    external;       {   WriteStr}

procedure       _WriteBool;
asm
{       PROCEDURE _WriteBool( VAR t: Text; val: Boolean; width: Longint);       }
{     ->EAX     Pointer to file record  }
{       DL      Boolean value           }
{       ECX     Field width             }

        TEST    DL,DL
        JE      @@false
        MOV     EDX,offset @trueString
        JMP     _WriteString
@@false:
        MOV     EDX,offset @falseString
        JMP     _WriteString
@trueString:  db        4,'TRUE'
@falseString: db        5,'FALSE'
end;

procedure       _Write0Bool;
asm
{       PROCEDURE _Write0Bool( VAR t: Text; val: Boolean);      }
{     ->EAX     Pointer to file record  }
{       DL      Boolean value           }

        XOR     ECX,ECX
        JMP     _WriteBool
end;

procedure       _WriteLong;
asm
{       PROCEDURE _WriteLong( VAR t: Text; val: Longint; with: Longint);        }
{     ->EAX     Pointer to file record  }
{       EDX     Value                   }
{       ECX     Field width             }

        SUB     ESP,32          { VAR s: String[31];    }

        PUSH    EAX
        PUSH    ECX

        MOV     EAX,EDX         { Str( val : 0, s );    }
        XOR     EDX,EDX
        CMP     ECX,31
        JG      @@1
        MOV     EDX,ECX
@@1:
        LEA     ECX,[ESP+8]
        CALL    _StrLong

        POP     ECX
        POP     EAX

        MOV     EDX,ESP         { Write( t, s : width );}
        CALL    _WriteString

        ADD     ESP,32
end;

procedure       _Write0Long;
asm
{       PROCEDURE _Write0Long( VAR t: Text; val: Longint);      }
{     ->EAX     Pointer to file record  }
{       EDX     Value                   }
        XOR     ECX,ECX
        JMP     _WriteLong
end;

procedure       _WriteString;                   external;       {$L WriteStr}
procedure       _Write0String;                  external;       {   WriteStr}

procedure       _WriteCString;                  external;       {   WriteStr}
procedure       _Write0CString;                 external;       {   WriteStr}

procedure       _WriteBytes;                    external;       {   WriteStr}
procedure       _WriteSpaces;                   external;       {   WriteStr}

procedure       _Write2Ext;
asm
{       PROCEDURE _Write2Ext( VAR t: Text; val: Extended; width, prec: Longint);
      ->EAX     Pointer to file record
        [ESP+4] Extended value
        EDX     Field width
        ECX     precision (<0: scientific, >= 0: fixed point)   }

        FLD     tbyte ptr [ESP+4]       { load value    }
        SUB     ESP,256         { VAR s: String;        }

        PUSH    EAX
        PUSH    EDX

{       Str( val, width, prec, s );     }

        SUB     ESP,12
        FSTP    tbyte ptr [ESP] { pass value            }
        MOV     EAX,EDX         { pass field width              }
        MOV     EDX,ECX         { pass precision                }
        LEA     ECX,[ESP+8+12]  { pass destination string       }
        CALL    _Str2Ext

{       Write( t, s, width );   }

        POP     ECX                     { pass width    }
        POP     EAX                     { pass text     }
        MOV     EDX,ESP         { pass string   }
        CALL    _WriteString

        ADD     ESP,256
        RET     12
end;

procedure       _Write1Ext;
asm
{       PROCEDURE _Write1Ext( VAR t: Text; val: Extended; width: Longint);
  ->    EAX     Pointer to file record
        [ESP+4] Extended value
        EDX     Field width             }

        OR      ECX,-1
        JMP     _Write2Ext
end;

procedure       _Write0Ext;
asm
{       PROCEDURE _Write0Ext( VAR t: Text; val: Extended);
      ->EAX     Pointer to file record
        [ESP+4] Extended value  }

        MOV     EDX,23  { field width   }
        OR      ECX,-1
        JMP     _Write2Ext
end;

procedure       _WriteLn;                       external;       {   WriteStr}

procedure       __CToPasStr;
asm
{     ->EAX     Pointer to destination  }
{       EDX     Pointer to source       }

        PUSH    EAX             { save destination      }

        MOV     CL,255
@@loop:
        MOV     CH,[EDX]        { ch = *src++;          }
        INC     EDX
        TEST    CH,CH   { if (ch == 0) break    }
        JE      @@endLoop
        INC     EAX             { *++dest = ch;         }
        MOV     [EAX],CH
        DEC     CL
        JNE     @@loop

@@endLoop:
        POP     EDX
        SUB     EAX,EDX
        MOV     [EDX],AL
end;

procedure       __CLenToPasStr;
asm
{     ->EAX     Pointer to destination  }
{       EDX     Pointer to source       }
{       ECX     cnt                     }

        PUSH    EBX
        PUSH    EAX             { save destination      }

        CMP     ECX,255
        JBE     @@loop
    MOV ECX,255
@@loop:
        MOV     BL,[EDX]        { ch = *src++;          }
        INC     EDX
        TEST    BL,BL   { if (ch == 0) break    }
        JE      @@endLoop
        INC     EAX             { *++dest = ch;         }
        MOV     [EAX],BL
        DEC     ECX             { while (--cnt != 0)    }
        JNZ     @@loop

@@endLoop:
        POP     EDX
        SUB     EAX,EDX
        MOV     [EDX],AL
        POP     EBX
end;

procedure       __ArrayToPasStr;
asm
{     ->EAX     Pointer to destination  }
{       EDX     Pointer to source       }
{       ECX     cnt                     }

        XCHG    EAX,EDX

        {       limit the length to 255 }

        CMP     ECX,255
    JBE     @@skip
    MOV     ECX,255
@@skip:
    MOV     [EDX],CL

        {       copy the source to destination + 1 }

        INC     EDX
        JMP     Move
end;


procedure       __PasToCStr;
asm
{     ->EAX     Pointer to source       }
{       EDX     Pointer to destination  }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ESI

        REP     MOVSB
        MOV     byte ptr [EDI],CL       { Append terminator: CL is zero here }

        POP     EDI
        POP     ESI
end;

procedure       _SetElem;
asm
        {       PROCEDURE _SetElem( VAR d: SET; elem, size: Byte);      }
        {       EAX     =       dest address                            }
        {       DL      =       element number                          }
        {       CL      =       size of set                                     }

        PUSH    EBX
        PUSH    EDI

        MOV     EDI,EAX

        XOR     EBX,EBX { zero extend set size into ebx }
        MOV     BL,CL
        MOV     ECX,EBX { and use it for the fill       }

        XOR     EAX,EAX { for zero fill                 }
        REP     STOSB

        SUB     EDI,EBX { point edi at beginning of set again   }

        INC     EAX             { eax is still zero - make it 1 }
        MOV     CL,DL
        ROL     AL,CL   { generate a mask               }
        SHR     ECX,3   { generate the index            }
        CMP     ECX,EBX { if index >= siz then exit     }
        JAE     @@exit
        OR      [EDI+ECX],AL{ set bit                   }

@@exit:
        POP     EDI
        POP     EBX
end;

procedure       _SetRange;
asm
{       PROCEDURE _SetRange( lo, hi, size: Byte; VAR d: SET );  }
{ ->AL  low limit of range      }
{       DL      high limit of range     }
{       ECX     Pointer to set          }
{       AH      size of set             }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        XOR     EBX,EBX { EBX = set size                }
        MOV     BL,AH
        MOVZX   ESI,AL  { ESI = low zero extended       }
        MOVZX   EDX,DL  { EDX = high zero extended      }
        MOV     EDI,ECX

{       clear the set                                   }

        MOV     ECX,EBX
        XOR     EAX,EAX
        REP     STOSB

{       prepare for setting the bits                    }

        SUB     EDI,EBX { point EDI at start of set     }
        SHL     EBX,3   { EBX = highest bit in set + 1  }
        CMP     EDX,EBX
        JB      @@inrange
        LEA     EDX,[EBX-1]     { ECX = highest bit in set      }

@@inrange:
        CMP     ESI,EDX { if lo > hi then exit;         }
        JA      @@exit

        DEC     EAX     { loMask = 0xff << (lo & 7)             }
        MOV     ECX,ESI
        AND     CL,07H
        SHL     AL,CL

        SHR     ESI,3   { loIndex = lo >> 3;            }

        MOV     CL,DL   { hiMask = 0xff >> (7 - (hi & 7));      }
        NOT     CL
        AND     CL,07
        SHR     AH,CL

        SHR     EDX,3   { hiIndex = hi >> 3;            }

        ADD     EDI,ESI { point EDI to set[loIndex]     }
        MOV     ECX,EDX
        SUB     ECX,ESI { if ((inxDiff = (hiIndex - loIndex)) == 0)     }
        JNE     @@else

        AND     AL,AH   { set[loIndex] = hiMask & loMask;       }
        MOV     [EDI],AL
        JMP     @@exit

@@else:
        STOSB           { set[loIndex++] = loMask;      }
        DEC     ECX
        MOV     AL,0FFH { while (loIndex < hiIndex)     }
        REP     STOSB   {   set[loIndex++] = 0xff;      }
        MOV     [EDI],AH        { set[hiIndex] = hiMask;        }

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _SetEq;
asm
{       FUNCTION _SetEq( CONST l, r: Set; size: Byte): ConditionCode;   }
{       EAX     =       left operand    }
{       EDX     =       right operand   }
{       CL      =       size of set     }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        AND     ECX,0FFH
        REP     CMPSB

        POP     EDI
        POP     ESI
end;

procedure       _SetLe;
asm
{       FUNCTION _SetLe( CONST l, r: Set; size: Byte): ConditionCode;   }
{       EAX     =       left operand            }
{       EDX     =       right operand           }
{       CL      =       size of set (>0 && <= 32)       }

@@loop:
        MOV     CH,[EDX]
        NOT     CH
        AND     CH,[EAX]
        JNE     @@exit
        INC     EDX
        INC     EAX
        DEC     CL
        JNZ     @@loop
@@exit:
end;

procedure       _SetIntersect;
asm
{       PROCEDURE _SetIntersect( VAR dest: Set; CONST src: Set; size: Byte);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       CL      =       size of set (0 < size <= 32)    }

@@loop:
        MOV     CH,[EDX]
        INC     EDX
        AND     [EAX],CH
        INC     EAX
        DEC     CL
        JNZ     @@loop
end;

procedure       _SetIntersect3;
asm
{       PROCEDURE _SetIntersect3( VAR dest: Set; CONST src: Set; size: Longint; src2: Set);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       ECX     =       size of set (0 < size <= 32)    }
{	[ESP+4]	=	2nd source operand		}

	PUSH	EBX
	PUSH	ESI
	MOV	ESI,[ESP+8+4]
@@loop:
        MOV     BL,[EDX+ECX-1]
	AND	BL,[ESI+ECX-1]
	MOV	[EAX+ECX-1],BL
        DEC     ECX
        JNZ     @@loop

	POP	ESI
	POP	EBX
end;

procedure       _SetUnion;
asm
{       PROCEDURE _SetUnion( VAR dest: Set; CONST src: Set; size: Byte);        }
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       CL      =       size of set (0 < size <= 32)    }

@@loop:
        MOV     CH,[EDX]
        INC     EDX
        OR      [EAX],CH
        INC     EAX
        DEC     CL
        JNZ     @@loop
end;

procedure       _SetUnion3;
asm
{       PROCEDURE _SetUnion3( VAR dest: Set; CONST src: Set; size: Longint; src2: Set);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       ECX     =       size of set (0 < size <= 32)    }
{	[ESP+4]	=	2nd source operand		}

	PUSH	EBX
	PUSH	ESI
	MOV	ESI,[ESP+8+4]
@@loop:
        MOV     BL,[EDX+ECX-1]
	OR	BL,[ESI+ECX-1]
	MOV	[EAX+ECX-1],BL
        DEC     ECX
        JNZ     @@loop

	POP	ESI
	POP	EBX
end;

procedure       _SetSub;
asm
{       PROCEDURE _SetSub( VAR dest: Set; CONST src: Set; size: Byte);  }
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       CL      =       size of set (0 < size <= 32)    }

@@loop:
        MOV     CH,[EDX]
        NOT     CH
        INC     EDX
        AND     [EAX],CH
        INC     EAX
        DEC     CL
        JNZ     @@loop
end;

procedure       _SetSub3;
asm
{       PROCEDURE _SetSub3( VAR dest: Set; CONST src: Set; size: Longint; src2: Set);}
{       EAX     =       destination operand             }
{       EDX     =       source operand                  }
{       ECX     =       size of set (0 < size <= 32)    }
{	[ESP+4]	=	2nd source operand		}

	PUSH	EBX
	PUSH	ESI
	MOV	ESI,[ESP+8+4]
@@loop:
	MOV	BL,[ESI+ECX-1]
	NOT	BL
        AND     BL,[EDX+ECX-1]
	MOV	[EAX+ECX-1],BL
        DEC     ECX
        JNZ     @@loop

	POP	ESI
	POP	EBX
end;

procedure       _SetExpand;
asm
{       PROCEDURE _SetExpand( CONST src: Set; VAR dest: Set; lo, hi: Byte);     }
{     ->EAX     Pointer to source (packed set)          }
{       EDX     Pointer to destination (expanded set)   }
{       CH      high byte of source                     }
{       CL      low byte of source                      }

{       algorithm:              }
{       clear low bytes         }
{       copy high-low+1 bytes   }
{       clear 31-high bytes     }

        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        MOV     EDX,ECX { save low, high in dl, dh      }
        XOR     ECX,ECX
        XOR     EAX,EAX

        MOV     CL,DL   { clear low bytes               }
        REP     STOSB

        MOV     CL,DH   { copy high - low bytes }
        SUB     CL,DL
        REP     MOVSB

        MOV     CL,32   { copy 32 - high bytes  }
        SUB     CL,DH
        REP     STOSB

        POP     EDI
        POP     ESI
end;

procedure       _Str2Ext;                       external;       {$L StrExt  }
procedure       _Str0Ext;                       external;       {   StrExt  }
procedure       _Str1Ext;                       external;       {   StrExt  }

procedure       _ValExt;                        external;       {$L ValExt  }

procedure       _Pow10;                         external;       {$L Pow10   }
procedure       FPower10;                       external;       {   Pow10   }
procedure       _Real2Ext;                      external;       {$L Real2Ext}
procedure       _Ext2Real;                      external;       {$L Ext2Real}

const
        ovtInstanceSize = -8;   { Offset of instance size in OBJECTs    }
        ovtVmtPtrOffs   = -4;

procedure       _ObjSetup;
asm
{       FUNCTION _ObjSetup( self: ^OBJECT; vmt: ^VMT): ^OBJECT; }
{     ->EAX     Pointer to self (possibly nil)  }
{       EDX     Pointer to vmt  (possibly nil)  }
{     <-EAX     Pointer to self                 }
{       EDX     <> 0: an object was allocated   }
{       Z-Flag  Set: failure, Cleared: Success  }

        CMP     EDX,1   { is vmt = 0, indicating a call         }
        JAE     @@skip1 { from a constructor?                   }
        RET                     { return immediately with Z-flag cleared        }

@@skip1:
        PUSH    ECX
        TEST    EAX,EAX { is self already allocated?            }
        JNE     @@noAlloc
        MOV     EAX,[EDX].ovtInstanceSize
        TEST    EAX,EAX
        JE      @@zeroSize
        PUSH    EDX
        CALL    MemoryManager.GetMem
        POP     EDX
        TEST    EAX,EAX
        JZ      @@fail

        {       Zero fill the memory }
        PUSH    EDI
        MOV     ECX,[EDX].ovtInstanceSize
        MOV     EDI,EAX
        PUSH    EAX
        XOR     EAX,EAX
        SHR     ECX,2
        REP     STOSD
        MOV     ECX,[EDX].ovtInstanceSize
        AND     ECX,3
        REP     STOSB
        POP     EAX
        POP     EDI

        MOV     ECX,[EDX].ovtVmtPtrOffs
        TEST    ECX,ECX
        JL      @@skip
        MOV     [EAX+ECX],EDX   { store vmt in object at this offset    }
@@skip:
        TEST    EAX,EAX { clear zero flag                               }
        POP     ECX
        RET

@@fail:
        XOR     EDX,EDX
        POP     ECX
        RET

@@zeroSize:
        XOR     EDX,EDX
        CMP     EAX,1   { clear zero flag - we were successful (kind of) }
        POP     ECX
        RET

@@noAlloc:
        MOV     ECX,[EDX].ovtVmtPtrOffs
        TEST    ECX,ECX
        JL      @@exit
        MOV     [EAX+ECX],EDX   { store vmt in object at this offset    }
@@exit:
        XOR     EDX,EDX { clear allocated flag                  }
        TEST    EAX,EAX { clear zero flag                               }
        POP     ECX
end;

procedure       _ObjCopy;
asm
{       PROCEDURE _ObjCopy( dest, src: ^OBJECT; vmtPtrOff: Longint);    }
{     ->EAX     Pointer to destination          }
{       EDX     Pointer to source               }
{       ECX     Offset of vmt in those objects. }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EDX
        MOV     EDI,EAX

        LEA     EAX,[EDI+ECX]   { remember pointer to dest vmt pointer  }
        MOV     EDX,[EAX]       { fetch dest vmt pointer        }

        MOV     EBX,[EDX].ovtInstanceSize

        MOV     ECX,EBX { copy size DIV 4 dwords        }
        SHR     ECX,2
        REP     MOVSD

        MOV     ECX,EBX { copy size MOD 4 bytes }
        AND     ECX,3
        REP     MOVSB

        MOV     [EAX],EDX       { restore dest vmt              }

        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure       _Fail;
asm
{       FUNCTION _Fail( self: ^OBJECT; allocFlag:Longint): ^OBJECT;     }
{     ->EAX     Pointer to self (possibly nil)  }
{       EDX     <> 0: Object must be deallocated        }
{     <-EAX     Nil                                     }

        TEST    EDX,EDX
        JE      @@exit  { if no object was allocated, return    }
        CALL    _FreeMem
@@exit:
        XOR     EAX,EAX
end;

function GetKeyboardType(nTypeFlag: Integer): Integer; stdcall;
  external user name 'GetKeyboardType';

function _isNECWindows: Boolean;
var
  KbSubType: Integer;
begin
  Result := False;
  if GetKeyboardType(0) = $7 then
  begin
    KbSubType := GetKeyboardType(1) and $FF00;
    if (KbSubType = $0D00) or (KbSubType = $0400) then
      Result := True;
  end;
end;

procedure _FpuMaskInit;
const
  HKEY_LOCAL_MACHINE = $80000002;
  KEY_QUERY_VALUE    = $00000001;
  REG_DWORD          = 4;
  FPUMASKKEY  = 'SOFTWARE\Borland\Delphi\RTL';
  FPUMASKNAME = 'FPUMaskValue';
var
  phkResult: LongWord;
  lpData, DataSize: Longint;
begin
  lpData := Default8087CW;

  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, FPUMASKKEY, 0, KEY_QUERY_VALUE, phkResult) = 0 then
  try
    DataSize := Sizeof(lpData);
    RegQueryValueEx(phkResult, FPUMASKNAME, nil,  nil, @lpData, @DataSize);
  finally
    RegCloseKey(phkResult);
  end;

  Default8087CW := (Default8087CW and $ffc0) or (lpData and $3f);
end;

procedure       FpuInit;
//const cwDefault: Word = $1332 { $133F};
asm
        FNINIT
        FWAIT
        FLDCW   Default8087CW
end;

procedure FpuInitConsiderNECWindows;
begin
  if _isNECWindows then _FpuMaskInit;
  FpuInit();
end;

procedure       _BoundErr;
asm
        MOV     AL,reRangeError
        JMP     Error
end;

procedure       _IntOver;
asm
        MOV     AL,reIntOverflow
        JMP     Error
end;

function TObject.ClassType: TClass;
asm
        mov     eax,[eax]
end;

class function TObject.ClassName: ShortString;
asm
        { ->    EAX VMT                         }
        {       EDX Pointer to result string    }
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EDX
        MOV     ESI,[EAX].vmtClassName
        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ECX
        REP     MOVSB
        POP     EDI
        POP     ESI
end;

class function TObject.ClassNameIs(const Name: string): Boolean;
asm
        PUSH    EBX
        XOR     EBX,EBX
        OR      EDX,EDX
        JE      @@exit
        MOV     EAX,[EAX].vmtClassName
        XOR     ECX,ECX
        MOV     CL,[EAX]
        CMP     ECX,[EDX-4]
        JNE     @@exit
        DEC     EDX
@@loop:
        MOV     BH,[EAX+ECX]
        XOR     BH,[EDX+ECX]
        AND     BH,0DFH
        JNE     @@exit
        DEC     ECX
        JNE     @@loop
        INC     EBX
@@exit:
        MOV     AL,BL
        POP     EBX
end;

class function TObject.ClassParent: TClass;
asm
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JE      @@exit
        MOV     EAX,[EAX]
@@exit:
end;

class function TObject.NewInstance: TObject;
asm
        PUSH    EAX
        MOV     EAX,[EAX].vmtInstanceSize
        CALL    _GetMem
        MOV     EDX,EAX
        POP     EAX
        JMP     TObject.InitInstance
end;

procedure TObject.FreeInstance;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EAX
@@loop:
        MOV     ESI,[ESI]
        MOV     EDX,[ESI].vmtInitTable
        MOV     ESI,[ESI].vmtParent
        TEST    EDX,EDX
        JE      @@skip
        CALL    _FinalizeRecord
        MOV     EAX,EBX
@@skip:
        TEST    ESI,ESI
        JNE     @@loop

        CALL    _FreeMem
        POP     ESI
        POP     EBX
end;

class function TObject.InstanceSize: Longint;
asm
        MOV     EAX,[EAX].vmtInstanceSize
end;

constructor TObject.Create;
begin
end;

destructor TObject.Destroy;
begin
end;

procedure TObject.Free;
asm
        TEST    EAX,EAX
        JE      @@exit
        MOV     ECX,[EAX]
        MOV     DL,1
        CALL    dword ptr [ECX].vmtDestroy
@@exit:
end;

class function TObject.InitInstance(Instance: Pointer): TObject;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     EDI,EDX
        STOSD
        MOV     ECX,[EBX].vmtInstanceSize
        XOR     EAX,EAX
        PUSH    ECX
        SHR     ECX,2
        DEC     ECX
        REP     STOSD
        POP     ECX
        AND     ECX,3
        REP     STOSB
        MOV     EAX,EDX
        MOV     EDX,ESP
@@0:    MOV     ECX,[EBX].vmtIntfTable
        TEST    ECX,ECX
        JE      @@1
        PUSH    ECX
@@1:    MOV     EBX,[EBX].vmtParent
        TEST    EBX,EBX
        JE      @@2
        MOV     EBX,[EBX]
        JMP     @@0
@@2:    CMP     ESP,EDX
        JE      @@5
@@3:    POP     EBX
        MOV     ECX,[EBX].TInterfaceTable.EntryCount
        ADD     EBX,4
@@4:    MOV     ESI,[EBX].TInterfaceEntry.VTable
        TEST    ESI,ESI
        JE      @@4a
        MOV     EDI,[EBX].TInterfaceEntry.IOffset
        MOV     [EAX+EDI],ESI
@@4a:   ADD     EBX,TYPE TInterfaceEntry
        DEC     ECX
        JNE     @@4
        CMP     ESP,EDX
        JNE     @@3
@@5:    POP     EDI
        POP     ESI
        POP     EBX
end;

procedure TObject.CleanupInstance;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EAX
@@loop:
        MOV     ESI,[ESI]
        MOV     EDX,[ESI].vmtInitTable
        MOV     ESI,[ESI].vmtParent
        TEST    EDX,EDX
        JE      @@skip
        CALL    _FinalizeRecord
        MOV     EAX,EBX
@@skip:
        TEST    ESI,ESI
        JNE     @@loop

        POP     ESI
        POP     EBX
end;

function InvokeImplGetter(Self: TObject; ImplGetter: Integer): IUnknown;
asm
        XCHG    EDX,ECX
        CMP     ECX,$FF000000
        JAE     @@isField
        CMP     ECX,$FE000000
        JB      @@isStaticMethod

        {       the GetProc is a virtual method }
        MOVSX   ECX,CX                  { sign extend slot offs }
        ADD     ECX,[EAX]               { vmt   + slotoffs      }
        JMP     dword ptr [ECX]         { call vmt[slot]        }

@@isStaticMethod:
        JMP     ECX

@@isField:
        AND     ECX,$00FFFFFF
        ADD     ECX,EAX
        MOV     EAX,EDX
        MOV     EDX,[ECX]
        JMP     _IntfCopy
end;

function TObject.GetInterface(const IID: TGUID; out Obj): Boolean;
var
  InterfaceEntry: PInterfaceEntry;
begin
  InterfaceEntry := GetInterfaceEntry(IID);
  if InterfaceEntry <> nil then
  begin
    if InterfaceEntry^.IOffset <> 0 then
      Pointer(Obj) := Pointer(Integer(Self) + InterfaceEntry^.IOffset)
    else
      IUnknown(Obj) := InvokeImplGetter(Self, InterfaceEntry^.ImplGetter);
    if Pointer(Obj) <> nil then
    begin
      if InterfaceEntry^.IOffset <> 0 then IUnknown(Obj)._AddRef;
      Result := True;
    end
    else
      Result := False;
  end else
  begin
    Pointer(Obj) := nil;
    Result := False;
  end;
end;

class function TObject.GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
@@1:    MOV     EAX,[EBX].vmtIntfTable
        TEST    EAX,EAX
        JE      @@4
        MOV     ECX,[EAX].TInterfaceTable.EntryCount
        ADD     EAX,4
@@2:    MOV     ESI,[EDX].Integer[0]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[0]
        JNE     @@3
        MOV     ESI,[EDX].Integer[4]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[4]
        JNE     @@3
        MOV     ESI,[EDX].Integer[8]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[8]
        JNE     @@3
        MOV     ESI,[EDX].Integer[12]
        CMP     ESI,[EAX].TInterfaceEntry.IID.Integer[12]
        JE      @@5
@@3:    ADD     EAX,type TInterfaceEntry
        DEC     ECX
        JNE     @@2
@@4:    MOV     EBX,[EBX].vmtParent
        TEST    EBX,EBX
        JE      @@4a
        MOV     EBX,[EBX]
        JMP     @@1
@@4a:   XOR     EAX,EAX
@@5:    POP     ESI
        POP     EBX
end;

class function TObject.GetInterfaceTable: PInterfaceTable;
asm
        MOV     EAX,[EAX].vmtIntfTable
end;


procedure       _IsClass;
asm
        { ->    EAX     left operand (class)    }
        {       EDX VMT of right operand        }
        { <-    AL      left is derived from right      }
        TEST    EAX,EAX
        JE      @@exit
@@loop:
        MOV     EAX,[EAX]
        CMP     EAX,EDX
        JE      @@success
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JNE     @@loop
        JMP     @@exit
@@success:
        MOV     AL,1
@@exit:
end;


procedure       _AsClass;
asm
        { ->    EAX     left operand (class)    }
        {       EDX VMT of right operand        }
        { <-    EAX      if left is derived from right, else runtime error      }
        TEST    EAX,EAX
        JE      @@exit
        MOV     ECX,EAX
@@loop:
        MOV     ECX,[ECX]
        CMP     ECX,EDX
        JE      @@exit
        MOV     ECX,[ECX].vmtParent
        TEST    ECX,ECX
        JNE     @@loop

        {       do runtime error        }
        MOV     AL,reInvalidCast
        JMP     Error

@@exit:
end;


procedure       GetDynaMethod;
{       function        GetDynaMethod(vmt: TClass; selector: Smallint) : Pointer;       }
asm
        { ->    EAX     vmt of class            }
        {       BX      dynamic method index    }
        { <-    EBX pointer to routine  }
        {       ZF = 0 if found         }
        {       trashes: EAX, ECX               }

        PUSH    EDI
        XCHG    EAX,EBX
        JMP     @@haveVMT
@@outerLoop:
        MOV     EBX,[EBX]
@@haveVMT:
        MOV     EDI,[EBX].vmtDynamicTable
        TEST    EDI,EDI
        JE      @@parent
        MOVZX   ECX,word ptr [EDI]
        PUSH    ECX
        ADD     EDI,2
        REPNE   SCASW
        JE      @@found
        POP     ECX
@@parent:
        MOV     EBX,[EBX].vmtParent
        TEST    EBX,EBX
        JNE     @@outerLoop
        JMP     @@exit

@@found:
        POP     EAX
        ADD     EAX,EAX
        SUB     EAX,ECX         { this will always clear the Z-flag ! }
        MOV     EBX,[EDI+EAX*2-4]

@@exit:
        POP     EDI
end;

procedure       _CallDynaInst;
asm
        PUSH    EAX
        PUSH    ECX
        MOV     EAX,[EAX]
        CALL    GetDynaMethod
        POP     ECX
        POP     EAX
        JE      @@Abstract
        JMP     EBX
@@Abstract:
        POP     ECX
        JMP     _AbstractError
end;


procedure       _CallDynaClass;
asm
        PUSH    EAX
        PUSH    ECX
        CALL    GetDynaMethod
        POP     ECX
        POP     EAX
        JE      @@Abstract
        JMP     EBX
@@Abstract:
        POP     ECX
        JMP     _AbstractError
end;


procedure       _FindDynaInst;
asm
        PUSH    EBX
        MOV     EBX,EDX
        MOV     EAX,[EAX]
        CALL    GetDynaMethod
        MOV     EAX,EBX
        POP     EBX
        JNE     @@exit
        POP     ECX
        JMP     _AbstractError
@@exit:
end;


procedure       _FindDynaClass;
asm
        PUSH    EBX
        MOV     EBX,EDX
        CALL    GetDynaMethod
        MOV     EAX,EBX
        POP     EBX
        JNE     @@exit
        POP     ECX
        JMP     _AbstractError
@@exit:
end;


class function TObject.InheritsFrom(AClass: TClass): Boolean;
asm
        { ->    EAX     Pointer to our class    }
        {       EDX     Pointer to AClass               }
        { <-    AL      Boolean result          }
        JMP     @@haveVMT
@@loop:
        MOV     EAX,[EAX]
@@haveVMT:
        CMP     EAX,EDX
        JE      @@success
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JNE     @@loop
        JMP     @@exit
@@success:
        MOV     AL,1
@@exit:
end;


class function TObject.ClassInfo: Pointer;
asm
        MOV     EAX,[EAX].vmtTypeInfo
end;


function TObject.SafeCallException(ExceptObject: TObject;
  ExceptAddr: Pointer): HResult;
begin
  Result := HResult($8000FFFF); { E_UNEXPECTED }
end;


procedure TObject.DefaultHandler(var Message);
begin
end;


procedure TObject.AfterConstruction;
begin
end;

procedure TObject.BeforeDestruction;
begin
end;

procedure TObject.Dispatch(var Message);
asm
        PUSH    EBX
        MOV     BX,[EDX]
        OR      BX,BX
        JE      @@default
        CMP     BX,0C000H
        JAE     @@default
        PUSH    EAX
        MOV     EAX,[EAX]
        CALL    GetDynaMethod
        POP     EAX
        JE      @@default
        MOV     ECX,EBX
        POP     EBX
        JMP     ECX

@@default:
        POP     EBX
        MOV     ECX,[EAX]
        JMP     dword ptr [ECX].vmtDefaultHandler
end;


class function TObject.MethodAddress(const Name: ShortString): Pointer;
asm
        { ->    EAX     Pointer to class        }
        {       EDX     Pointer to name }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        XOR     ECX,ECX
        XOR     EDI,EDI
        MOV     BL,[EDX]
        JMP     @@haveVMT
@@outer:                                { upper 16 bits of ECX are 0 !  }
        MOV     EAX,[EAX]
@@haveVMT:
        MOV     ESI,[EAX].vmtMethodTable
        TEST    ESI,ESI
        JE      @@parent
        MOV     DI,[ESI]                { EDI := method count           }
        ADD     ESI,2
@@inner:                                { upper 16 bits of ECX are 0 !  }
        MOV     CL,[ESI+6]              { compare length of strings     }
        CMP     CL,BL
        JE      @@cmpChar
@@cont:                                 { upper 16 bits of ECX are 0 !  }
        MOV     CX,[ESI]                { fetch length of method desc   }
        ADD     ESI,ECX                 { point ESI to next method      }
        DEC     EDI
        JNZ     @@inner
@@parent:
        MOV     EAX,[EAX].vmtParent     { fetch parent vmt              }
        TEST    EAX,EAX
        JNE     @@outer
        JMP     @@exit                  { return NIL                    }

@@notEqual:
        MOV     BL,[EDX]                { restore BL to length of name  }
        JMP     @@cont

@@cmpChar:                              { upper 16 bits of ECX are 0 !  }
        MOV     CH,0                    { upper 24 bits of ECX are 0 !  }
@@cmpCharLoop:
        MOV     BL,[ESI+ECX+6]          { case insensitive string cmp   }
        XOR     BL,[EDX+ECX+0]          { last char is compared first   }
        AND     BL,$DF
        JNE     @@notEqual
        DEC     ECX                     { ECX serves as counter         }
        JNZ     @@cmpCharLoop

        { found it }
        MOV     EAX,[ESI+2]

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


class function TObject.MethodName(Address: Pointer): ShortString;
asm
        { ->    EAX     Pointer to class        }
        {       EDX     Address         }
        {       ECX Pointer to result   }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,ECX
        XOR     EBX,EBX
        XOR     ECX,ECX
        JMP     @@haveVMT
@@outer:
        MOV     EAX,[EAX]
@@haveVMT:
        MOV     ESI,[EAX].vmtMethodTable { fetch pointer to method table }
        TEST    ESI,ESI
        JE      @@parent
        MOV     CX,[ESI]
        ADD     ESI,2
@@inner:
        CMP     EDX,[ESI+2]
        JE      @@found
        MOV     BX,[ESI]
        ADD     ESI,EBX
        DEC     ECX
        JNZ     @@inner
@@parent:
        MOV     EAX,[EAX].vmtParent
        TEST    EAX,EAX
        JNE     @@outer
        MOV     [EDI],AL
        JMP     @@exit

@@found:
        ADD     ESI,6
        XOR     ECX,ECX
        MOV     CL,[ESI]
        INC     ECX
        REP     MOVSB

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


function TObject.FieldAddress(const Name: ShortString): Pointer;
asm
        { ->    EAX     Pointer to instance     }
        {       EDX     Pointer to name }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        XOR     ECX,ECX
        XOR     EDI,EDI
        MOV     BL,[EDX]

        PUSH    EAX                     { save instance pointer         }

@@outer:
        MOV     EAX,[EAX]               { fetch class pointer           }
        MOV     ESI,[EAX].vmtFieldTable
        TEST    ESI,ESI
        JE      @@parent
        MOV     DI,[ESI]                { fetch count of fields         }
        ADD     ESI,6
@@inner:
        MOV     CL,[ESI+6]              { compare string lengths        }
        CMP     CL,BL
        JE      @@cmpChar
@@cont:
        LEA     ESI,[ESI+ECX+7] { point ESI to next field       }
        DEC     EDI
        JNZ     @@inner
@@parent:
        MOV     EAX,[EAX].vmtParent     { fetch parent VMT              }
        TEST    EAX,EAX
        JNE     @@outer
        POP     EDX                     { forget instance, return Nil   }
        JMP     @@exit

@@notEqual:
        MOV     BL,[EDX]                { restore BL to length of name  }
        MOV     CL,[ESI+6]              { ECX := length of field name   }
        JMP     @@cont

@@cmpChar:
        MOV     BL,[ESI+ECX+6]  { case insensitive string cmp   }
        XOR     BL,[EDX+ECX+0]  { starting with last char       }
        AND     BL,$DF
        JNE     @@notEqual
        DEC     ECX                     { ECX serves as counter         }
        JNZ     @@cmpChar

        { found it }
        MOV     EAX,[ESI]           { result is field offset plus ...   }
        POP     EDX
        ADD     EAX,EDX         { instance pointer              }

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


const { copied from xx.h }
  cContinuable        = 0;
  cNonContinuable     = 1;
  cUnwinding          = 2;
  cUnwindingForExit   = 4;
  cUnwindInProgress   = cUnwinding or cUnwindingForExit;
  cDelphiException    = $0EEDFADE;
  cDelphiReRaise      = $0EEDFADF;
  cDelphiExcept       = $0EEDFAE0;
  cDelphiFinally      = $0EEDFAE1;
  cDelphiTerminate    = $0EEDFAE2;
  cDelphiUnhandled    = $0EEDFAE3;
  cNonDelphiException = $0EEDFAE4;
  cDelphiExitFinally  = $0EEDFAE5;
  cCppException       = $0EEFFACE; { used by BCB }
  EXCEPTION_CONTINUE_SEARCH    = 0;
  EXCEPTION_EXECUTE_HANDLER    = 1;
  EXCEPTION_CONTINUE_EXECUTION = -1;

type
  JmpInstruction =
  packed record
    opCode:   Byte;
    distance: Longint;
  end;
  TExcDescEntry =
  record
    vTable:  Pointer;
    handler: Pointer;
  end;
  PExcDesc = ^TExcDesc;
  TExcDesc =
  packed record
    jmp: JmpInstruction;
    case Integer of
    0:      (instructions: array [0..0] of Byte);
    1{...}: (cnt: Integer; excTab: array [0..0{cnt-1}] of TExcDescEntry);
  end;

  PExcFrame = ^TExcFrame;
  TExcFrame =
  record
    next: PExcFrame;
    desc: PExcDesc;
    hEBP: Pointer;
    case Integer of
    0:  ( );
    1:  ( ConstructedObject: Pointer );
    2:  ( SelfOfMethod: Pointer );
  end;

  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord =
  record
    ExceptionCode        : LongWord;
    ExceptionFlags       : LongWord;
    OuterException       : PExceptionRecord;
    ExceptionAddress     : Pointer;
    NumberParameters     : Longint;
    case {IsOsException:} Boolean of
    True:  (ExceptionInformation : array [0..14] of Longint);
    False: (ExceptAddr: Pointer; ExceptObject: Pointer);
  end;

  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = packed record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;


procedure       _ClassCreate;
asm
        { ->    EAX = pointer to VMT      }
        { <-    EAX = pointer to instance }
        PUSH    EDX
        PUSH    ECX
        PUSH    EBX
        TEST    DL,DL
        JL      @@noAlloc
        CALL    dword ptr [EAX].vmtNewInstance
@@noAlloc:
        XOR     EDX,EDX
        LEA     ECX,[ESP+16]
        MOV     EBX,FS:[EDX]
        MOV     [ECX].TExcFrame.next,EBX
        MOV     [ECX].TExcFrame.hEBP,EBP
        MOV     [ECX].TExcFrame.desc,offset @desc
        MOV     [ECX].TexcFrame.ConstructedObject,EAX   { trick: remember copy to instance }
        MOV     FS:[EDX],ECX
        POP     EBX
        POP     ECX
        POP     EDX
        RET

@desc:
        JMP     _HandleAnyException

        {       destroy the object                                                      }

        MOV     EAX,[ESP+8+9*4]
        MOV     EAX,[EAX].TExcFrame.ConstructedObject
        TEST    EAX,EAX
        JE      @@skip
        MOV     ECX,[EAX]
        MOV     DL,$81
        PUSH    EAX
        CALL    dword ptr [ECX].vmtDestroy
        POP     EAX
        CALL    _ClassDestroy
@@skip:
        {       reraise the exception   }
        CALL    _RaiseAgain
end;


procedure       _ClassDestroy;
asm
        MOV     EDX,[EAX]
        CALL    dword ptr [EDX].vmtFreeInstance
end;


procedure _AfterConstruction;
asm
        { ->  EAX = pointer to instance }

        PUSH    EAX
        MOV     EDX,[EAX]
        CALL    dword ptr [EDX].vmtAfterConstruction
        POP     EAX
end;

procedure _BeforeDestruction;
asm
        { ->  EAX  = pointer to instance }
        {      DL  = dealloc flag        }

        TEST    DL,DL
        JG      @@outerMost
        RET
@@outerMost:
        PUSH    EAX
        PUSH    EDX
        MOV     EDX,[EAX]
        CALL    dword ptr [EDX].vmtBeforeDestruction
        POP     EDX
        POP     EAX
end;

{
  The following NotifyXXXX routines are used to "raise" special exceptions
  as a signaling mechanism to an interested debugger.  If the debugger sets
  the DebugHook flag to 1 or 2, then all exception processing is tracked by
  raising these special exceptions.  The debugger *MUST* respond to the
  debug event with DBG_CONTINE so that normal processing will occur.
}

{ tell the debugger that the next raise is a re-raise of the current non-Delphi
  exception }
procedure       NotifyReRaise;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    0
        PUSH    0
        PUSH    cContinuable
        PUSH    cDelphiReRaise
        CALL    RaiseException
@@1:
end;

{ tell the debugger about the raise of a non-Delphi exception }
procedure       NotifyNonDelphiException;
asm
        CMP     BYTE PTR DebugHook,0
        JE      @@1
        PUSH    EAX
        PUSH    EAX
        PUSH    EDX
        PUSH    ESP
        PUSH    2
        PUSH    cContinuable
        PUSH    cNonDelphiException
        CALL    RaiseException
        ADD     ESP,8
        POP     EAX
@@1:
end;

{ Tell the debugger where the handler for the current exception is located }
procedure       NotifyExcept;
asm
        PUSH    ESP
        PUSH    1
        PUSH    cContinuable
        PUSH    cDelphiExcept           { our magic exception code }
        CALL    RaiseException
        ADD     ESP,4
        POP     EAX
end;

procedure       NotifyOnExcept;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EAX
        PUSH    [EBX].TExcDescEntry.handler
        JMP     NotifyExcept
@@1:
end;

procedure       NotifyAnyExcept;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EAX
        PUSH    EBX
        JMP     NotifyExcept
@@1:
end;

procedure       CheckJmp;
asm
        TEST    ECX,ECX
        JE      @@3
        MOV     EAX,[ECX + 1]
        CMP     BYTE PTR [ECX],0E9H { near jmp }
        JE      @@1
        CMP     BYTE PTR [ECX],0EBH { short jmp }
        JNE     @@3
        MOVSX   EAX,AL
        INC     ECX
        INC     ECX
        JMP     @@2
@@1:
        ADD     ECX,5
@@2:
        ADD     ECX,EAX
@@3:
end;

{ Notify debugger of a finally during an exception unwind }
procedure       NotifyExceptFinally;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EAX
        PUSH    EDX
        PUSH    ECX
        CALL    CheckJmp
        PUSH    ECX
        PUSH    ESP                     { pass pointer to arguments }
        PUSH    1                       { there is 1 argument }
        PUSH    cContinuable            { continuable execution }
        PUSH    cDelphiFinally          { our magic exception code }
        CALL    RaiseException
        POP     ECX
        POP     ECX
        POP     EDX
        POP     EAX
@@1:
end;


{ Tell the debugger that the current exception is handled and cleaned up.
  Also indicate where execution is about to resume. }
procedure       NotifyTerminate;
asm
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    EDX
        PUSH    ESP
        PUSH    1
        PUSH    cContinuable
        PUSH    cDelphiTerminate        { our magic exception code }
        CALL    RaiseException
        POP     EDX
@@1:
end;

{ Tell the debugger that there was no handler found for the current execption
  and we are about to go to the default handler }
procedure       NotifyUnhandled;
asm
        PUSH    EAX
        PUSH    EDX
        CMP     BYTE PTR DebugHook,1
        JBE     @@1
        PUSH    ESP
        PUSH    2
        PUSH    cContinuable
        PUSH    cDelphiUnhandled
        CALL    RaiseException
@@1:
        POP     EDX
        POP     EAX
end;


procedure       _HandleAnyException;
asm
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one   }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        JE      @@DelphiException
        CLD
        CALL    FpuInit
        MOV     EDX,ExceptObjProc
        TEST    EDX,EDX
        JE      @@exit
        CALL    EDX
        TEST    EAX,EAX
        JE      @@exit
        MOV     EDX,[ESP+12]
        MOV     ECX,[ESP+4]
        CMP     [ECX].TExceptionRecord.ExceptionCode,cCppException
        JE      @@CppException
        CALL    NotifyNonDelphiException
        CMP     BYTE PTR JITEnable,0
        JBE     @@CppException
        CMP     BYTE PTR DebugHook,0
        JA      @@CppException                     { Do not JIT if debugging }
        LEA     ECX,[ESP+4]
        PUSH    EAX
        PUSH    ECX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     EAX
        JE      @@exit
        MOV     EDX,EAX
        MOV     EAX,[ESP+4]
        MOV     ECX,[EAX].TExceptionRecord.ExceptionAddress
        JMP     @@GoUnwind

@@CppException:
        MOV     EDX,EAX
        MOV     EAX,[ESP+4]
        MOV     ECX,[EAX].TExceptionRecord.ExceptionAddress

@@DelphiException:
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0                { Do not JIT if debugging }
        JA      @@GoUnwind
        PUSH    EAX
        LEA     EAX,[ESP+8]
        PUSH    EDX
        PUSH    ECX
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     ECX
        POP     EDX
        POP     EAX
        JE      @@exit

@@GoUnwind:
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    EBX
        XOR     EBX,EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,FS:[EBX]
        PUSH    EBX                     { Save pointer to topmost frame }
        PUSH    EAX                     { Save OS exception pointer     }
        PUSH    EDX                     { Save exception object         }
        PUSH    ECX                     { Save exception address        }

        MOV     EDX,[ESP+8+8*4]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwind
@@returnAddress:

        MOV     EDI,[ESP+8+8*4]

        {       Make the RaiseList entry on the stack }

        CALL    SysInit.@GetTLS
        PUSH    [EAX].RaiseListPtr
        MOV     [EAX].RaiseListPtr,ESP

        MOV     EBP,[EDI].TExcFrame.hEBP
        MOV     EBX,[EDI].TExcFrame.desc
        MOV     [EDI].TExcFrame.desc,offset @@exceptFinally

        ADD     EBX,TExcDesc.instructions
        CALL    NotifyAnyExcept
        JMP     EBX

@@exceptFinally:
        JMP     _HandleFinally

@@destroyExcept:
        {       we come here if an exception handler has thrown yet another exception }
        {       we need to destroy the exception object and pop the raise list. }

        CALL    SysInit.@GetTLS
        MOV     ECX,[EAX].RaiseListPtr
        MOV     EDX,[ECX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,EDX

        MOV     EAX,[ECX].TRaiseFrame.ExceptObject
        JMP     TObject.Free

@@exit:
        MOV     EAX,1
end;


procedure       _HandleOnException;
asm
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one   }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JE      @@DelphiException
        CLD
        CALL    FpuInit
        MOV     EDX,ExceptClsProc
        TEST    EDX,EDX
        JE      @@exit
        CALL    EDX
        TEST    EAX,EAX
        JNE     @@common
        JMP     @@exit

@@DelphiException:
        MOV     EAX,[EAX].TExceptionRecord.ExceptObject
        MOV     EAX,[EAX]                       { load vtable of exception object       }

@@common:

        MOV     EDX,[ESP+8]

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     ECX,[EDX].TExcFrame.desc
        MOV     EBX,[ECX].TExcDesc.cnt
        LEA     ESI,[ECX].TExcDesc.excTab       { point ECX to exc descriptor table }
        MOV     EBP,EAX                         { load vtable of exception object }

@@innerLoop:
        MOV     EAX,[ESI].TExcDescEntry.vTable
        TEST    EAX,EAX                         { catch all clause?                     }
        JE      @@doHandler                     { yes: go execute handler               }
        MOV     EDI,EBP                         { load vtable of exception object       }
        JMP     @@haveVMT

@@vtLoop:
        MOV     EDI,[EDI]
@@haveVMT:
        MOV     EAX,[EAX]
        CMP     EAX,EDI
        JE      @@doHandler

        MOV     ECX,[EAX].vmtInstanceSize
        CMP     ECX,[EDI].vmtInstanceSize
        JNE     @@parent

        MOV     EAX,[EAX].vmtClassName
        MOV     EDX,[EDI].vmtClassName

        XOR     ECX,ECX
        MOV     CL,[EAX]
        CMP     CL,[EDX]
        JNE     @@parent

        INC     EAX
        INC     EDX
        CALL    _AStrCmp
        JE      @@doHandler

@@parent:
        MOV     EDI,[EDI].vmtParent             { load vtable of parent         }
        MOV     EAX,[ESI].TExcDescEntry.vTable
        TEST    EDI,EDI
        JNE     @@vtLoop

        ADD     ESI,8
        DEC     EBX
        JNZ     @@innerLoop

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     @@exit

@@doHandler:
        MOV     EAX,[ESP+4+4*4]
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        JE      @@haveObject
        CALL    ExceptObjProc
        MOV     EDX,[ESP+12+4*4]
        CALL    NotifyNonDelphiException
        CMP     BYTE PTR JITEnable,0
        JBE     @@NoJIT
        CMP     BYTE PTR DebugHook,0
        JA      @@noJIT                 { Do not JIT if debugging }
        LEA     ECX,[ESP+4]
        PUSH    EAX
        PUSH    ECX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     EAX
        JE      @@exit
@@noJIT:
        MOV     EDX,EAX
        MOV     EAX,[ESP+4+4*4]
        MOV     ECX,[EAX].TExceptionRecord.ExceptionAddress
        JMP     @@GoUnwind

@@haveObject:
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0
        JA      @@GoUnwind
        PUSH    EAX
        LEA     EAX,[ESP+8]
        PUSH    EDX
        PUSH    ECX
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        POP     ECX
        POP     EDX
        POP     EAX
        JE      @@exit

@@GoUnwind:
        XOR     EBX,EBX
        MOV     EBX,FS:[EBX]
        PUSH    EBX                     { Save topmost frame     }
        PUSH    EAX                     { Save exception record  }
        PUSH    EDX                     { Save exception object  }
        PUSH    ECX                     { Save exception address }

        MOV     EDX,[ESP+8+8*4]
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    ESI                     { Save handler entry     }

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwind
@@returnAddress:

        POP     EBX                     { Restore handler entry  }

        MOV     EDI,[ESP+8+8*4]

        {       Make the RaiseList entry on the stack }

        CALL    SysInit.@GetTLS
        PUSH    [EAX].RaiseListPtr
        MOV     [EAX].RaiseListPtr,ESP

        MOV     EBP,[EDI].TExcFrame.hEBP
        MOV     [EDI].TExcFrame.desc,offset @@exceptFinally
        MOV     EAX,[ESP].TRaiseFrame.ExceptObject
        CALL    NotifyOnExcept
        JMP     [EBX].TExcDescEntry.handler

@@exceptFinally:
        JMP     _HandleFinally

@@destroyExcept:
        {       we come here if an exception handler has thrown yet another exception }
        {       we need to destroy the exception object and pop the raise list. }

        CALL    SysInit.@GetTLS
        MOV     ECX,[EAX].RaiseListPtr
        MOV     EDX,[ECX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,EDX

        MOV     EAX,[ECX].TRaiseFrame.ExceptObject
        JMP     TObject.Free
@@exit:
        MOV     EAX,1
end;


procedure       _HandleFinally;
asm
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one   }

        MOV     EAX,[ESP+4]
        MOV     EDX,[ESP+8]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JE      @@exit
        MOV     ECX,[EDX].TExcFrame.desc
        MOV     [EDX].TExcFrame.desc,offset @@exit

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBP,[EDX].TExcFrame.hEBP
        ADD     ECX,TExcDesc.instructions
        CALL    NotifyExceptFinally
        CALL    ECX

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX

@@exit:
        MOV     EAX,1
end;


procedure       _HandleAutoException;
asm
        { ->    [ESP+ 4] excPtr: PExceptionRecord       }
        {       [ESP+ 8] errPtr: PExcFrame              }
        {       [ESP+12] ctxPtr: Pointer                }
        {       [ESP+16] dspPtr: Pointer                }
        { <-    EAX return value - always one           }

        MOV     EAX,[ESP+4]
        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit

        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        CLD
        CALL    FpuInit
        JE      @@DelphiException
        CMP     BYTE PTR JITEnable,0
        JBE     @@DelphiException
        CMP     BYTE PTR DebugHook,0
        JA      @@DelphiException

@@DoUnhandled:
        LEA     EAX,[ESP+4]
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        JE      @@exit
        MOV     EAX,[ESP+4]
        JMP     @@GoUnwind

@@DelphiException:
        CMP     BYTE PTR JITEnable,1
        JBE     @@GoUnwind
        CMP     BYTE PTR DebugHook,0
        JA      @@GoUnwind
        JMP     @@DoUnhandled

@@GoUnwind:
        OR      [EAX].TExceptionRecord.ExceptionFlags,cUnwinding

        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EDX,[ESP+8+3*4]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwind

@@returnAddress:
        POP     EBP
        POP     EDI
        POP     ESI
        MOV     EAX,[ESP+4]
        MOV     EBX,8000FFFFH
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JNE     @@done

        MOV     EDX,[EAX].TExceptionRecord.ExceptObject
        MOV     ECX,[EAX].TExceptionRecord.ExceptAddr
        MOV     EAX,[ESP+8]
        MOV     EAX,[EAX].TExcFrame.SelfOfMethod
        MOV     EBX,[EAX]
        CALL    [EBX].vmtSafeCallException.Pointer
        MOV     EBX,EAX
        MOV     EAX,[ESP+4]
        MOV     EAX,[EAX].TExceptionRecord.ExceptObject
        CALL    TObject.Free
@@done:
        XOR     EAX,EAX
        MOV     ESP,[ESP+8]
        POP     ECX
        MOV     FS:[EAX],ECX
        POP     EDX
        POP     EBP
        LEA     EDX,[EDX].TExcDesc.instructions
        POP     ECX
        JMP     EDX
@@exit:
        MOV     EAX,1
end;


procedure       _RaiseExcept;
asm
        { When making changes to the way Delphi Exceptions are raised, }
        { please realize that the C++ Exception handling code reraises }
        { some exceptions as Delphi Exceptions.  Of course we want to  }
        { keep exception raising compatible between Delphi and C++, so }
        { when you make changes here, consult with the relevant C++    }
        { exception handling engineer. The C++ code is in xx.cpp, in   }
        { the RTL sources, in function tossAnException.                }

        { ->    EAX     Pointer to exception object     }
        {       [ESP]   Error address           }

        POP     EDX

        PUSH    ESP
        PUSH    EBP
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        PUSH    EAX                             { pass class argument           }
        PUSH    EDX                             { pass address argument         }

        PUSH    ESP                             { pass pointer to arguments             }
        PUSH    7                               { there are seven arguments               }
        PUSH    cNonContinuable                 { we can't continue execution   }
        PUSH    cDelphiException                { our magic exception code              }
        PUSH    EDX                             { pass the user's return address        }
        JMP     RaiseException
end;


procedure       _RaiseAgain;
asm
        { ->    [ESP        ] return address to user program }
        {       [ESP+ 4     ] raise list entry (4 dwords)    }
        {       [ESP+ 4+ 4*4] saved topmost frame            }
        {       [ESP+ 4+ 5*4] saved registers (4 dwords)     }
        {       [ESP+ 4+ 9*4] return address to OS           }
        { ->    [ESP+ 4+10*4] excPtr: PExceptionRecord       }
        {       [ESP+ 8+10*4] errPtr: PExcFrame              }

        { Point the error handler of the exception frame to something harmless }

        MOV     EAX,[ESP+8+10*4]
        MOV     [EAX].TExcFrame.desc,offset @@exit

        { Pop the RaiseList }

        CALL    SysInit.@GetTLS
        MOV     EDX,[EAX].RaiseListPtr
        MOV     ECX,[EDX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,ECX

        { Destroy any objects created for non-delphi exceptions }

        MOV     EAX,[EDX].TRaiseFrame.ExceptionRecord
        AND     [EAX].TExceptionRecord.ExceptionFlags,NOT cUnwinding
        CMP     [EAX].TExceptionRecord.ExceptionCode,cDelphiException
        JE      @@delphiException
        MOV     EAX,[EDX].TRaiseFrame.ExceptObject
        CALL    TObject.Free
        CALL    NotifyReRaise

@@delphiException:

        XOR     EAX,EAX
        ADD     ESP,5*4
        MOV     EDX,FS:[EAX]
        POP     ECX
        MOV     EDX,[EDX].TExcFrame.next
        MOV     [ECX].TExcFrame.next,EDX

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
@@exit:
        MOV     EAX,1
end;


procedure       _DoneExcept;
asm
        { ->    [ESP+ 4+10*4] excPtr: PExceptionRecord       }
        {       [ESP+ 8+10*4] errPtr: PExcFrame              }

        { Pop the RaiseList }

        CALL    SysInit.@GetTLS
        MOV     EDX,[EAX].RaiseListPtr
        MOV     ECX,[EDX].TRaiseFrame.NextRaise
        MOV     [EAX].RaiseListPtr,ECX

        { Destroy exception object }

        MOV     EAX,[EDX].TRaiseFrame.ExceptObject
        CALL    TObject.Free

        POP     EDX
        MOV     ESP,[ESP+8+9*4]
        XOR     EAX,EAX
        POP     ECX
        MOV     FS:[EAX],ECX
        POP     EAX
        POP     EBP
        CALL    NotifyTerminate
        JMP     EDX
end;


procedure   _TryFinallyExit;
asm
        XOR     EDX,EDX
        MOV     ECX,[ESP+4].TExcFrame.desc
        MOV     EAX,[ESP+4].TExcFrame.next
        ADD     ECX,TExcDesc.instructions
        MOV     FS:[EDX],EAX
        CALL    ECX
@@1:    RET     12
end;


type
  PInitContext = ^TInitContext;
  TInitContext = record
    OuterContext:   PInitContext;     { saved InitContext   }
    ExcFrame:       PExcFrame;        { bottom exc handler  }
    InitTable:      PackageInfo;      { unit init info      }
    InitCount:      Integer;          { how far we got      }
    Module:         PLibModule;       { ptr to module desc  }
    DLLSaveEBP:     Pointer;          { saved regs for DLLs }
    DLLSaveEBX:     Pointer;          { saved regs for DLLs }
    DLLSaveESI:     Pointer;          { saved regs for DLLs }
    DLLSaveEDI:     Pointer;          { saved regs for DLLs }
    DLLInitState:   Byte;
    ExitProcessTLS: procedure;        { Shutdown for TLS    }
  end;

var
  InitContext: TInitContext;

procedure       RunErrorAt(ErrCode: Integer; ErrorAddr: Pointer);
asm
        MOV     [ESP],ErrorAddr
        JMP     _RunError
end;

procedure       MapToRunError(P: PExceptionRecord); stdcall;
const
  STATUS_ACCESS_VIOLATION         = $C0000005;
  STATUS_ARRAY_BOUNDS_EXCEEDED    = $C000008C;
  STATUS_FLOAT_DENORMAL_OPERAND   = $C000008D;
  STATUS_FLOAT_DIVIDE_BY_ZERO     = $C000008E;
  STATUS_FLOAT_INEXACT_RESULT     = $C000008F;
  STATUS_FLOAT_INVALID_OPERATION  = $C0000090;
  STATUS_FLOAT_OVERFLOW           = $C0000091;
  STATUS_FLOAT_STACK_CHECK        = $C0000092;
  STATUS_FLOAT_UNDERFLOW          = $C0000093;
  STATUS_INTEGER_DIVIDE_BY_ZERO   = $C0000094;
  STATUS_INTEGER_OVERFLOW         = $C0000095;
  STATUS_PRIVILEGED_INSTRUCTION   = $C0000096;
  STATUS_STACK_OVERFLOW           = $C00000FD;
  STATUS_CONTROL_C_EXIT           = $C000013A;
var
  ErrCode: Byte;
begin
  case P.ExceptionCode of
    STATUS_INTEGER_DIVIDE_BY_ZERO:  ErrCode := 200;
    STATUS_ARRAY_BOUNDS_EXCEEDED:   ErrCode := 201;
    STATUS_FLOAT_OVERFLOW:          ErrCode := 205;
    STATUS_FLOAT_INEXACT_RESULT,
    STATUS_FLOAT_INVALID_OPERATION,
    STATUS_FLOAT_STACK_CHECK:       ErrCode := 207;
    STATUS_FLOAT_DIVIDE_BY_ZERO:    ErrCode := 200;
    STATUS_INTEGER_OVERFLOW:        ErrCode := 215;
    STATUS_FLOAT_UNDERFLOW,
    STATUS_FLOAT_DENORMAL_OPERAND:  ErrCode := 206;
    STATUS_ACCESS_VIOLATION:        ErrCode := 216;
    STATUS_PRIVILEGED_INSTRUCTION:  ErrCode := 218;
    STATUS_CONTROL_C_EXIT:          ErrCode := 217;
    STATUS_STACK_OVERFLOW:          ErrCode := 202;
  else                              ErrCode := 255;
  end;
  RunErrorAt(ErrCode, P.ExceptionAddress);
end;

procedure       _ExceptionHandler;
asm
        MOV     EAX,[ESP+4]

        TEST    [EAX].TExceptionRecord.ExceptionFlags,cUnwindInProgress
        JNE     @@exit
        CMP     BYTE PTR DebugHook,0
        JA      @@ExecuteHandler
        LEA     EAX,[ESP+4]
        PUSH    EAX
        CALL    UnhandledExceptionFilter
        CMP     EAX,EXCEPTION_CONTINUE_SEARCH
        JNE     @@ExecuteHandler
        JMP     @@exit
//        MOV     EAX,1
//        RET

@@ExecuteHandler:
        MOV     EAX,[ESP+4]
        CLD
        CALL    FpuInit
        MOV     EDX,[ESP+8]

        PUSH    0
        PUSH    EAX
        PUSH    offset @@returnAddress
        PUSH    EDX
        CALL    RtlUnwind
@@returnAddress:

        MOV     EBX,[ESP+4]
        CMP     [EBX].TExceptionRecord.ExceptionCode,cDelphiException
        MOV     EDX,[EBX].TExceptionRecord.ExceptAddr
        MOV     EAX,[EBX].TExceptionRecord.ExceptObject
        JE      @@DelphiException2

        MOV     EDX,ExceptObjProc
        TEST    EDX,EDX
        JE      MapToRunError
        MOV     EAX,EBX
        CALL    EDX
        TEST    EAX,EAX
        JE      MapToRunError
        MOV     EDX,[EBX].TExceptionRecord.ExceptionAddress

@@DelphiException2:

        CALL    NotifyUnhandled
        MOV     ECX,ExceptProc
        TEST    ECX,ECX
        JE      @@noExceptProc
        CALL    ECX             { call ExceptProc(ExceptObject, ExceptAddr) }

@@noExceptProc:
        MOV     ECX,[ESP+4]
        MOV     EAX,217
        MOV     EDX,[ECX].TExceptionRecord.ExceptAddr
        MOV     [ESP],EDX
        JMP     _RunError

@@exit:
        XOR     EAX,EAX
end;


procedure       SetExceptionHandler;
asm
        XOR     EDX,EDX                 { using [EDX] saves some space over [0] }
{X}     // now we come here from another place, and EBP is used above for loop counter
{X}     // let us restore it...
{X}     PUSH    EBP
{X}     LEA     EBP, [ESP + $60]

        LEA     EAX,[EBP-12]

        MOV     ECX,FS:[EDX]            { ECX := head of chain                  }
        MOV     FS:[EDX],EAX            { head of chain := @exRegRec            }

        MOV     [EAX].TExcFrame.next,ECX
        MOV     [EAX].TExcFrame.desc,offset _ExceptionHandler
        MOV     [EAX].TExcFrame.hEBP,EBP
        MOV     InitContext.ExcFrame,EAX

{X}     POP     EBP
end;


procedure       UnsetExceptionHandler;
asm
        XOR     EDX,EDX
        MOV     EAX,InitContext.ExcFrame
        MOV     ECX,FS:[EDX]    { ECX := head of chain          }
        CMP     EAX,ECX         { simple case: our record is first      }
        JNE     @@search
        MOV     EAX,[EAX]       { head of chain := exRegRec.next        }
        MOV     FS:[EDX],EAX
        JMP     @@exit

@@loop:
        MOV     ECX,[ECX]
@@search:
        CMP     ECX,-1          { at end of list?                       }
        JE      @@exit          { yes - didn't find it          }
        CMP     [ECX],EAX       { is it the next one on the list?       }
        JNE     @@loop          { no - look at next one on list }
@@unlink:                       { yes - unlink our record               }
        MOV     EAX,[EAX]       { get next record on list               }
        MOV     [ECX],EAX       { unlink our record                     }
@@exit:
end;


{X+ see comments in InitUnits below }
//procedure FInitUnits; {X} - renamed to FInitUnitsHard
{X} procedure FInitUnitsHard;
var
  Count: Integer;
  Table: PUnitEntryTable;
  P: procedure;
begin
  if InitContext.InitTable = nil then
        exit;
  Count := InitContext.InitCount;
  Table := InitContext.InitTable^.UnitInfo;
  try
    while Count > 0 do
    begin
      Dec(Count);
      InitContext.InitCount := Count;
      P := Table^[Count].FInit;
      if Assigned(P) then
        P;
    end;
  except
    {X- rename: FInitUnits;  { try to finalize the others }
    FInitUnitsHard;
    raise;
  end;
end;

// This handler can be set in initialization section of
// unit SysSfIni.pas only.
procedure InitUnitsHard( Table : PUnitEntryTable; Idx, Count : Integer );
begin
  try
    InitUnitsLight( Table, Idx, Count );
  except
    FInitUnitsHard;
    raise;
  end;
end;

{X+ see comments in InitUnits below }
procedure FInitUnitsLight;
var
  Count: Integer;
  Table: PUnitEntryTable;
  P: procedure;
begin
  if InitContext.InitTable = nil then
        exit;
  Count := InitContext.InitCount;
  Table := InitContext.InitTable^.UnitInfo;
  while Count > 0 do
  begin
    Dec(Count);
    InitContext.InitCount := Count;
    P := Table^[Count].FInit;
    if Assigned(P) then
      P;
  end;
end;

{X+ see comments in InitUnits below }
procedure InitUnitsLight( Table : PUnitEntryTable; Idx, Count : Integer );
var P : procedure;
    Light : Boolean;
begin
  Light := @InitUnitsProc = @InitUnitsLight;
  while Idx < Count do
  begin
    P := Table^[ Idx ].Init;
    Inc( Idx );
    InitContext.InitCount := Idx;
    if Assigned( P ) then
      P;
    if Light and (@InitUnitsProc <> @InitUnitsLight) then
    begin
      InitUnitsProc( Table, Idx, Count );
      break;
    end;
  end;
end;

{X+ see comments in body of InitUnits below }
procedure InitUnits;
var
  Count, I: Integer;
  Table: PUnitEntryTable;
  {X- P: procedure; }
begin
  if InitContext.InitTable = nil then
    exit;
  Count := InitContext.InitTable^.UnitCount;
  I := 0;
  Table := InitContext.InitTable^.UnitInfo;
  {X- by default, Delphi InitUnits uses try-except & raise constructions,
      which leads to permanent use of all exception handler routines.
      Let us make this by another way.
  try
    while I < Count do
    begin
      P := Table^[I].Init;
      Inc(I);
      InitContext.InitCount := I;
      if Assigned(P) then
        P;
    end;
  except
    FInitUnits;
    raise;
  end;
  X+}
  InitUnitsProc( Table, I, Count );
end;


procedure _PackageLoad(const Table : PackageInfo);
var
  SavedContext: TInitContext;
begin
  SavedContext := InitContext;
  InitContext.DLLInitState := 0;
  InitContext.InitTable := Table;
  InitContext.InitCount := 0;
  InitContext.OuterContext := @SavedContext;
  try
    InitUnits;
  finally
    InitContext := SavedContext;
  end;
end;


procedure _PackageUnload(const Table : PackageInfo);
var
  SavedContext: TInitContext;
begin
  SavedContext := InitContext;
  InitContext.DLLInitState := 0;
  InitContext.InitTable := Table;
  InitContext.InitCount := Table^.UnitCount;
  InitContext.OuterContext := @SavedContext;
  try
  FInitUnitsProc;
  finally
  InitContext := SavedContext;
  end;
end;


procedure       _StartExe;
asm
        { ->    EAX InitTable   }
        {       EDX Module      }
        MOV     InitContext.InitTable,EAX
        XOR     EAX,EAX
        MOV     InitContext.InitCount,EAX
        MOV     InitContext.Module,EDX
        MOV     EAX,[EDX].TLibModule.Instance
        MOV     MainInstance,EAX

        {X CALL    SetExceptionHandler - moved to SysSfIni.pas }

        MOV     IsLibrary,0

        CALL    InitUnits;
end;


procedure       _StartLib;
asm
        { ->    EAX InitTable   }
        {       EDX Module      }
        {       ECX InitTLS     }
        {       [ESP+4] DllProc }
        {       [EBP+8] HInst   }
        {       [EBP+12] Reason }

        { Push some desperately needed registers }

        PUSH    ECX
        PUSH    ESI
        PUSH    EDI

        { Save the current init context into the stackframe of our caller }

        MOV     ESI,offset InitContext
        LEA     EDI,[EBP- (type TExcFrame) - (type TInitContext)]
        MOV     ECX,(type TInitContext)/4
        REP     MOVSD

        { Setup the current InitContext }

        POP     InitContext.DLLSaveEDI
        POP     InitContext.DLLSaveESI
        MOV     InitContext.DLLSaveEBP,EBP
        MOV     InitContext.DLLSaveEBX,EBX
        MOV     InitContext.InitTable,EAX
        MOV     InitContext.Module,EDX
        LEA     ECX,[EBP- (type TExcFrame) - (type TInitContext)]
        MOV     InitContext.OuterContext,ECX
        XOR     ECX,ECX
        CMP     dword ptr [EBP+12],0
        JNE     @@notShutDown
        MOV     ECX,[EAX].PackageInfoTable.UnitCount
@@notShutDown:
        MOV     InitContext.InitCount,ECX

        CALL    SetExceptionHandler {X-- could be moved to SysSfIni.pas but ...}

        MOV     EAX,[EBP+12]
        INC     EAX
        MOV     InitContext.DLLInitState,AL
        DEC     EAX

        { Init any needed TLS }

        POP     ECX
        MOV     EDX,[ECX]
        MOV     InitContext.ExitProcessTLS,EDX
        JE      @@noTLSproc
        CALL    dword ptr [ECX+EAX*4]
@@noTLSproc:

        { Call any DllProc }

        MOV     EDX,[ESP+4]
        TEST    EDX,EDX
        JE      @@noDllProc
        MOV     EAX,[EBP+12]
        CALL    EDX
@@noDllProc:

        { Set IsLibrary if there was no exe yet }

        CMP     MainInstance,0
        JNE     @@haveExe
        MOV     IsLibrary,1
        FNSTCW  Default8087CW   // save host exe's FPU preferences

@@haveExe:

        MOV     EAX,[EBP+12]
        DEC     EAX
        JNE     _Halt0
        CALL    InitUnits
        RET     4
end;


procedure _InitResStrings;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      resStringAddress: Pointer;   }
        {                   end;                            }
        {                 end;                              }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX]
        LEA     ESI,[EAX+4]
@@loop:
        MOV     EAX,[ESI+4]   { load resStringAddress   }
        MOV     EDX,[ESI]         { load variableAddress    }
        CALL    LoadResString
        ADD     ESI,8
        DEC     EBX
        JNZ     @@loop

        POP     ESI
        POP     EBX
end;

procedure _InitResStringImports;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      resStringAddress: ^Pointer;  }
        {                   end;                            }
        {                 end;                              }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX]
        LEA     ESI,[EAX+4]
@@loop:
        MOV     EAX,[ESI+4]     { load address of import    }
        MOV     EDX,[ESI]       { load address of variable  }
        MOV     EAX,[EAX]       { load contents of import   }
        CALL    LoadResString
        ADD     ESI,8
  DEC     EBX
  JNZ     @@loop

  POP     ESI
  POP     EBX
end;

procedure _InitImports;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      sourceAddress: ^Pointer;     }
        {                      sourceOffset: Longint;       }
        {                   end;                            }
        {                 end;                              }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX]
        LEA     ESI,[EAX+4]
@@loop:
        MOV     EAX,[ESI+4]     { load address of import    }
        MOV     EDX,[ESI]       { load address of variable  }
        MOV     ECX,[ESI+8]     { load offset               }
        MOV     EAX,[EAX]       { load contents of import   }
        ADD     EAX,ECX         { calc address of variable  }
        MOV     [EDX],EAX       { store result              }
        ADD     ESI,12
        DEC     EBX
        JNZ     @@loop

        POP     ESI
        POP     EBX
end;

procedure _InitWideStrings;
asm
        { ->    EAX     Pointer to init table               }
        {                 record                            }
        {                   cnt: Integer;                   }
        {                   tab: array [1..cnt] record      }
        {                      variableAddress: Pointer;    }
        {                      stringAddress: ^Pointer;     }
        {                   end;                            }
        {                 end;                              }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX]
        LEA     ESI,[EAX+4]
@@loop:
  MOV     EDX,[ESI+4]     { load address of string    }
  MOV     EAX,[ESI]       { load address of variable  }
  CALL    _WStrAsg
  ADD     ESI,8
  DEC     EBX
  JNZ     @@loop

  POP     ESI
  POP     EBX
end;

var
  runErrMsg: array[0..29] of Char = 'Runtime error     at 00000000'#0;
                        // columns:  0123456789012345678901234567890
  errCaption: array[0..5] of Char = 'Error'#0;


procedure MakeErrorMessage;
const
  dig : array [0..15] of Char = '0123456789ABCDEF';
asm
        PUSH    EBX
        MOV     EAX,ExitCode
        MOV     EBX,offset runErrMsg + 16
        MOV     ECX,10

@@digLoop:
        XOR     EDX,EDX
        DIV     ECX
        ADD     DL,'0'
        MOV     [EBX],DL
        DEC     EBX
        TEST    EAX,EAX
        JNZ     @@digLoop

    MOV     EAX,ErrorAddr

        CALL    FindHInstance
        MOV     EDX, ErrorAddr
        XCHG    EAX, EDX
        SUB     EAX, EDX           { EAX <=> offset from start of code for HINSTANCE }
        MOV     EBX,offset runErrMsg + 28

@@hdigLoop:
        MOV     EDX,EAX
        AND     EDX,0FH
        MOV     DL,byte ptr dig[EDX]
        MOV     [EBX],DL
        DEC     EBX
        SHR     EAX,4
        JNE     @@hdigLoop
        POP     EBX
end;


procedure       ExitDll;
asm
        { Restore the InitContext }

        MOV     EDI,offset InitContext

        MOV     EBX,InitContext.DLLSaveEBX
        MOV     EBP,InitContext.DLLSaveEBP
        PUSH    [EDI].TInitContext.DLLSaveESI
        PUSH    [EDI].TInitContext.DLLSaveEDI

        MOV     ESI,[EDI].TInitContext.OuterContext
        MOV     ECX,(type TInitContext)/4
        REP     MOVSD
        POP     EDI
        POP     ESI

        { Return False if ExitCode <> 0, and set ExitCode to 0 }

        XOR     EAX,EAX
        XCHG    EAX,ExitCode
        NEG     EAX
        SBB     EAX,EAX
        INC     EAX
        LEAVE
        RET     12
end;

// {X} Procedure Halt0 refers to WriteLn and MessageBox
//     but actually such code can be not used really.
//     So, implementation changed to avoid such references.
//
//     Either call UseErrorMessageBox or UseErrorMessageWrite
//     to provide error message output in GUI or console app.
// {X}+

var ErrorMessageOutProc : procedure = DummyProc;

procedure ErrorMessageBox;
begin
  MakeErrorMessage;
  if not NoErrMsg then
     MessageBox(0, runErrMsg, errCaption, 0);
end;

procedure UseErrorMessageBox;
begin
  ErrorMessageOutProc := ErrorMessageBox;
end;

procedure ErrorMessageWrite;
begin
  MakeErrorMessage;
  WriteLn(PChar(@runErrMsg));
end;

procedure UseErrorMessageWrite;
begin
  ErrorMessageOutProc := ErrorMessageWrite;
end;

procedure DoCloseInputOutput;
begin
  Close( Input );
  Close( Output );
end;

var CloseInputOutput : procedure;

procedure UseInputOutput;
begin
  if not assigned( CloseInputOutput ) then
  begin
    CloseInputOutput := DoCloseInputOutput;
    _Assign( Input, '' );
    _Assign( Output, '' );
  end;
end;

// {X}-

procedure _Halt0;
var
  P: procedure;
begin

  if InitContext.DLLInitState = 0 then
    while ExitProc <> nil do
    begin
      @P := ExitProc;
      ExitProc := nil;
      P;
    end;

  { If there was some kind of runtime error, alert the user }

  if ErrorAddr <> nil then
  begin
    {X+}
    ErrorMessageOutProc;
    {
    MakeErrorMessage;
    if IsConsole then
      WriteLn(PChar(@runErrMsg))
    else if not NoErrMsg then
      MessageBox(0, runErrMsg, errCaption, 0);
    } {X-}

    {X- As it is said by Alexey Torgashin, it is better not to clear ErrorAddr
        to make possible check ErrorAddr <> nil in finalization of rest units.
        If You want, You can uncomment it again: }
    //ErrorAddr := nil;
    {X+}
  end;

  { This loop exists because we might be nested in PackageLoad calls when }
  { Halt got called. We need to unwind these contexts.                    }

  while True do
  begin

    { If we are a library, and we are starting up fine, there are no units to finalize }

    if (InitContext.DLLInitState = 2) and (ExitCode = 0) then
      InitContext.InitCount := 0;

    { Undo any unit initializations accomplished so far }

    FInitUnitsProc;

    if (InitContext.DLLInitState <= 1) or (ExitCode <> 0) then
      if InitContext.Module <> nil then
        with InitContext do
        begin
          UnregisterModule(Module);
          if Module.ResInstance <> Module.Instance then
            FreeLibrary(Module.ResInstance);
        end;

    {X UnsetExceptionHandler; - changed to call of handler }
    UnsetExceptionHandlerProc;

    if InitContext.DllInitState = 1 then
      InitContext.ExitProcessTLS;

    if InitContext.DllInitState <> 0 then
      ExitDll;

    if InitContext.OuterContext = nil then
      ExitProcess(ExitCode);

    InitContext := InitContext.OuterContext^
  end;

  asm
    db 'Portions Copyright (c) 1983,99 Borland',0
  end;

end;


procedure _Halt;
asm
        MOV     ExitCode,EAX
        JMP     _Halt0
end;


procedure _Run0Error;
asm
        XOR     EAX,EAX
        JMP     _RunError
end;


procedure _RunError;
asm
        POP     ErrorAddr
        JMP     _Halt
end;


procedure _Assert(const Message, Filename: AnsiString; LineNumber: Integer);
asm
        CMP     AssertErrorProc,0
        JE      @@1
        PUSH    [ESP].Pointer
        CALL    AssertErrorProc
        RET
@@1:    MOV     AL,reAssertionFailed
        JMP     Error
end;

type
  PThreadRec = ^TThreadRec;
  TThreadRec = record
    Func: TThreadFunc;
    Parameter: Pointer;
  end;


function ThreadWrapper(Parameter: Pointer): Integer; stdcall;
asm
        CALL    FpuInit
        XOR     ECX,ECX
        PUSH    EBP
        PUSH    offset _ExceptionHandler
        MOV     EDX,FS:[ECX]
        PUSH    EDX
        MOV     EAX,Parameter
        MOV     FS:[ECX],ESP

        MOV     ECX,[EAX].TThreadRec.Parameter
        MOV     EDX,[EAX].TThreadRec.Func
        PUSH    ECX
        PUSH    EDX
        CALL    _FreeMem
        POP     EDX
        POP     EAX
        CALL    EDX

        XOR     EDX,EDX
        POP     ECX
        MOV     FS:[EDX],ECX
        POP     ECX
        POP     EBP
end;


function BeginThread(SecurityAttributes: Pointer; StackSize: LongWord;
  ThreadFunc: TThreadFunc; Parameter: Pointer; CreationFlags: LongWord;
  var ThreadId: LongWord): Integer;
var
  P: PThreadRec;
begin
  New(P);
  P.Func := ThreadFunc;
  P.Parameter := Parameter;
  IsMultiThread := TRUE;
  Result := CreateThread(SecurityAttributes, StackSize, @ThreadWrapper, P,
    CreationFlags, ThreadID);
end;


procedure EndThread(ExitCode: Integer);
begin
  ExitThread(ExitCode);
end;


type
  StrRec = packed record
    allocSiz: Longint;
    refCnt: Longint;
    length: Longint;
  end;

const
        skew = sizeof(StrRec);
        rOff = sizeof(StrRec) - sizeof(Longint); { refCnt offset }
        overHead = sizeof(StrRec) + 1;


procedure _LStrClr(var S: AnsiString);
asm
        { ->    EAX pointer to str      }

        MOV     EDX,[EAX]                       { fetch str                     }
        TEST    EDX,EDX                         { if nil, nothing to do         }
        JE      @@done
        MOV     dword ptr [EAX],0               { clear str                     }
        MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                  }
        DEC     ECX                             { if < 0: literal str           }
        JL      @@done
{X LOCK} DEC     [EDX-skew].StrRec.refCnt        { NONthreadsafe dec refCount       }
        JNE     @@done
        PUSH    EAX
        LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    _FreeMem
        POP     EAX
@@done:
end;


procedure       _LStrArrayClr{var str: AnsiString; cnt: longint};
asm
        { ->    EAX pointer to str      }
        {       EDX cnt         }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EDX

@@loop:
        MOV     EDX,[EBX]                       { fetch str                     }
        TEST    EDX,EDX                         { if nil, nothing to do         }
        JE      @@doneEntry
        MOV     dword ptr [EBX],0               { clear str                     }
        MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                  }
        DEC     ECX                             { if < 0: literal str           }
        JL      @@doneEntry
{X LOCK} DEC     [EDX-skew].StrRec.refCnt        { NONthreadsafe dec refCount       }
        JNE     @@doneEntry
        LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    _FreeMem
@@doneEntry:
        ADD     EBX,4
        DEC     ESI
        JNE     @@loop

        POP     ESI
        POP     EBX
end;

{ 99.03.11
  This function is used when assigning to global variables.

  Literals are copied to prevent a situation where a dynamically
  allocated DLL or package assigns a literal to a variable and then
  is unloaded -- thereby causing the string memory (in the code
  segment of the DLL) to be removed -- and therefore leaving the
  global variable pointing to invalid memory.
}
procedure _LStrAsg{var dest: AnsiString; source: AnsiString};
asm
        { ->    EAX pointer to dest   str      }
        { ->    EDX pointer to source str      }

        TEST    EDX,EDX                           { have a source? }
        JE      @@2                               { no -> jump     }

        MOV     ECX,[EDX-skew].StrRec.refCnt
        INC     ECX
        JG      @@1                               { literal string -> jump not taken }

        PUSH    EAX
        PUSH    EDX
        MOV     EAX,[EDX-skew].StrRec.length
        CALL    _NewAnsiString
        MOV     EDX,EAX
        POP     EAX
        PUSH    EDX
        MOV     ECX,[EAX-skew].StrRec.length
        CALL    Move
        POP     EDX
        POP     EAX
        JMP     @@2

@@1:
   {X LOCK} INC     [EDX-skew].StrRec.refCnt

@@2:    XCHG    EDX,[EAX]
        TEST    EDX,EDX
        JE      @@3
        MOV     ECX,[EDX-skew].StrRec.refCnt
        DEC     ECX
        JL      @@3
   {X LOCK} DEC     [EDX-skew].StrRec.refCnt
        JNE     @@3
        LEA     EAX,[EDX-skew].StrRec.refCnt
        CALL    _FreeMem
@@3:
end;

procedure       _LStrLAsg{var dest: AnsiString; source: AnsiString};
asm
{ ->    EAX     pointer to dest }
{       EDX     source          }

        TEST    EDX,EDX
        JE      @@sourceDone

        { bump up the ref count of the source }

        MOV     ECX,[EDX-skew].StrRec.refCnt
        INC     ECX
        JLE     @@sourceDone                    { literal assignment -> jump taken }
{X LOCK} INC     [EDX-skew].StrRec.refCnt
@@sourceDone:

        { we need to release whatever the dest is pointing to   }

        XCHG    EDX,[EAX]                       { fetch str                    }
        TEST    EDX,EDX                         { if nil, nothing to do        }
        JE      @@done
        MOV     ECX,[EDX-skew].StrRec.refCnt    { fetch refCnt                 }
        DEC     ECX                             { if < 0: literal str          }
        JL      @@done
{X LOCK} DEC     [EDX-skew].StrRec.refCnt        { NONthreadsafe dec refCount      }
        JNE     @@done
        LEA     EAX,[EDX-skew].StrRec.refCnt    { if refCnt now zero, deallocate}
        CALL    _FreeMem
@@done:
end;

function _NewAnsiString(length: Longint): Pointer;
{$IFDEF PUREPASCAL}
var
  P: PStrRec;
begin
  Result := nil;
  if length <= 0 then Exit;
  // Alloc an extra null for strings with even length.  This has no actual cost
  // since the allocator will round up the request to an even size anyway.
  // All widestring allocations have even length, and need a double null terminator.
  GetMem(P, length + sizeof(StrRec) + 1 + ((length + 1) and 1));
  Result := Pointer(Integer(P) + sizeof(StrRec));
  P.length := length;
  P.refcnt := 1;
  PWideChar(Result)[length div 2] := #0;  // length guaranteed >= 2
end;
{$ELSE}
asm
  { ->    EAX     length                  }
  { <-    EAX pointer to new string       }

          TEST    EAX,EAX
          JLE     @@null
          PUSH    EAX
          ADD     EAX,rOff+2                       // one or two nulls (Ansi/Wide)
          AND     EAX, not 1                   // round up to even length
          PUSH    EAX
          CALL    _GetMem
          POP     EDX                              // actual allocated length (>= 2)
          MOV     word ptr [EAX+EDX-2],0           // double null terminator
          ADD     EAX,rOff
          POP     EDX                              // requested string length
          MOV     [EAX-skew].StrRec.length,EDX
          MOV     [EAX-skew].StrRec.refCnt,1
          RET
@@null:
          XOR     EAX,EAX
end;
{$ENDIF}


{original, maybe buggy
procedure       _NewAnsiString{length: Longint};
//asm
        { ->    EAX     length                  }
        { <-    EAX pointer to new string       }
{
        TEST    EAX,EAX
        JLE     @@null
        PUSH    EAX
        ADD     EAX,rOff+1
        CALL    _GetMem
        ADD     EAX,rOff
        POP     EDX
        MOV     [EAX-skew].StrRec.length,EDX
        MOV     [EAX-skew].StrRec.refCnt,1
        MOV     byte ptr [EAX+EDX],0
        RET

@@null:
        XOR     EAX,EAX
end;
}

procedure _LStrFromPCharLen(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
asm
        { ->    EAX     pointer to dest }
        {       EDX source              }
        {       ECX length              }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        { allocate new string }

        MOV     EAX,EDI

        CALL    _NewAnsiString
        MOV     ECX,EDI
        MOV     EDI,EAX

        TEST    ESI,ESI
        JE      @@noMove

        MOV     EDX,EAX
        MOV     EAX,ESI
        CALL    Move

        { assign the result to dest }

@@noMove:
        MOV     EAX,EBX
        CALL    _LStrClr
        MOV     [EBX],EDI

        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure _LStrFromPWCharLen(var Dest: AnsiString; Source: PWideChar; Length: Integer);
var
  DestLen: Integer;
  Buffer: array[0..2047] of Char;
begin
  if Length <= 0 then
  begin
    _LStrClr(Dest);
    Exit;
  end;
  if Length < SizeOf(Buffer) div 2 then
  begin
    DestLen := WideCharToMultiByte(0, 0, Source, Length,
      Buffer, SizeOf(Buffer), nil, nil);
    if DestLen > 0 then
    begin
      _LStrFromPCharLen(Dest, Buffer, DestLen);
      Exit;
    end;
  end;
  DestLen := WideCharToMultiByte(0, 0, Source, Length, nil, 0, nil, nil);
  _LStrFromPCharLen(Dest, nil, DestLen);
  WideCharToMultiByte(0, 0, Source, Length, Pointer(Dest), DestLen, nil, nil);
end;


procedure _LStrFromChar(var Dest: AnsiString; Source: AnsiChar);
asm
        PUSH    EDX
        MOV     EDX,ESP
        MOV     ECX,1
        CALL    _LStrFromPCharLen
        POP     EDX
end;


procedure _LStrFromWChar(var Dest: AnsiString; Source: WideChar);
asm
        PUSH    EDX
        MOV     EDX,ESP
        MOV     ECX,1
        CALL    _LStrFromPWCharLen
        POP     EDX
end;


procedure _LStrFromPChar(var Dest: AnsiString; Source: PAnsiChar);
asm
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CL,[EDX+0]
        JE      @@4
        CMP     CL,[EDX+1]
        JE      @@3
        CMP     CL,[EDX+2]
        JE      @@2
        CMP     CL,[EDX+3]
        JE      @@1
        ADD     EDX,4
        JMP     @@0
@@1:    INC     EDX
@@2:    INC     EDX
@@3:    INC     EDX
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
@@5:    JMP     _LStrFromPCharLen
end;


procedure _LStrFromPWChar(var Dest: AnsiString; Source: PWideChar);
asm
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CX,[EDX+0]
        JE      @@4
        CMP     CX,[EDX+2]
        JE      @@3
        CMP     CX,[EDX+4]
        JE      @@2
        CMP     CX,[EDX+6]
        JE      @@1
        ADD     EDX,8
        JMP     @@0
@@1:    ADD     EDX,2
@@2:    ADD     EDX,2
@@3:    ADD     EDX,2
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
        SHR     ECX,1
@@5:    JMP     _LStrFromPWCharLen
end;


procedure _LStrFromString(var Dest: AnsiString; const Source: ShortString);
asm
        XOR     ECX,ECX
        MOV     CL,[EDX]
        INC     EDX
        JMP     _LStrFromPCharLen
end;


procedure _LStrFromArray(var Dest: AnsiString; Source: PAnsiChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASB
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _LStrFromPCharLen
end;


procedure _LStrFromWArray(var Dest: AnsiString; Source: PWideChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASW
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _LStrFromPWCharLen
end;


procedure _LStrFromWStr(var Dest: AnsiString; const Source: WideString);
asm
        { ->    EAX pointer to dest              }
        {       EDX pointer to WideString data   }

        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@1
        MOV     ECX,[EDX-4]
        SHR     ECX,1
@@1:    JMP     _LStrFromPWCharLen
end;


procedure _LStrToString{(var Dest: ShortString; const Source: AnsiString; MaxLen: Integer)};
asm
        { ->    EAX pointer to result   }
        {       EDX AnsiString s        }
        {       ECX length of result    }

        PUSH    EBX
        TEST    EDX,EDX
        JE      @@empty
        MOV     EBX,[EDX-skew].StrRec.length
        TEST    EBX,EBX
        JE      @@empty

        CMP     ECX,EBX
        JL      @@truncate
        MOV     ECX,EBX
@@truncate:
        MOV     [EAX],CL
        INC     EAX

        XCHG    EAX,EDX
        CALL    Move

        JMP     @@exit

@@empty:
        MOV     byte ptr [EAX],0

@@exit:
        POP     EBX
end;


function        _LStrLen{str: AnsiString}: Longint;
asm
        { ->    EAX str }

        TEST    EAX,EAX
        JE      @@done
        MOV     EAX,[EAX-skew].StrRec.length;
@@done:
end;


procedure       _LStrCat{var dest: AnsiString; source: AnsiString};
asm
        { ->    EAX     pointer to dest }
        {       EDX source              }

        TEST    EDX,EDX
        JE      @@exit

        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      _LStrAsg

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,[ECX-skew].StrRec.length

        MOV     EDX,[ESI-skew].StrRec.length
        ADD     EDX,EDI
        CMP     ESI,ECX
        JE      @@appendSelf

        CALL    _LStrSetLength
        MOV     EAX,ESI
        MOV     ECX,[ESI-skew].StrRec.length

@@appendStr:
        MOV     EDX,[EBX]
        ADD     EDX,EDI
        CALL    Move
        POP     EDI
        POP     ESI
        POP     EBX
        RET

@@appendSelf:
        CALL    _LStrSetLength
        MOV     EAX,[EBX]
        MOV     ECX,EDI
        JMP     @@appendStr

@@exit:
end;


procedure       _LStrCat3{var dest:AnsiString; source1: AnsiString; source2: AnsiString};
asm
        {     ->EAX = Pointer to dest   }
        {       EDX = source1           }
        {       ECX = source2           }

        TEST    EDX,EDX
        JE      @@assignSource2

        TEST    ECX,ECX
        JE      _LStrAsg

        CMP     EDX,[EAX]
        JE      @@appendToDest

        CMP     ECX,[EAX]
        JE      @@theHardWay

        PUSH    EAX
        PUSH    ECX
        CALL    _LStrAsg

        POP     EDX
        POP     EAX
        JMP     _LStrCat

@@theHardWay:

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EDX
        MOV     ESI,ECX
        PUSH    EAX

        MOV     EAX,[EBX-skew].StrRec.length
        ADD     EAX,[ESI-skew].StrRec.length
        CALL    _NewAnsiString

        MOV     EDI,EAX
        MOV     EDX,EAX
        MOV     EAX,EBX
        MOV     ECX,[EBX-skew].StrRec.length
        CALL    Move

        MOV     EDX,EDI
        MOV     EAX,ESI
        MOV     ECX,[ESI-skew].StrRec.length
        ADD     EDX,[EBX-skew].StrRec.length
        CALL    Move

        POP     EAX
        MOV     EDX,EDI
        TEST    EDI,EDI
        JE      @@skip
        DEC     [EDI-skew].StrRec.refCnt    // EDI = local temp str
@@skip:
        CALL    _LStrAsg

        POP     EDI
        POP     ESI
        POP     EBX

        JMP     @@exit

@@assignSource2:
        MOV     EDX,ECX
        JMP     _LStrAsg

@@appendToDest:
        MOV     EDX,ECX
        JMP     _LStrCat

@@exit:
end;


procedure       _LStrCatN{var dest:AnsiString; argCnt: Integer; ...};
asm
        {     ->EAX = Pointer to dest   }
        {       EDX = number of args (>= 3)     }
        {       [ESP+4], [ESP+8], ... crgCnt AnsiString arguments }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDX
        PUSH    EAX
        MOV     EBX,EDX

        XOR     EAX,EAX
@@loop1:
        MOV     ECX,[ESP+EDX*4+4*4]
        TEST    ECX,ECX
        JE      @@1
        ADD     EAX,[ECX-skew].StrRec.length
@@1:
        DEC     EDX
        JNE     @@loop1

        CALL    _NewAnsiString
        PUSH    EAX
        MOV     ESI,EAX

@@loop2:
        MOV     EAX,[ESP+EBX*4+5*4]
        MOV     EDX,ESI
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-skew].StrRec.length
        ADD     ESI,ECX
        CALL    Move
@@2:
        DEC     EBX
        JNE     @@loop2

        POP     EDX
        POP     EAX
        TEST    EDX,EDX
        JE      @@skip
        DEC     [EDX-skew].StrRec.refCnt   // EDX = local temp str
@@skip:
        CALL    _LStrAsg

        POP     EDX
        POP     ESI
        POP     EBX
        POP     EAX
        LEA     ESP,[ESP+EDX*4]
        JMP     EAX
end;


procedure       _LStrCmp{left: AnsiString; right: AnsiString};
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        CMP     EAX,EDX
        JE      @@exit

        TEST    ESI,ESI
        JE      @@str1null

        TEST    EDI,EDI
        JE      @@str2null

        MOV     EAX,[ESI-skew].StrRec.length
        MOV     EDX,[EDI-skew].StrRec.length

        SUB     EAX,EDX { eax = len1 - len2 }
        JA      @@skip1
        ADD     EDX,EAX { edx = len2 + (len1 - len2) = len1     }

@@skip1:
        PUSH    EDX
        SHR     EDX,2
        JE      @@cmpRest
@@longLoop:
        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     EDX
        JE      @@cmpRestP4
        MOV     ECX,[ESI+4]
        MOV     EBX,[EDI+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     ESI,8
        ADD     EDI,8
        DEC     EDX
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestP4:
        ADD     ESI,4
        ADD     EDI,4
@@cmpRest:
        POP     EDX
        AND     EDX,3
        JE      @@equal

        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     CL,BL
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        CMP     CH,BH
        JNE     @@exit
        DEC     EDX
        JE      @@equal
        AND     EBX,$00FF0000
        AND     ECX,$00FF0000
        CMP     ECX,EBX
        JNE     @@exit

@@equal:
        ADD     EAX,EAX
        JMP     @@exit

@@str1null:
        MOV     EDX,[EDI-skew].StrRec.length
        SUB     EAX,EDX
        JMP     @@exit

@@str2null:
        MOV     EAX,[ESI-skew].StrRec.length
        SUB     EAX,EDX
        JMP     @@exit

@@misMatch:
        POP     EDX
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CL,BL
        JNE     @@exit
        CMP     CH,BH

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX

end;


procedure       _LStrAddRef{str: AnsiString};
asm
        { ->    EAX     str     }
        TEST    EAX,EAX
        JE      @@exit
        MOV     EDX,[EAX-skew].StrRec.refCnt
        INC     EDX
        JLE     @@exit
{X LOCK} INC     [EAX-skew].StrRec.refCnt
@@exit:
end;


procedure       _LStrToPChar{str: AnsiString): PChar};
asm
        { ->    EAX pointer to str              }
        { <-    EAX pointer to PChar    }

        TEST    EAX,EAX
        JE      @@handle0
        RET
@@zeroByte:
        DB      0
@@handle0:
        MOV     EAX,offset @@zeroByte
end;


procedure       UniqueString(var str: string);
asm
        { ->    EAX pointer to str              }
        { <-    EAX pointer to unique copy      }
        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@exit
        MOV     ECX,[EDX-skew].StrRec.refCnt
        DEC     ECX
        JE      @@exit

        PUSH    EBX
        MOV     EBX,EAX
        MOV     EAX,[EDX-skew].StrRec.length
        CALL    _NewAnsiString
        MOV     EDX,EAX
        MOV     EAX,[EBX]
        MOV     [EBX],EDX
        MOV     ECX,[EAX-skew].StrRec.refCnt
        DEC     ECX
        JL      @@skip
{X LOCK} DEC     [EAX-skew].StrRec.refCnt
@@skip:
        MOV     ECX,[EAX-skew].StrRec.length
        CALL    Move
        MOV     EDX,[EBX]
        POP     EBX
@@exit:
        MOV     EAX,EDX
end;


procedure       _LStrCopy{ const s : AnsiString; index, count : Integer) : AnsiString};
asm
        {     ->EAX     Source string                   }
        {       EDX     index                           }
        {       ECX     count                           }
        {       [ESP+4] Pointer to result string        }

        PUSH    EBX

        TEST    EAX,EAX
        JE      @@srcEmpty

        MOV     EBX,[EAX-skew].StrRec.length
        TEST    EBX,EBX
        JE      @@srcEmpty

{       make index 0-based and limit to 0 <= index < Length(src) }

        DEC     EDX
        JL      @@smallInx
        CMP     EDX,EBX
        JGE     @@bigInx

@@cont1:

{       limit count to satisfy 0 <= count <= Length(src) - index        }

        SUB     EBX,EDX { calculate Length(src) - index }
        TEST    ECX,ECX
        JL      @@smallCount
        CMP     ECX,EBX
        JG      @@bigCount

@@cont2:

        ADD     EDX,EAX
        MOV     EAX,[ESP+4+4]
        CALL    _LStrFromPCharLen
        JMP     @@exit

@@smallInx:
        XOR     EDX,EDX
        JMP     @@cont1
@@bigCount:
        MOV     ECX,EBX
        JMP     @@cont2
@@bigInx:
@@smallCount:
@@srcEmpty:
        MOV     EAX,[ESP+4+4]
        CALL    _LStrClr
@@exit:
        POP     EBX
        RET     4
end;


procedure       _LStrDelete{ var s : AnsiString; index, count : Integer };
asm
        {     ->EAX     Pointer to s    }
        {       EDX     index           }
        {       ECX     count           }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        CALL    UniqueString

        MOV     EDX,[EBX]
        TEST    EDX,EDX         { source already empty: nothing to do   }
        JE      @@exit

        MOV     ECX,[EDX-skew].StrRec.length

{       make index 0-based, if not in [0 .. Length(s)-1] do nothing     }

        DEC     ESI
        JL      @@exit
        CMP     ESI,ECX
        JGE     @@exit

{       limit count to [0 .. Length(s) - index] }

        TEST    EDI,EDI
        JLE     @@exit
        SUB     ECX,ESI         { ECX = Length(s) - index       }
        CMP     EDI,ECX
        JLE     @@1
        MOV     EDI,ECX
@@1:

{       move length - index - count characters from s+index+count to s+index }

        SUB     ECX,EDI         { ECX = Length(s) - index - count       }
        ADD     EDX,ESI         { EDX = s+index                 }
        LEA     EAX,[EDX+EDI]   { EAX = s+index+count           }
        CALL    Move

{       set length(s) to length(s) - count      }

        MOV     EDX,[EBX]
        MOV     EAX,EBX
        MOV     EDX,[EDX-skew].StrRec.length
        SUB     EDX,EDI
        CALL    _LStrSetLength

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _LStrInsert{ const source : AnsiString; var s : AnsiString; index : Integer };
asm
        { ->    EAX source string                       }
        {       EDX     pointer to destination string   }
        {       ECX index                               }

        TEST    EAX,EAX
        JE      @@nothingToDo

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

{       make index 0-based and limit to 0 <= index <= Length(s) }

        MOV     EDX,[EDX]
        PUSH    EDX
        TEST    EDX,EDX
        JE      @@sIsNull
        MOV     EDX,[EDX-skew].StrRec.length
@@sIsNull:
        DEC     EDI
        JGE     @@indexNotLow
        XOR     EDI,EDI
@@indexNotLow:
        CMP     EDI,EDX
        JLE     @@indexNotHigh
        MOV     EDI,EDX
@@indexNotHigh:

        MOV     EBP,[EBX-skew].StrRec.length

{       set length of result to length(source) + length(s)      }

        MOV     EAX,ESI
        ADD     EDX,EBP
        CALL    _LStrSetLength
        POP     EAX

        CMP     EAX,EBX
        JNE     @@notInsertSelf
        MOV     EBX,[ESI]

@@notInsertSelf:

{       move length(s) - length(source) - index chars from s+index to s+index+length(source) }

        MOV     EAX,[ESI]                       { EAX = s       }
        LEA     EDX,[EDI+EBP]                   { EDX = index + length(source)  }
        MOV     ECX,[EAX-skew].StrRec.length
        SUB     ECX,EDX                         { ECX = length(s) - length(source) - index }
        ADD     EDX,EAX                         { EDX = s + index + length(source)      }
        ADD     EAX,EDI                         { EAX = s + index       }
        CALL    Move

{       copy length(source) chars from source to s+index        }

        MOV     EAX,EBX
        MOV     EDX,[ESI]
        MOV     ECX,EBP
        ADD     EDX,EDI
        CALL    Move

@@exit:
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
@@nothingToDo:
end;


procedure       _LStrPos{ const substr : AnsiString; const s : AnsiString ) : Integer};
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in s or 0    }

        TEST    EAX,EAX
        JE      @@noWork

        TEST    EDX,EDX
        JE      @@stringEmpty

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX                         { Point ESI to substr           }
        MOV     EDI,EDX                         { Point EDI to s                }

        MOV     ECX,[EDI-skew].StrRec.length    { ECX = Length(s)               }

        PUSH    EDI                             { remember s position to calculate index        }

        MOV     EDX,[ESI-skew].StrRec.length    { EDX = Length(substr)          }

        DEC     EDX                             { EDX = Length(substr) - 1              }
        JS      @@fail                          { < 0 ? return 0                        }
        MOV     AL,[ESI]                        { AL = first char of substr             }
        INC     ESI                             { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX                         { #positions in s to look at    }
                                                { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASB
        JNE     @@fail
        MOV     EBX,ECX                         { save outer loop counter               }
        PUSH    ESI                             { save outer loop substr pointer        }
        PUSH    EDI                             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSB
        POP     EDI                             { restore outer loop s pointer  }
        POP     ESI                             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX                         { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX                             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@stringEmpty:
        XOR     EAX,EAX
        JMP     @@noWork

@@found:
        POP     EDX                             { restore pointer to first char of s    }
        MOV     EAX,EDI                         { EDI points of char after match        }
        SUB     EAX,EDX                         { the difference is the correct index   }
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
@@noWork:
end;


procedure       _LStrSetLength{ var str: AnsiString; newLength: Integer};
asm
        { ->    EAX     Pointer to str  }
        {       EDX new length  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        XOR     EDI,EDI

        TEST    EDX,EDX
        JE      @@setString

        MOV     EAX,[EBX]
        TEST    EAX,EAX
        JE      @@copyString

        CMP     [EAX-skew].StrRec.refCnt,1
        JNE     @@copyString

        SUB     EAX,rOff
        ADD     EDX,rOff+1
        PUSH    EAX
        MOV     EAX,ESP
        CALL    _ReallocMem
        POP     EAX
        ADD     EAX,rOff
        MOV     [EBX],EAX
        MOV     [EAX-skew].StrRec.length,ESI
        MOV     BYTE PTR [EAX+ESI],0
        JMP     @@exit

@@copyString:
        MOV     EAX,EDX
        CALL    _NewAnsiString
        MOV     EDI,EAX

        MOV     EAX,[EBX]
        TEST    EAX,EAX
        JE      @@setString

        MOV     EDX,EDI
        MOV     ECX,[EAX-skew].StrRec.length
        CMP     ECX,ESI
        JL      @@moveString
        MOV     ECX,ESI

@@moveString:
        CALL    Move

@@setString:
        MOV     EAX,EBX
        CALL    _LStrClr
        MOV     [EBX],EDI

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _LStrOfChar{ c: Char; count: Integer): AnsiString };
asm
        { ->    AL      c               }
        {       EDX     count           }
        {       ECX     result  }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        MOV     EAX,ECX
        CALL    _LStrClr

        TEST    ESI,ESI
    JLE @@exit

        MOV     EAX,ESI
        CALL    _NewAnsiString

        MOV     [EDI],EAX

        MOV     EDX,ESI
        MOV     CL,BL

        CALL    _FillChar

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX

end;


procedure _Write0LString{ VAR t: Text; s: AnsiString };
asm
        { ->    EAX     Pointer to text record  }
        {       EDX     Pointer to AnsiString   }

        XOR     ECX,ECX
        JMP     _WriteLString
end;


procedure _WriteLString{ VAR t: Text; s: AnsiString; width: Longint };
asm
        { ->    EAX     Pointer to text record  }
        {       EDX     Pointer to AnsiString   }
        {       ECX     Field width             }

        PUSH    EBX

        MOV     EBX,EDX

        MOV     EDX,ECX
        XOR     ECX,ECX
        TEST    EBX,EBX
        JE      @@skip
        MOV     ECX,[EBX-skew].StrRec.length
        SUB     EDX,ECX
@@skip:
        PUSH    ECX
        CALL    _WriteSpaces
        POP     ECX

        MOV     EDX,EBX
        POP     EBX
        JMP     _WriteBytes
end;


procedure       _ReadLString{var t: Text; var str: AnsiString};
asm
        { ->    EAX     pointer to Text         }
        {       EDX     pointer to AnsiString   }

        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EDX

        MOV     EAX,EDX
        CALL    _LStrClr

        SUB     ESP,256

        MOV     EAX,EBX
        MOV     EDX,ESP
        MOV     ECX,255
        CALL    _ReadString

        MOV     EAX,ESI
        MOV     EDX,ESP
        CALL    _LStrFromString

        CMP     byte ptr [ESP],255
        JNE     @@exit
@@loop:

        MOV     EAX,EBX
        MOV     EDX,ESP
        MOV     ECX,255
        CALL    _ReadString

        MOV     EDX,ESP
        PUSH    0
        MOV     EAX,ESP
        CALL    _LStrFromString

        MOV     EAX,ESI
        MOV     EDX,[ESP]
        CALL    _LStrCat

        MOV     EAX,ESP
        CALL    _LStrClr
        POP     EAX

        CMP     byte ptr [ESP],255
        JE      @@loop

@@exit:
        ADD     ESP,256
        POP     ESI
        POP     EBX
end;


procedure WStrError;
asm
        MOV     AL,reOutOfMemory
        JMP     Error
end;


procedure WStrSet(var S: WideString; P: PWideChar);
asm
        MOV     ECX,[EAX]
        MOV     [EAX],EDX
        TEST    ECX,ECX
        JE      @@1
        PUSH    ECX
        CALL    SysFreeString
@@1:
end;


procedure WStrClr;
asm
       JMP _WStrClr
end;

procedure _WStrClr(var S: WideString);
asm
        { ->    EAX     Pointer to WideString  }

        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@1
        MOV     DWORD PTR [EAX],0
        PUSH    EAX
        PUSH    EDX
        CALL    SysFreeString
        POP     EAX
@@1:
end;


procedure WStrArrayClr;
asm
        JMP     _WStrArrayClr;
end;

procedure _WStrArrayClr(var StrArray; Count: Integer);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,EAX
        MOV     ESI,EDX
@@1:    MOV     EAX,[EBX]
        TEST    EAX,EAX
        JE      @@2
        MOV     DWORD PTR [EBX],0
        PUSH    EAX
        CALL    SysFreeString
@@2:    ADD     EBX,4
        DEC     ESI
        JNE     @@1
        POP     ESI
        POP     EBX
end;


procedure _WStrAsg(var Dest: WideString; const Source: WideString);
asm
        { ->    EAX     Pointer to WideString }
        {       EDX     Pointer to data       }
        TEST    EDX,EDX
        JE      _WStrClr
        MOV     ECX,[EDX-4]
        SHR     ECX,1
        JE      _WStrClr
        PUSH    ECX
        PUSH    EDX
        PUSH    EAX
        CALL    SysReAllocStringLen
        TEST    EAX,EAX
        JE      WStrError
end;


procedure _WStrFromPCharLen(var Dest: WideString; Source: PAnsiChar; Length: Integer);
var
  DestLen: Integer;
  Buffer: array[0..1023] of WideChar;
begin
  if Length <= 0 then
  begin
    _WStrClr(Dest);
    Exit;
  end;
  if Length < SizeOf(Buffer) div 2 then
  begin
    DestLen := MultiByteToWideChar(0, 0, Source, Length,
      Buffer, SizeOf(Buffer) div 2);
    if DestLen > 0 then
    begin
      _WStrFromPWCharLen(Dest, Buffer, DestLen);
      Exit;
    end;
  end;
  DestLen := MultiByteToWideChar(0, 0, Source, Length, nil, 0);
  _WStrFromPWCharLen(Dest, nil, DestLen);
  MultiByteToWideChar(0, 0, Source, Length, Pointer(Dest), DestLen);
end;


procedure _WStrFromPWCharLen(var Dest: WideString; Source: PWideChar; Length: Integer);
asm
        { ->    EAX     Pointer to WideString (dest)      }
        {       EDX     Pointer to characters (source)    }
        {       ECX     number of characters  (not bytes) }
        TEST    ECX,ECX
        JE      _WStrClr

        PUSH    EAX

        PUSH    ECX
        PUSH    EDX
        CALL    SysAllocStringLen
        TEST    EAX,EAX
        JE      WStrError

        POP     EDX
        PUSH    [EDX].PWideChar
        MOV     [EDX],EAX

        CALL    SysFreeString
end;


procedure _WStrFromChar(var Dest: WideString; Source: AnsiChar);
asm
        PUSH    EDX
        MOV     EDX,ESP
        MOV     ECX,1
        CALL    _WStrFromPCharLen
        POP     EDX
end;


procedure _WStrFromWChar(var Dest: WideString; Source: WideChar);
asm
        { ->    EAX     Pointer to WideString (dest)   }
        {       EDX     character             (source) }
        PUSH    EDX
        MOV     EDX,ESP
        MOV     ECX,1
        CALL    _WStrFromPWCharLen
        POP     EDX
end;


procedure _WStrFromPChar(var Dest: WideString; Source: PAnsiChar);
asm
        { ->    EAX     Pointer to WideString (dest)   }
        {       EDX     Pointer to character  (source) }
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CL,[EDX+0]
        JE      @@4
        CMP     CL,[EDX+1]
        JE      @@3
        CMP     CL,[EDX+2]
        JE      @@2
        CMP     CL,[EDX+3]
        JE      @@1
        ADD     EDX,4
        JMP     @@0
@@1:    INC     EDX
@@2:    INC     EDX
@@3:    INC     EDX
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
@@5:    JMP     _WStrFromPCharLen
end;


procedure _WStrFromPWChar(var Dest: WideString; Source: PWideChar);
asm
        { ->    EAX     Pointer to WideString (dest)   }
        {       EDX     Pointer to character  (source) }
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@5
        PUSH    EDX
@@0:    CMP     CX,[EDX+0]
        JE      @@4
        CMP     CX,[EDX+2]
        JE      @@3
        CMP     CX,[EDX+4]
        JE      @@2
        CMP     CX,[EDX+6]
        JE      @@1
        ADD     EDX,8
        JMP     @@0
@@1:    ADD     EDX,2
@@2:    ADD     EDX,2
@@3:    ADD     EDX,2
@@4:    MOV     ECX,EDX
        POP     EDX
        SUB     ECX,EDX
        SHR     ECX,1
@@5:    JMP     _WStrFromPWCharLen
end;


procedure _WStrFromString(var Dest: WideString; const Source: ShortString);
asm
        XOR     ECX,ECX
        MOV     CL,[EDX]
        INC     EDX
        JMP     _WStrFromPCharLen
end;


procedure _WStrFromArray(var Dest: WideString; Source: PAnsiChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASB
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _WStrFromPCharLen
end;


procedure _WStrFromWArray(var Dest: WideString; Source: PWideChar; Length: Integer);
asm
        PUSH    EDI
        PUSH    EAX
        PUSH    ECX
        MOV     EDI,EDX
        XOR     EAX,EAX
        REPNE   SCASW
        JNE     @@1
        NOT     ECX
@@1:    POP     EAX
        ADD     ECX,EAX
        POP     EAX
        POP     EDI
        JMP     _WStrFromPWCharLen
end;


procedure _WStrFromLStr(var Dest: WideString; const Source: AnsiString);
asm
        XOR     ECX,ECX
        TEST    EDX,EDX
        JE      @@1
        MOV     ECX,[EDX-4]
@@1:    JMP     _WStrFromPCharLen
end;


procedure _WStrToString(Dest: PShortString; const Source: WideString; MaxLen: Integer);
var
  SourceLen, DestLen: Integer;
  Buffer: array[0..511] of Char;
begin
  SourceLen := Length(Source);
  if SourceLen >= 255 then SourceLen := 255;
  if SourceLen = 0 then DestLen := 0 else
  begin
    DestLen := WideCharToMultiByte(0, 0, Pointer(Source), SourceLen,
      Buffer, SizeOf(Buffer), nil, nil);
    if DestLen > MaxLen then DestLen := MaxLen;
  end;
  Dest^[0] := Chr(DestLen);
  if DestLen > 0 then Move(Buffer, Dest^[1], DestLen);
end;


function _WStrToPWChar(const S: WideString): PWideChar;
asm
        TEST    EAX,EAX
        JE      @@1
        RET
        NOP
@@0:    DW      0
@@1:    MOV     EAX,OFFSET @@0
end;


function _WStrLen(const S: WideString): Integer;
asm
        { ->    EAX     Pointer to WideString data }
        TEST    EAX,EAX
        JE      @@1
        MOV     EAX,[EAX-4]
        SHR     EAX,1
@@1:
end;


procedure _WStrCat(var Dest: WideString; const Source: WideString);
var
  DestLen, SourceLen: Integer;
  NewStr: PWideChar;
begin
  SourceLen := Length(Source);
  if SourceLen <> 0 then
  begin
    DestLen := Length(Dest);
    NewStr := _NewWideString(DestLen + SourceLen);
    if DestLen > 0 then
      Move(Pointer(Dest)^, NewStr^, DestLen * 2);
    Move(Pointer(Source)^, NewStr[DestLen], SourceLen * 2);
    WStrSet(Dest, NewStr);
  end;
end;


procedure _WStrCat3(var Dest: WideString; const Source1, Source2: WideString);
var
  Source1Len, Source2Len: Integer;
  NewStr: PWideChar;
begin
  Source1Len := Length(Source1);
  Source2Len := Length(Source2);
  if (Source1Len <> 0) or (Source2Len <> 0) then
  begin
    NewStr := _NewWideString(Source1Len + Source2Len);
    Move(Pointer(Source1)^, Pointer(NewStr)^, Source1Len * 2);
    Move(Pointer(Source2)^, NewStr[Source1Len], Source2Len * 2);
    WStrSet(Dest, NewStr);
  end;
end;


procedure _WStrCatN{var Dest: WideString; ArgCnt: Integer; ...};
asm
        {     ->EAX = Pointer to dest }
        {       EDX = number of args (>= 3) }
        {       [ESP+4], [ESP+8], ... crgCnt WideString arguments }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDX
        PUSH    EAX
        MOV     EBX,EDX

        XOR     EAX,EAX
@@loop1:
        MOV     ECX,[ESP+EDX*4+4*4]
        TEST    ECX,ECX
        JE      @@1
        ADD     EAX,[ECX-4]
@@1:
        DEC     EDX
        JNE     @@loop1

        SHR     EAX,1
        CALL    _NewWideString
        PUSH    EAX
        MOV     ESI,EAX

@@loop2:
        MOV     EAX,[ESP+EBX*4+5*4]
        MOV     EDX,ESI
        TEST    EAX,EAX
        JE      @@2
        MOV     ECX,[EAX-4]
        ADD     ESI,ECX
        CALL    Move
@@2:
        DEC     EBX
        JNE     @@loop2

        POP     EDX
        POP     EAX
        CALL    WStrSet

        POP     EDX
        POP     ESI
        POP     EBX
        POP     EAX
        LEA     ESP,[ESP+EDX*4]
        JMP     EAX
end;


procedure _WStrCmp{left: WideString; right: WideString};
asm
{     ->EAX = Pointer to left string    }
{       EDX = Pointer to right string   }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX

        CMP     EAX,EDX
        JE      @@exit

        TEST    ESI,ESI
        JE      @@str1null

        TEST    EDI,EDI
        JE      @@str2null

        MOV     EAX,[ESI-4]
        MOV     EDX,[EDI-4]

        SUB     EAX,EDX { eax = len1 - len2 }
        JA      @@skip1
        ADD     EDX,EAX { edx = len2 + (len1 - len2) = len1     }

@@skip1:
        PUSH    EDX
        SHR     EDX,2
        JE      @@cmpRest
@@longLoop:
        MOV     ECX,[ESI]
        MOV     EBX,[EDI]
        CMP     ECX,EBX
        JNE     @@misMatch
        DEC     EDX
        JE      @@cmpRestP4
        MOV     ECX,[ESI+4]
        MOV     EBX,[EDI+4]
        CMP     ECX,EBX
        JNE     @@misMatch
        ADD     ESI,8
        ADD     EDI,8
        DEC     EDX
        JNE     @@longLoop
        JMP     @@cmpRest
@@cmpRestP4:
        ADD     ESI,4
        ADD     EDI,4
@@cmpRest:
        POP     EDX
        AND     EDX,2
        JE      @@equal

        MOV     CX,[ESI]
        MOV     BX,[EDI]
        CMP     CX,BX
        JNE     @@exit

@@equal:
        ADD     EAX,EAX
        JMP     @@exit

@@str1null:
        MOV     EDX,[EDI-4]
        SUB     EAX,EDX
        JMP     @@exit

@@str2null:
        MOV     EAX,[ESI-4]
        SUB     EAX,EDX
        JMP     @@exit

@@misMatch:
        POP     EDX
        CMP     CX,BX
        JNE     @@exit
        SHR     ECX,16
        SHR     EBX,16
        CMP     CX,BX

@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;


function _NewWideString(Length: Integer): PWideChar;
asm
        TEST    EAX,EAX
        JE      @@1
        PUSH    EAX
        PUSH    0
        CALL    SysAllocStringLen
        TEST    EAX,EAX
        JE      WStrError
@@1:
end;


function _WStrCopy(const S: WideString; Index, Count: Integer): WideString;
var
  L, N: Integer;
begin
  L := Length(S);
  if Index < 1 then Index := 0 else
  begin
    Dec(Index);
    if Index > L then Index := L;
  end;
  if Count < 0 then N := 0 else
  begin
    N := L - Index;
    if N > Count then N := Count;
  end;
  _WStrFromPWCharLen(Result, PWideChar(Pointer(S)) + Index, N);
end;


procedure _WStrDelete(var S: WideString; Index, Count: Integer);
var
  L, N: Integer;
  NewStr: PWideChar;
begin
  L := Length(S);
  if (L > 0) and (Index >= 1) and (Index <= L) and (Count > 0) then
  begin
    Dec(Index);
    N := L - Index - Count;
    if N < 0 then N := 0;
    if (Index = 0) and (N = 0) then NewStr := nil else
    begin
      NewStr := _NewWideString(Index + N);
      if Index > 0 then
        Move(Pointer(S)^, NewStr^, Index * 2);
      if N > 0 then
        Move(PWideChar(Pointer(S))[L - N], NewStr[Index], N * 2);
    end;
    WStrSet(S, NewStr);
  end;
end;


procedure _WStrInsert(const Source: WideString; var Dest: WideString; Index: Integer);
var
  SourceLen, DestLen: Integer;
  NewStr: PWideChar;
begin
  SourceLen := Length(Source);
  if SourceLen > 0 then
  begin
    DestLen := Length(Dest);
    if Index < 1 then Index := 0 else
    begin
      Dec(Index);
      if Index > DestLen then Index := DestLen;
    end;
    NewStr := _NewWideString(DestLen + SourceLen);
    if Index > 0 then
      Move(Pointer(Dest)^, NewStr^, Index * 2);
    Move(Pointer(Source)^, NewStr[Index], SourceLen * 2);
    if Index < DestLen then
      Move(PWideChar(Pointer(Dest))[Index], NewStr[Index + SourceLen],
        (DestLen - Index) * 2);
    WStrSet(Dest, NewStr);
  end;
end;


procedure _WStrPos{ const substr : WideString; const s : WideString ) : Integer};
asm
{     ->EAX     Pointer to substr               }
{       EDX     Pointer to string               }
{     <-EAX     Position of substr in s or 0    }

        TEST    EAX,EAX
        JE      @@noWork

        TEST    EDX,EDX
        JE      @@stringEmpty

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX                         { Point ESI to substr           }
        MOV     EDI,EDX                         { Point EDI to s                }

        MOV     ECX,[EDI-4]                     { ECX = Length(s)               }
        SHR     ECX,1

        PUSH    EDI                             { remember s position to calculate index        }

        MOV     EDX,[ESI-4]                     { EDX = Length(substr)          }
        SHR     EDX,1

        DEC     EDX                             { EDX = Length(substr) - 1              }
        JS      @@fail                          { < 0 ? return 0                        }
        MOV     AX,[ESI]                        { AL = first char of substr             }
        ADD     ESI,2                           { Point ESI to 2'nd char of substr      }

        SUB     ECX,EDX                         { #positions in s to look at    }
                                                { = Length(s) - Length(substr) + 1      }
        JLE     @@fail
@@loop:
        REPNE   SCASW
        JNE     @@fail
        MOV     EBX,ECX                         { save outer loop counter               }
        PUSH    ESI                             { save outer loop substr pointer        }
        PUSH    EDI                             { save outer loop s pointer             }

        MOV     ECX,EDX
        REPE    CMPSW
        POP     EDI                             { restore outer loop s pointer  }
        POP     ESI                             { restore outer loop substr pointer     }
        JE      @@found
        MOV     ECX,EBX                         { restore outer loop counter    }
        JMP     @@loop

@@fail:
        POP     EDX                             { get rid of saved s pointer    }
        XOR     EAX,EAX
        JMP     @@exit

@@stringEmpty:
        XOR     EAX,EAX
        JMP     @@noWork

@@found:
        POP     EDX                             { restore pointer to first char of s    }
        MOV     EAX,EDI                         { EDI points of char after match        }
        SUB     EAX,EDX                         { the difference is the correct index   }
        SHR     EAX,1
@@exit:
        POP     EDI
        POP     ESI
        POP     EBX
@@noWork:
end;


procedure _WStrSetLength(var S: WideString; NewLength: Integer);
var
  NewStr: PWideChar;
  Count: Integer;
begin
  NewStr := nil;
  if NewLength > 0 then
  begin
    NewStr := _NewWideString(NewLength);
    Count := Length(S);
    if Count > 0 then
    begin
      if Count > NewLength then Count := NewLength;
      Move(Pointer(S)^, NewStr^, Count * 2);
    end;
  end;
  WStrSet(S, NewStr);
end;


function _WStrOfWChar(Ch: WideChar; Count: Integer): WideString;
var
  P: PWideChar;
begin
  _WStrFromPWCharLen(Result, nil, Count);
  P := Pointer(Result);
  while Count > 0 do
  begin
    Dec(Count);
    P[Count] := Ch;
  end;
end;

procedure WStrAddRef;
asm
        JMP _WStrAddRef
end;

procedure _WStrAddRef{var str: WideString};
asm
        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@1
        PUSH    EAX
        MOV     ECX,[EDX-4]
        SHR     ECX,1
        PUSH    ECX
        PUSH    EDX
        CALL    SysAllocStringLen
        POP     EDX
        TEST    EAX,EAX
        JE      WStrError
        MOV     [EDX],EAX
@@1:
end;


procedure       _InitializeRecord{ p: Pointer; typeInfo: Pointer };
asm
        { ->    EAX pointer to record to be initialized }
        {       EDX pointer to type info                }

        XOR     ECX,ECX

        PUSH    EBX
        MOV     CL,[EDX+1]                  { type name length }

        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        LEA     ESI,[EDX+ECX+2+8]           { address of destructable fields }
        MOV     EDI,[EDX+ECX+2+4]           { number of destructable fields }

@@loop:

        MOV     EDX,[ESI]
        MOV     EAX,[ESI+4]
        ADD     EAX,EBX
        MOV     EDX,[EDX]
        CALL    _Initialize
        ADD     ESI,8
        DEC     EDI
        JG      @@loop

        POP     EDI
        POP     ESI
        POP     EBX
end;


const
  tkLString   = 10;
  tkWString   = 11;
  tkVariant   = 12;
  tkArray     = 13;
  tkRecord    = 14;
  tkInterface = 15;
  tkDynArray  = 17;

procedure       _InitializeArray{ p: Pointer; typeInfo: Pointer; elemCount: Longint};
asm
        { ->    EAX     pointer to data to be initialized       }
        {       EDX     pointer to type info describing data    }
        {       ECX number of elements of that type             }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[ESI+1]
        XOR     ECX,ECX

        CMP     AL,tkLString
        JE      @@LString
        CMP     AL,tkWString
        JE      @@WString
        CMP     AL,tkVariant
        JE      @@Variant
        CMP     AL,tkArray
        JE      @@Array
        CMP     AL,tkRecord
        JE      @@Record
        CMP     AL,tkInterface
  JE      @@Interface
  CMP AL,tkDynArray
  JE  @@DynArray
        MOV     AL,reInvalidPtr
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
@@WString:
@@Interface:
@@DynArray:
        MOV     [EBX],ECX
        ADD     EBX,4
        DEC     EDI
        JG      @@LString
        JMP     @@exit

@@Variant:
        MOV     [EBX   ],ECX
        MOV     [EBX+ 4],ECX
        MOV     [EBX+ 8],ECX
        MOV     [EBX+12],ECX
        ADD     EBX,16
        DEC     EDI
        JG      @@Variant
        JMP     @@exit

@@Array:
        PUSH    EBP
        MOV     EBP,EDX
@@ArrayLoop:
        MOV     EDX,[ESI+EBP+2+8]
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     ECX,[ESI+EBP+2+4]
        MOV     EDX,[EDX]
        CALL    _InitializeArray
        DEC     EDI
        JG      @@ArrayLoop
        POP     EBP
        JMP     @@exit

@@Record:
        PUSH    EBP
        MOV     EBP,EDX
@@RecordLoop:
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     EDX,ESI
        CALL    _InitializeRecord
        DEC     EDI
        JG      @@RecordLoop
        POP     EBP

@@exit:

        POP     EDI
        POP     ESI
    POP EBX
end;


procedure       _Initialize{ p: Pointer; typeInfo: Pointer};
asm
        MOV     ECX,1
        JMP     _InitializeArray
end;

procedure       _FinalizeRecord{ p: Pointer; typeInfo: Pointer };
asm
        { ->    EAX pointer to record to be finalized   }
        {       EDX pointer to type info                }

        XOR     ECX,ECX

        PUSH    EBX
        MOV     CL,[EDX+1]

        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        LEA     ESI,[EDX+ECX+2+8]
        MOV     EDI,[EDX+ECX+2+4]

@@loop:

        MOV     EDX,[ESI]
        MOV     EAX,[ESI+4]
        ADD     EAX,EBX
        MOV     EDX,[EDX]
        CALL    _Finalize
        ADD     ESI,8
        DEC     EDI
        JG      @@loop

        MOV     EAX,EBX

        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _FinalizeArray{ p: Pointer; typeInfo: Pointer; elemCount: Longint};
asm
        { ->    EAX     pointer to data to be finalized         }
        {       EDX     pointer to type info describing data    }
        {       ECX number of elements of that type             }

        CMP     ECX, 0                        { no array -> nop }
        JE      @@zerolength

        PUSH    EAX
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[ESI+1]

        CMP     AL,tkLString
        JE      @@LString

        CMP     AL,tkWString
        JE      @@WString

        CMP     AL,tkVariant
        JE      @@Variant

        CMP     AL,tkArray
        JE      @@Array

        CMP     AL,tkRecord
        JE      @@Record

        CMP     AL,tkInterface
        JE      @@Interface

        CMP     AL,tkDynArray
        JE      @@DynArray
        POP     EDI
        POP     ESI
        POP     EBX
        POP      EAX
        MOV     AL,reInvalidPtr
        JMP     Error

@@LString:
        CMP     ECX,1
        MOV     EAX,EBX
        JG      @@LStringArray
        CALL    _LStrClr
        JMP     @@exit
@@LStringArray:
        MOV     EDX,ECX
        CALL    _LStrArrayClr
        JMP     @@exit

@@WString:
        CMP     ECX,1
        MOV     EAX,EBX
        JG      @@WStringArray
        //CALL    _WStrClr
        CALL    [WStrClrProc]
        JMP     @@exit
@@WStringArray:
        MOV     EDX,ECX
        //CALL    _WStrArrayClr
        CALL    [WStrArrayClrProc]
        JMP     @@exit

@@Variant:
        MOV     EAX,EBX
        ADD     EBX,16
        //CALL    _VarClr
        CALL    [VarClrProc]
        DEC     EDI
        JG      @@Variant
        JMP     @@exit

@@Array:
        PUSH    EBP
        MOV     EBP,EDX
@@ArrayLoop:
        MOV     EDX,[ESI+EBP+2+8]
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     ECX,[ESI+EBP+2+4]
        MOV     EDX,[EDX]
        CALL    _FinalizeArray
        DEC     EDI
        JG      @@ArrayLoop
        POP     EBP
        JMP     @@exit

@@Record:
        PUSH    EBP
        MOV     EBP,EDX
@@RecordLoop:
        { inv: EDI = number of array elements to finalize }

        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     EDX,ESI
        CALL    _FinalizeRecord
        DEC     EDI
        JG      @@RecordLoop
        POP     EBP
        JMP     @@exit

@@Interface:
        MOV     EAX,EBX
        ADD     EBX,4
        CALL    _IntfClear
        DEC     EDI
        JG      @@Interface
        JMP     @@exit

@@DynArray:
        MOV     EAX,EBX
        MOV     EDX,ESI
        ADD     EBX,4
        CALL    _DynArrayClear
        DEC     EDI
        JG      @@DynArray

@@exit:

        POP     EDI
        POP     ESI
        POP     EBX
        POP     EAX
@@zerolength:
end;


procedure       _Finalize{ p: Pointer; typeInfo: Pointer};
asm
        MOV     ECX,1
        JMP     _FinalizeArray
end;

procedure       _AddRefRecord{ p: Pointer; typeInfo: Pointer };
asm
        { ->    EAX pointer to record to be referenced  }
        {       EDX pointer to type info        }

        XOR     ECX,ECX

        PUSH    EBX
        MOV     CL,[EDX+1]

        PUSH    ESI
        PUSH    EDI

        MOV     EBX,EAX
        LEA     ESI,[EDX+ECX+2+8]
        MOV     EDI,[EDX+ECX+2+4]

@@loop:

        MOV     EDX,[ESI]
        MOV     EAX,[ESI+4]
        ADD     EAX,EBX
        MOV     EDX,[EDX]
        CALL    _AddRef
        ADD     ESI,8
        DEC     EDI
        JG      @@loop

        POP     EDI
        POP     ESI
        POP     EBX
end;

procedure DummyProc;
begin
end;

procedure       _AddRefArray{ p: Pointer; typeInfo: Pointer; elemCount: Longint};
asm
        { ->    EAX     pointer to data to be referenced        }
        {       EDX     pointer to type info describing data    }
        {       ECX number of elements of that type             }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX

        XOR     EDX,EDX
        MOV     AL,[ESI]
        MOV     DL,[ESI+1]

        CMP     AL,tkLString
        JE      @@LString
        CMP     AL,tkWString
        JE      @@WString
        CMP     AL,tkVariant
        JE      @@Variant
        CMP     AL,tkArray
        JE      @@Array
        CMP     AL,tkRecord
        JE      @@Record
        CMP     AL,tkInterface
        JE      @@Interface
        CMP     AL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
        MOV     EAX,[EBX]
        ADD     EBX,4
        CALL    _LStrAddRef
        DEC     EDI
        JG      @@LString
        JMP     @@exit

@@WString:
        MOV     EAX,EBX
        ADD     EBX,4
        //CALL    _WStrAddRef
        CALL    [WStrAddRefProc]
        DEC     EDI
        JG      @@WString
        JMP     @@exit

@@Variant:
        MOV     EAX,EBX
        ADD     EBX,16
        //CALL    _VarAddRef
        CALL    [VarAddRefProc]
        DEC     EDI
        JG      @@Variant
        JMP     @@exit

@@Array:
        PUSH    EBP
        MOV     EBP,EDX
@@ArrayLoop:
        MOV     EDX,[ESI+EBP+2+8]
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     ECX,[ESI+EBP+2+4]
        MOV     EDX,[EDX]
        CALL    _AddRefArray
        DEC     EDI
        JG      @@ArrayLoop
        POP     EBP
        JMP     @@exit

@@Record:
        PUSH    EBP
        MOV     EBP,EDX
@@RecordLoop:
        MOV     EAX,EBX
        ADD     EBX,[ESI+EBP+2]
        MOV     EDX,ESI
        CALL    _AddRefRecord
        DEC     EDI
        JG      @@RecordLoop
        POP     EBP
        JMP     @@exit

@@Interface:
        MOV     EAX,[EBX]
        ADD     EBX,4
        CALL    _IntfAddRef
        DEC     EDI
        JG      @@Interface
        JMP     @@exit

@@DynArray:
        MOV     EAX,[EBX]
        ADD     EBX,4
        CALL    _DynArrayAddRef
        DEC     EDI
        JG      @@DynArray
@@exit:

        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _AddRef{ p: Pointer; typeInfo: Pointer};
asm
        MOV     ECX,1
        JMP     _AddRefArray
end;


procedure       _CopyRecord{ dest, source, typeInfo: Pointer };
asm
        { ->    EAX pointer to dest             }
        {       EDX pointer to source           }
        {       ECX pointer to typeInfo         }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,EAX
        MOV     ESI,EDX

        XOR     EAX,EAX
        MOV     AL,[ECX+1]

        LEA     EDI,[ECX+EAX+2+8]
        MOV     EBP,[EDI-4]
        XOR     EAX,EAX
        MOV     ECX,[EDI-8]
        PUSH    ECX
@@loop:
        MOV     ECX,[EDI+4]
        SUB     ECX,EAX
        JLE     @@nomove1
        MOV     EDX,EAX
        ADD     EAX,ESI
        ADD     EDX,EBX
        CALL    Move
@@noMove1:
        MOV     EAX,[EDI+4]

        MOV     EDX,[EDI]
        MOV     EDX,[EDX]
        MOV     CL,[EDX]

        CMP     CL,tkLString
        JE      @@LString
        CMP     CL,tkWString
        JE      @@WString
        CMP     CL,tkVariant
        JE      @@Variant
        CMP     CL,tkArray
        JE      @@Array
        CMP     CL,tkRecord
        JE      @@Record
        CMP     CL,tkInterface
        JE      @@Interface
        CMP     CL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _LStrAsg
        MOV     EAX,4
        JMP     @@common

@@WString:
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _WStrAsg
        MOV     EAX,4
        JMP     @@common

@@Variant:
        LEA     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _VarCopy
        MOV     EAX,16
        JMP     @@common

@@Array:
        XOR     ECX,ECX
        MOV     CL,[EDX+1]
        PUSH    dword ptr [EDX+ECX+2]
        PUSH    dword ptr [EDX+ECX+2+4]
        MOV     ECX,[EDX+ECX+2+8]
        MOV     ECX,[ECX]
        LEA     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _CopyArray
        POP     EAX
        JMP     @@common

@@Record:
        XOR     ECX,ECX
        MOV     CL,[EDX+1]
        MOV     ECX,[EDX+ECX+2]
        PUSH    ECX
        MOV     ECX,EDX
        LEA     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _CopyRecord
        POP     EAX
        JMP     @@common

@@Interface:
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _IntfCopy
        MOV     EAX,4
        JMP     @@common

@@DynArray:
        MOV     ECX,EDX
        MOV     EDX,[ESI+EAX]
        ADD     EAX,EBX
        CALL    _DynArrayAsg
        MOV     EAX,4

@@common:
        ADD     EAX,[EDI+4]
        ADD     EDI,8
        DEC     EBP
        JNZ     @@loop

        POP     ECX
        SUB     ECX,EAX
        JLE     @@noMove2
        LEA     EDX,[EBX+EAX]
        ADD     EAX,ESI
        CALL    Move
@@noMove2:

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;


procedure       _CopyObject{ dest, source: Pointer; vmtPtrOffs: Longint; typeInfo: Pointer };
asm
        { ->    EAX pointer to dest             }
        {       EDX pointer to source           }
        {       ECX offset of vmt in object     }
        {       [ESP+4] pointer to typeInfo     }

        ADD     ECX,EAX                         { pointer to dest vmt }
        PUSH    dword ptr [ECX]                 { save dest vmt }
        PUSH    ECX
        MOV     ECX,[ESP+4+4+4]
        CALL    _CopyRecord
        POP     ECX
        POP     dword ptr [ECX]                 { restore dest vmt }
        RET     4

end;

procedure       _CopyArray{ dest, source, typeInfo: Pointer; cnt: Integer };
asm
        { ->    EAX pointer to dest             }
        {       EDX pointer to source           }
        {       ECX pointer to typeInfo         }
        {       [ESP+4] count                   }
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     EBX,EAX
        MOV     ESI,EDX
        MOV     EDI,ECX
        MOV     EBP,[ESP+4+4*4]

        MOV     CL,[EDI]

        CMP     CL,tkLString
        JE      @@LString
        CMP     CL,tkWString
        JE      @@WString
        CMP     CL,tkVariant
        JE      @@Variant
        CMP     CL,tkArray
        JE      @@Array
        CMP     CL,tkRecord
        JE      @@Record
        CMP     CL,tkInterface
        JE      @@Interface
        CMP     CL,tkDynArray
        JE      @@DynArray
        MOV     AL,reInvalidPtr
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     Error

@@LString:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        CALL    _LStrAsg
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@LString
        JMP     @@exit

@@WString:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        CALL    _WStrAsg
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@WString
        JMP     @@exit

@@Variant:
        MOV     EAX,EBX
        MOV     EDX,ESI
        CALL    _VarCopy
        ADD     EBX,16
        ADD     ESI,16
        DEC     EBP
        JNE     @@Variant
        JMP     @@exit

@@Array:
        XOR     ECX,ECX
        MOV     CL,[EDI+1]
        LEA     EDI,[EDI+ECX+2]
@@ArrayLoop:
        MOV     EAX,EBX
        MOV     EDX,ESI
        MOV     ECX,[EDI+8]
        PUSH    dword ptr [EDI+4]
        CALL    _CopyArray
        ADD     EBX,[EDI]
        ADD     ESI,[EDI]
        DEC     EBP
        JNE     @@ArrayLoop
        JMP     @@exit

@@Record:
        MOV     EAX,EBX
        MOV     EDX,ESI
        MOV     ECX,EDI
        CALL    _CopyRecord
        XOR     EAX,EAX
        MOV     AL,[EDI+1]
        ADD     EBX,[EDI+EAX+2]
        ADD     ESI,[EDI+EAX+2]
        DEC     EBP
        JNE     @@Record
        JMP     @@exit

@@Interface:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        CALL    _IntfCopy
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@Interface
        JMP     @@exit

@@DynArray:
        MOV     EAX,EBX
        MOV     EDX,[ESI]
        MOV     ECX,EDI
        CALL    _DynArrayAsg
        ADD     EBX,4
        ADD     ESI,4
        DEC     EBP
        JNE     @@DynArray

@@exit:
        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
        RET     4
end;


procedure       _New{ size: Longint; typeInfo: Pointer};
asm
        { ->    EAX size of object to allocate  }
        {       EDX pointer to typeInfo         }

        PUSH    EDX
        CALL    _GetMem
        POP     EDX
        TEST    EAX,EAX
        JE      @@exit
        PUSH    EAX
        CALL    _Initialize
        POP     EAX
@@exit:
end;

procedure       _Dispose{ p: Pointer; typeInfo: Pointer};
asm
        { ->    EAX     Pointer to object to be disposed        }
        {       EDX     Pointer to type info            }

        PUSH    EAX
        CALL    _Finalize
        POP     EAX
        CALL    _FreeMem
end;

{ ----------------------------------------------------- }
{       Wide character support                          }
{ ----------------------------------------------------- }

function WideCharToString(Source: PWideChar): string;
begin
  WideCharToStrVar(Source, Result);
end;

function WideCharLenToString(Source: PWideChar; SourceLen: Integer): string;
begin
  WideCharLenToStrVar(Source, SourceLen, Result);
end;

procedure WideCharToStrVar(Source: PWideChar; var Dest: string);
var
  SourceLen: Integer;
begin
  SourceLen := 0;
  while Source[SourceLen] <> #0 do Inc(SourceLen);
  WideCharLenToStrVar(Source, SourceLen, Dest);
end;

procedure WideCharLenToStrVar(Source: PWideChar; SourceLen: Integer;
  var Dest: string);
var
  DestLen: Integer;
  Buffer: array[0..2047] of Char;
begin
  if SourceLen = 0 then
    Dest := ''
  else
    if SourceLen < SizeOf(Buffer) div 2 then
      SetString(Dest, Buffer, WideCharToMultiByte(0, 0,
        Source, SourceLen, Buffer, SizeOf(Buffer), nil, nil))
    else
    begin
      DestLen := WideCharToMultiByte(0, 0, Source, SourceLen,
        nil, 0, nil, nil);
      SetString(Dest, nil, DestLen);
      WideCharToMultiByte(0, 0, Source, SourceLen, Pointer(Dest),
        DestLen, nil, nil);
    end;
end;

function StringToWideChar(const Source: string; Dest: PWideChar;
  DestSize: Integer): PWideChar;
begin
  Dest[MultiByteToWideChar(0, 0, PChar(Source), Length(Source),
    Dest, DestSize - 1)] := #0;
  Result := Dest;
end;

{ ----------------------------------------------------- }
{       OLE string support                              }
{ ----------------------------------------------------- }

function OleStrToString(Source: PWideChar): string;
begin
  OleStrToStrVar(Source, Result);
end;

procedure OleStrToStrVar(Source: PWideChar; var Dest: string);
begin
  WideCharLenToStrVar(Source, SysStringLen(WideString(Pointer(Source))), Dest);
end;

function StringToOleStr(const Source: string): PWideChar;
var
  SourceLen, ResultLen: Integer;
  Buffer: array[0..1023] of WideChar;
begin
  SourceLen := Length(Source);
  if Length(Source) < SizeOf(Buffer) div 2 then
    Result := SysAllocStringLen(Buffer, MultiByteToWideChar(0, 0,
      PChar(Source), SourceLen, Buffer, SizeOf(Buffer) div 2))
  else
  begin
    ResultLen := MultiByteToWideChar(0, 0,
      Pointer(Source), SourceLen, nil, 0);
    Result := SysAllocStringLen(nil, ResultLen);
    MultiByteToWideChar(0, 0, Pointer(Source), SourceLen,
      Result, ResultLen);
  end;
end;

{ ----------------------------------------------------- }
{       Variant support                                 }
{ ----------------------------------------------------- }

type
  TBaseType = (btErr, btNul, btInt, btFlt, btCur, btStr, btBol, btDat);

const
  varLast = varByte;

const
  BaseTypeMap: array[0..varLast] of TBaseType = (
    btErr,  { varEmpty    }
    btNul,  { varNull     }
    btInt,  { varSmallint }
    btInt,  { varInteger  }
    btFlt,  { varSingle   }
    btFlt,  { varDouble   }
    btCur,  { varCurrency }
    btDat,  { varDate     }
    btStr,  { varOleStr   }
    btErr,  { varDispatch }
    btErr,  { varError    }
    btBol,  { varBoolean  }
    btErr,  { varVariant  }
    btErr,  { varUnknown  }
    btErr,  { vt_decimal  }
    btErr,  { undefined   }
    btErr,  { vt_i1       }
    btInt); { varByte     }

const
  OpTypeMap: array[TBaseType, TBaseType] of TBaseType = (
    (btErr, btErr, btErr, btErr, btErr, btErr, btErr, btErr),
    (btErr, btNul, btNul, btNul, btNul, btNul, btNul, btNul),
    (btErr, btNul, btInt, btFlt, btCur, btFlt, btInt, btDat),
    (btErr, btNul, btFlt, btFlt, btCur, btFlt, btFlt, btDat),
    (btErr, btNul, btCur, btCur, btCur, btCur, btCur, btDat),
    (btErr, btNul, btFlt, btFlt, btCur, btStr, btBol, btDat),
    (btErr, btNul, btInt, btFlt, btCur, btBol, btBol, btDat),
    (btErr, btNul, btDat, btDat, btDat, btDat, btDat, btDat));

const
  C10000: Single = 10000;

const
  opAdd  = 0;
  opSub  = 1;
  opMul  = 2;
  opDvd  = 3;
  opDiv  = 4;
  opMod  = 5;
  opShl  = 6;
  opShr  = 7;
  opAnd  = 8;
  opOr   = 9;
  opXor  = 10;

procedure _DispInvoke;
asm
        { ->    [ESP+4] Pointer to result or nil }
        {       [ESP+8] Pointer to variant }
        {       [ESP+12]        Pointer to call descriptor }
        {       [ESP+16]        Additional parameters, if any }
        JMP     VarDispProc
end;


procedure _DispInvokeError;
asm
        MOV     AL,reVarDispatch
        JMP     Error
end;

procedure VarCastError;
asm
        MOV     AL,reVarTypeCast
        JMP     Error
end;

procedure VarInvalidOp;
asm
        MOV     AL,reVarInvalidOp
        JMP     Error
end;

procedure _VarClear(var V : Variant);
asm
        XOR     EDX,EDX
        MOV     DX,[EAX].TVarData.VType
        TEST    EDX,varByRef
        JNE     @@2
        CMP     EDX,varOleStr
        JB      @@2
        CMP     EDX,varString
        JE      @@1
        CMP     EDX,varAny
        JNE     @@3
        JMP     [ClearAnyProc]
@@1:    MOV     [EAX].TVarData.VType,varEmpty
        ADD     EAX,OFFSET TVarData.VString
        JMP     _LStrClr
@@2:    MOV     [EAX].TVarData.VType,varEmpty
        RET
@@3:    PUSH    EAX
        CALL    VariantClear
end;

procedure _VarCopy(var Dest : Variant; const Source: Variant);
asm
        CMP     EAX,EDX
        JE      @@9
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@3
        PUSH    EAX
        PUSH    EDX
        CMP     [EAX].TVarData.VType,varString
        JE      @@1
        CMP     [EAX].TVarData.VType,varAny
        JE      @@0
        PUSH    EAX
        CALL    VariantClear
        JMP     @@2
@@0:    CALL    [ClearAnyProc]
        JMP     @@2
@@1:    ADD     EAX,OFFSET TVarData.VString
        CALL    _LStrClr
@@2:    POP     EDX
        POP     EAX
@@3:    CMP     [EDX].TVarData.VType,varOleStr
        JAE     @@5
@@4:    MOV     ECX,[EDX]
        MOV     [EAX],ECX
        MOV     ECX,[EDX+8]
        MOV     [EAX+8],ECX
        MOV     ECX,[EDX+12]
        MOV     [EAX+12],ECX
        RET
@@5:    CMP     [EDX].TVarData.VType,varString
        JE      @@6
        CMP     [EDX].TVarData.VType,varAny
        JNE     @@8
        PUSH    EAX
        CALL    @@4
        POP     EAX
        JMP     [RefAnyProc]
@@6:    MOV     EDX,[EDX].TVarData.VString
        OR      EDX,EDX
        JE      @@7
        MOV     ECX,[EDX-skew].StrRec.refCnt
        INC     ECX
        JLE     @@7
{X LOCK} INC     [EDX-skew].StrRec.refCnt
@@7:    MOV     [EAX].TVarData.VType,varString
        MOV     [EAX].TVarData.VString,EDX
        RET
@@8:    MOV     [EAX].TVarData.VType,varEmpty
        PUSH    EDX
        PUSH    EAX
        CALL    VariantCopyInd
        OR      EAX,EAX
        JNE     VarInvalidOp
@@9:
end;

procedure VarCopyNoInd(var Dest: Variant; const Source: Variant);
asm
        CMP     EAX,EDX
        JE      @@9
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@3
        PUSH    EAX
        PUSH    EDX
        CMP     [EAX].TVarData.VType,varString
        JE      @@1
        CMP     [EAX].TVarData.VType,varAny
        JE      @@0
        PUSH    EAX
        CALL    VariantClear
        JMP     @@2
@@0:    CALL    [ClearAnyProc]
        JMP     @@2
@@1:    ADD     EAX,OFFSET TVarData.VString
        CALL    _LStrClr
@@2:    POP     EDX
        POP     EAX
@@3:    CMP     [EDX].TVarData.VType,varOleStr
        JAE     @@5
@@4:    MOV     ECX,[EDX]
        MOV     [EAX],ECX
        MOV     ECX,[EDX+8]
        MOV     [EAX+8],ECX
        MOV     ECX,[EDX+12]
        MOV     [EAX+12],ECX
        RET
@@5:    CMP     [EDX].TVarData.VType,varString
        JNE     @@6
        CMP     [EDX].TVarData.VType,varAny
        JNE     @@8
        CALL    @@4
        JMP     [RefAnyProc]
@@6:    MOV     EDX,[EDX].TVarData.VString
        OR      EDX,EDX
        JE      @@7
        MOV     ECX,[EDX-skew].StrRec.refCnt
        INC     ECX
        JLE     @@7
{X LOCK} INC     [EDX-skew].StrRec.refCnt
@@7:    MOV     [EAX].TVarData.VType,varString
        MOV     [EAX].TVarData.VString,EDX
        RET
@@8:    MOV     [EAX].TVarData.VType,varEmpty
        PUSH    EDX
        PUSH    EAX
        CALL    VariantCopy
@@9:
end;

type
  TAnyProc = procedure (var V: Variant);

procedure VarChangeType(var Dest: Variant; const Source: Variant;
  DestType: Word); forward;

procedure AnyChangeType(var Dest: Variant; Source: Variant; DestType: Word);
begin
  TAnyProc(ChangeAnyProc)(Source);
  VarChangeType(Dest, Source, DestType);
end;

procedure VarChangeType(var Dest: Variant; const Source: Variant;
  DestType: Word);
type
  TVarMem = array[0..3] of Integer;

  function ChangeSourceAny(var Dest: Variant; const Source: Variant;
    DestType: Word): Boolean;
  begin
    Result := False;
    if TVarData(Source).VType = varAny then
    begin
      AnyChangeType(Dest, Source, DestType);
      Result := True;
    end;
  end;

var
  Temp: TVarData;
begin
  case TVarData(Dest).VType of
    varString:
      begin
        if not ChangeSourceAny(Dest, Source, DestType) then
        begin
          Temp.VType := varEmpty;
          if VariantChangeTypeEx(Variant(Temp), Source, $400, 0, DestType) <> 0 then
          VarCastError;
          _VarClear(Dest);
          TVarMem(Dest)[0] := TVarMem(Temp)[0];
          TVarMem(Dest)[2] := TVarMem(Temp)[2];
          TVarMem(Dest)[3] := TVarMem(Temp)[3];
        end;
      end;
    varAny: AnyChangeType(Dest, Source, DestType);
  else if not ChangeSourceAny(Dest, Source, DestType) then
    if VariantChangeTypeEx(Dest, Source, $400, 0, DestType) <> 0 then
      VarCastError;
  end;
end;

procedure VarOleStrToString(var Dest: Variant; const Source: Variant);
var
  StringPtr: Pointer;
begin
  StringPtr := nil;
  OleStrToStrVar(TVarData(Source).VOleStr, string(StringPtr));
  _VarClear(Dest);
  TVarData(Dest).VType := varString;
  TVarData(Dest).VString := StringPtr;
end;

procedure VarStringToOleStr(var Dest: Variant; const Source: Variant);
var
  OleStrPtr: PWideChar;
begin
  OleStrPtr := StringToOleStr(string(TVarData(Source).VString));
  _VarClear(Dest);
  TVarData(Dest).VType := varOleStr;
  TVarData(Dest).VOleStr := OleStrPtr;
end;

procedure _VarCast(var Dest : Variant; const Source: Variant; VarType: Integer);
var
  SourceType, DestType: Word;
  Temp: TVarData;
begin
  SourceType := TVarData(Source).VType;
  DestType := Word(VarType);
  if SourceType = DestType then
    _VarCopy(Dest, Source)
  else
  if SourceType = varString then
    if DestType = varOleStr then
      VarStringToOleStr(Variant(Dest), Source)
    else
    begin
      Temp.VType := varEmpty;
      VarStringToOleStr(Variant(Temp), Source);
      try
        VarChangeType(Variant(Dest), Variant(Temp), DestType);
      finally
        _VarClear(PVariant(@Temp)^);
      end;
    end
  else
  if (DestType = varString) and (SourceType <> varAny) then
    if SourceType = varOleStr then
      VarOleStrToString(Variant(Dest), Source)
    else
    begin
      Temp.VType := varEmpty;
      VarChangeType(Variant(Temp), Source, varOleStr);
      try
        VarOleStrToString(Variant(Dest), Variant(Temp));
      finally
        _VarClear(Variant(Temp));
      end;
    end
  else
    VarChangeType(Variant(Dest), Source, DestType);
end;

(* VarCast when the destination is OleVariant *)
procedure _VarCastOle(var Dest : Variant; const Source: Variant; VarType: Integer);
begin
  if (VarType = varString) or (VarType = varAny) then
    VarCastError
  else
    _VarCast(Dest, Source, VarType);
end;

procedure _VarToInt;
asm
        XOR     EDX,EDX
        MOV     DX,[EAX].TVarData.VType
        CMP     EDX,varInteger
        JE      @@0
        CMP     EDX,varSmallint
        JE      @@1
        CMP     EDX,varByte
        JE      @@2
        CMP     EDX,varDouble
        JE      @@5
        CMP     EDX,varSingle
        JE      @@4
        CMP     EDX,varCurrency
        JE      @@3
        SUB     ESP,16
        MOV     [ESP].TVarData.VType,varEmpty
        MOV     EDX,EAX
        MOV     EAX,ESP
        MOV     ECX,varInteger
        CALL    _VarCast
        MOV     EAX,[ESP].TVarData.VInteger
        ADD     ESP,16
        RET
@@0:    MOV     EAX,[EAX].TVarData.VInteger
        RET
@@1:    MOVSX   EAX,[EAX].TVarData.VSmallint
        RET
@@2:    MOVZX   EAX,[EAX].TVarData.VByte
        RET
@@3:    FILD    [EAX].TVarData.VCurrency
        FDIV    C10000
        JMP     @@6
@@4:    FLD     [EAX].TVarData.VSingle
        JMP     @@6
@@5:    FLD     [EAX].TVarData.VDouble
@@6:    PUSH    EAX
        FISTP   DWORD PTR [ESP]
        FWAIT
        POP     EAX
end;

procedure _VarToBool;
asm
        CMP     [EAX].TVarData.VType,varBoolean
        JE      @@1
        SUB     ESP,16
        MOV     [ESP].TVarData.VType,varEmpty
        MOV     EDX,EAX
        MOV     EAX,ESP
        MOV     ECX,varBoolean
        CALL    _VarCast
        MOV     AX,[ESP].TVarData.VBoolean
        ADD     ESP,16
        JMP     @@2
@@1:    MOV     AX,[EAX].TVarData.VBoolean
@@2:    NEG     AX
        SBB     EAX,EAX
        NEG     EAX
end;

procedure _VarToReal;
asm
        XOR     EDX,EDX
        MOV     DX,[EAX].TVarData.VType
        CMP     EDX,varDouble
        JE      @@1
        CMP     EDX,varSingle
        JE      @@2
        CMP     EDX,varCurrency
        JE      @@3
        CMP     EDX,varInteger
        JE      @@4
        CMP     EDX,varSmallint
        JE      @@5
        CMP     EDX,varDate
        JE      @@1
        SUB     ESP,16
        MOV     [ESP].TVarData.VType,varEmpty
        MOV     EDX,EAX
        MOV     EAX,ESP
        MOV     ECX,varDouble
        CALL    _VarCast
        FLD     [ESP].TVarData.VDouble
        ADD     ESP,16
        RET
@@1:    FLD     [EAX].TVarData.VDouble
        RET
@@2:    FLD     [EAX].TVarData.VSingle
        RET
@@3:    FILD    [EAX].TVarData.VCurrency
        FDIV    C10000
        RET
@@4:    FILD    [EAX].TVarData.VInteger
        RET
@@5:    FILD    [EAX].TVarData.VSmallint
end;

procedure _VarToCurr;
asm
        XOR     EDX,EDX
        MOV     DX,[EAX].TVarData.VType
        CMP     EDX,varCurrency
        JE      @@1
        CMP     EDX,varDouble
        JE      @@2
        CMP     EDX,varSingle
        JE      @@3
        CMP     EDX,varInteger
        JE      @@4
        CMP     EDX,varSmallint
        JE      @@5
        SUB     ESP,16
        MOV     [ESP].TVarData.VType,varEmpty
        MOV     EDX,EAX
        MOV     EAX,ESP
        MOV     ECX,varCurrency
        CALL    _VarCast
        FILD    [ESP].TVarData.VCurrency
        ADD     ESP,16
        RET
@@1:    FILD    [EAX].TVarData.VCurrency
        RET
@@2:    FLD     [EAX].TVarData.VDouble
        JMP     @@6
@@3:    FLD     [EAX].TVarData.VSingle
        JMP     @@6
@@4:    FILD    [EAX].TVarData.VInteger
        JMP     @@6
@@5:    FILD    [EAX].TVarData.VSmallint
@@6:    FMUL    C10000
end;

procedure _VarToPStr(var S; const V: Variant);
var
  Temp: string;
begin
  _VarToLStr(Temp, V);
  ShortString(S) := Temp;
end;

procedure _VarToLStr(var S: string; const V: Variant);
asm
        { -> EAX: destination string }
        {    EDX: source variant     }
        { <- none                    }

        CMP     [EDX].TVarData.VType,varString
        JNE     @@1
        MOV     EDX,[EDX].TVarData.VString
        JMP     _LStrAsg
@@1:    PUSH    EBX
        MOV     EBX,EAX
        SUB     ESP,16
        MOV     [ESP].TVarData.VType,varEmpty
        MOV     EAX,ESP
        MOV     ECX,varString
        CALL    _VarCast
        MOV     EAX,EBX
        CALL    _LStrClr
        MOV     EAX,[ESP].TVarData.VString
        MOV     [EBX],EAX
        ADD     ESP,16
        POP     EBX
end;

procedure _VarToWStr(var S: WideString; const V: Variant);
asm
        CMP     [EDX].TVarData.VType,varOleStr
        JNE     @@1
        MOV     EDX,[EDX].TVarData.VOleStr
        JMP     _WStrAsg
@@1:    PUSH    EBX
        MOV     EBX,EAX
        SUB     ESP,16
        MOV     [ESP].TVarData.VType,varEmpty
        MOV     EAX,ESP
        MOV     ECX,varOleStr
        CALL    _VarCast
        MOV     EAX,EBX
        MOV     EDX,[ESP].TVarData.VOleStr
        CALL    WStrSet
        ADD     ESP,16
        POP     EBX
end;

procedure AnyToIntf(var Unknown: IUnknown; V: Variant);
begin
  TAnyProc(ChangeAnyProc)(V);
  if TVarData(V).VType <> varUnknown then
    VarCastError;
  Unknown := IUnknown(TVarData(V).VUnknown);
end;

procedure _VarToIntf(var Unknown: IUnknown; const V: Variant);
asm
        CMP     [EDX].TVarData.VType,varEmpty
        JE      _IntfClear
        CMP     [EDX].TVarData.VType,varUnknown
        JE      @@2
        CMP     [EDX].TVarData.VType,varDispatch
        JE      @@2
        CMP     [EDX].TVarData.VType,varUnknown+varByRef
        JE      @@1
        CMP     [EDX].TVarData.VType,varDispatch+varByRef
        JE      @@1
        CMP     [EDX].TVarData.VType,varAny
        JNE     VarCastError
        JMP     AnyToIntf
@@0:    CALL    _VarClear
        ADD     ESP,16
        JMP     VarCastError
@@1:    MOV     EDX,[EDX].TVarData.VPointer
        MOV     EDX,[EDX]
        JMP     _IntfCopy
@@2:    MOV     EDX,[EDX].TVarData.VUnknown
        JMP     _IntfCopy
end;

procedure _VarToDisp(var Dispatch: IDispatch; const V: Variant);
asm
        CMP     [EDX].TVarData.VType,varEmpty
        JE      _IntfClear
        CMP     [EDX].TVarData.VType,varDispatch
        JE      @@1
        CMP     [EDX].TVarData.VType,varDispatch+varByRef
        JNE     VarCastError
        MOV     EDX,[EDX].TVarData.VPointer
        MOV     EDX,[EDX]
        JMP     _IntfCopy
@@1:    MOV     EDX,[EDX].TVarData.VDispatch
        JMP     _IntfCopy
end;

procedure _VarToDynArray(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);
asm
        CALL    DynArrayFromVariant
        OR      EAX, EAX
        JNZ     @@1
        JMP     VarCastError
@@1:
end;

procedure _VarFromInt;
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varInteger
        MOV     [EAX].TVarData.VInteger,EDX
end;

procedure _VarFromBool;
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varBoolean
        NEG     DL
        SBB     EDX,EDX
        MOV     [EAX].TVarData.VBoolean,DX
end;

procedure _VarFromReal;
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        CALL    _VarClear
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varDouble
        FSTP    [EAX].TVarData.VDouble
        FWAIT
end;

procedure _VarFromTDateTime;
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        CALL    _VarClear
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varDate
        FSTP    [EAX].TVarData.VDouble
        FWAIT
end;

procedure _VarFromCurr;
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        CALL    _VarClear
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varCurrency
        FISTP   [EAX].TVarData.VCurrency
        FWAIT
end;

procedure _VarFromPStr(var V: Variant; const Value: ShortString);
begin
  _VarFromLStr(V, Value);
end;

procedure _VarFromLStr(var V: Variant; const Value: string);
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    TEST    EDX,EDX
        JE      @@3
        MOV     ECX,[EDX-skew].StrRec.refCnt
        INC     ECX
        JLE     @@2
{X LOCK} INC     [EDX-skew].StrRec.refCnt
        JMP     @@3
@@2:    PUSH    EAX
        PUSH    EDX
        MOV     EAX,[EDX-skew].StrRec.length
        CALL    _NewAnsiString
        MOV     EDX,EAX
        POP     EAX
        PUSH    EDX
        MOV     ECX,[EDX-skew].StrRec.length
        CALL    Move
        POP     EDX
        POP     EAX
@@3:    MOV     [EAX].TVarData.VType,varString
        MOV     [EAX].TVarData.VString,EDX
end;

procedure _VarFromWStr(var V: Variant; const Value: WideString);
asm
        PUSH    EAX
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
@@1:    XOR     EAX,EAX
        TEST    EDX,EDX
        JE      @@2
        MOV     EAX,[EDX-4]
        SHR     EAX,1
        JE      @@2
        PUSH    EAX
        PUSH    EDX
        CALL    SysAllocStringLen
        TEST    EAX,EAX
        JE      WStrError
@@2:    POP     EDX
        MOV     [EDX].TVarData.VType,varOleStr
        MOV     [EDX].TVarData.VOleStr,EAX
end;

procedure _VarFromIntf(var V: Variant; const Value: IUnknown);
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varUnknown
        MOV     [EAX].TVarData.VUnknown,EDX
        TEST    EDX,EDX
        JE      @@2
        PUSH    EDX
        MOV     EAX,[EDX]
        CALL    [EAX].vmtAddRef.Pointer
@@2:
end;

procedure _VarFromDisp(var V: Variant; const Value: IDispatch);
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varDispatch
        MOV     [EAX].TVarData.VDispatch,EDX
        TEST    EDX,EDX
        JE      @@2
        PUSH    EDX
        MOV     EAX,[EDX]
        CALL    [EAX].vmtAddRef.Pointer
@@2:
end;

procedure _VarFromDynArray(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
asm
        PUSH    EAX
        CALL    DynArrayToVariant
        POP     EAX
        CMP     [EAX].TVarData.VType,varEmpty
        JNE     @@1
        JMP     VarCastError
@@1:
end;

procedure _OleVarFromPStr(var V: OleVariant; const Value: ShortString);
begin
  _OleVarFromLStr(V, Value);
end;


procedure _OleVarFromLStr(var V: OleVariant; const Value: string);
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varOleStr
        ADD     EAX,TVarData.VOleStr
        XOR     ECX,ECX
        MOV     [EAX],ECX
        JMP     _WStrFromLStr
end;

procedure OleVarFromAny(var V: OleVariant; Value: Variant);
begin
  TAnyProc(ChangeAnyProc)(Value);
  V := Value;
end;

procedure _OleVarFromVar(var V: OleVariant; const Value: Variant);
asm
        CMP     [EDX].TVarData.VType,varAny
        JE      OleVarFromAny
        CMP     [EDX].TVarData.VType,varString
        JNE     _VarCopy
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    EAX
        PUSH    EDX
        CALL    _VarClear
        POP     EDX
        POP     EAX
@@1:    MOV     [EAX].TVarData.VType,varOleStr
        ADD     EAX,TVarData.VOleStr
        ADD     EDX,TVarData.VString
        XOR     ECX,ECX
        MOV     EDX,[EDX]
        MOV     [EAX],ECX
        JMP     _WStrFromLStr
@@2:
end;


procedure VarStrCat(var Dest: Variant; const Source: Variant);
begin
  if TVarData(Dest).VType = varString then
    Dest := string(Dest) + string(Source)
  else
    Dest := WideString(Dest) + WideString(Source);
end;

procedure VarOp(var Dest: Variant; const Source: Variant; OpCode: Integer); forward;

procedure AnyOp(var Dest: Variant; Source: Variant; OpCode: Integer);
begin
  if TVarData(Dest).VType = varAny then TAnyProc(ChangeAnyProc)(Dest);
  if TVarData(Source).VType = varAny then TAnyProc(ChangeAnyProc)(Source);
  VarOp(Dest, Source, OpCode);
end;

procedure VarOp(var Dest: Variant; const Source: Variant; OpCode: Integer);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ESI,EDX
        MOV     EBX,ECX
        MOV     EAX,[EDI].TVarData.VType.Integer
        MOV     EDX,[ESI].TVarData.VType.Integer
        AND     EAX,varTypeMask
        AND     EDX,varTypeMask
        CMP     EAX,varLast
        JBE     @@1
        CMP     EAX,varString
        JNE     @@4
        MOV     EAX,varOleStr
@@1:    CMP     EDX,varLast
        JBE     @@2
        CMP     EDX,varString
        JNE     @@3
        MOV     EDX,varOleStr
@@2:    MOV     AL,BaseTypeMap.Byte[EAX]
        MOV     DL,BaseTypeMap.Byte[EDX]
        MOVZX   ECX,OpTypeMap.Byte[EAX*8+EDX]
        CALL    @VarOpTable.Pointer[ECX*4]
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@3:    MOV     EAX,EDX
@@4:    CMP     EAX,varAny
        JNE     @InvalidOp
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     AnyOp

@VarOpTable:
        DD      @VarOpError
        DD      @VarOpNull
        DD      @VarOpInteger
        DD      @VarOpReal
        DD      @VarOpCurr
        DD      @VarOpString
        DD      @VarOpBoolean
        DD      @VarOpDate

@VarOpError:
        POP     EAX

@InvalidOp:
        POP     EDI
        POP     ESI
        POP     EBX
        JMP     VarInvalidOp

@VarOpNull:
        MOV     EAX,EDI
        CALL    _VarClear
        MOV     [EDI].TVarData.VType,varNull
        RET

@VarOpInteger:
        CMP     BL,opDvd
        JE      @RealOp

@IntegerOp:
        MOV     EAX,ESI
        CALL    _VarToInt
        PUSH    EAX
        MOV     EAX,EDI
        CALL    _VarToInt
        POP     EDX
        CALL    @IntegerOpTable.Pointer[EBX*4]
        MOV     EDX,EAX
        MOV     EAX,EDI
        JMP     _VarFromInt

@IntegerOpTable:
        DD      @IntegerAdd
        DD      @IntegerSub
        DD      @IntegerMul
        DD      0
        DD      @IntegerDiv
        DD      @IntegerMod
        DD      @IntegerShl
        DD      @IntegerShr
        DD      @IntegerAnd
        DD      @IntegerOr
        DD      @IntegerXor

@IntegerAdd:
        ADD     EAX,EDX
        JO      @IntToRealOp
        RET

@IntegerSub:
        SUB     EAX,EDX
        JO      @IntToRealOp
        RET

@IntegerMul:
        IMUL    EDX
        JO      @IntToRealOp
        RET

@IntegerDiv:
        MOV     ECX,EDX
        CDQ
        IDIV    ECX
        RET

@IntegerMod:
        MOV     ECX,EDX
        CDQ
        IDIV    ECX
        MOV     EAX,EDX
        RET

@IntegerShl:
        MOV     ECX,EDX
        SHL     EAX,CL
        RET

@IntegerShr:
        MOV     ECX,EDX
        SHR     EAX,CL
        RET

@IntegerAnd:
        AND     EAX,EDX
        RET

@IntegerOr:
        OR      EAX,EDX
        RET

@IntegerXor:
        XOR     EAX,EDX
        RET

@IntToRealOp:
        POP     EAX
        JMP     @RealOp

@VarOpReal:
        CMP     BL,opDiv
        JAE     @IntegerOp

@RealOp:
        MOV     EAX,ESI
        CALL    _VarToReal
        SUB     ESP,12
        FSTP    TBYTE PTR [ESP]
        MOV     EAX,EDI
        CALL    _VarToReal
        FLD     TBYTE PTR [ESP]
        ADD     ESP,12
        CALL    @RealOpTable.Pointer[EBX*4]

@RealResult:
        MOV     EAX,EDI
        JMP     _VarFromReal

@VarOpCurr:
        CMP     BL,opDiv
        JAE     @IntegerOp
        CMP     BL,opMul
        JAE     @CurrMulDvd
        MOV     EAX,ESI
        CALL    _VarToCurr
        SUB     ESP,12
        FSTP    TBYTE PTR [ESP]
        MOV     EAX,EDI
        CALL    _VarToCurr
        FLD     TBYTE PTR [ESP]
        ADD     ESP,12
        CALL    @RealOpTable.Pointer[EBX*4]

@CurrResult:
        MOV     EAX,EDI
        JMP     _VarFromCurr

@CurrMulDvd:
        CMP     DL,btCur
        JE      @CurrOpCurr
        MOV     EAX,ESI
        CALL    _VarToReal
        FILD    [EDI].TVarData.VCurrency
        FXCH
        CALL    @RealOpTable.Pointer[EBX*4]
        JMP     @CurrResult

@CurrOpCurr:
        CMP     BL,opDvd
        JE      @CurrDvdCurr
        CMP     AL,btCur
        JE      @CurrMulCurr
        MOV     EAX,EDI
        CALL    _VarToReal
        FILD    [ESI].TVarData.VCurrency
        FMUL
        JMP     @CurrResult

@CurrMulCurr:
        FILD    [EDI].TVarData.VCurrency
        FILD    [ESI].TVarData.VCurrency
        FMUL
        FDIV    C10000
        JMP     @CurrResult

@CurrDvdCurr:
        MOV     EAX,EDI
        CALL    _VarToCurr
        FILD    [ESI].TVarData.VCurrency
        FDIV
        JMP     @RealResult

@RealOpTable:
        DD      @RealAdd
        DD      @RealSub
        DD      @RealMul
        DD      @RealDvd

@RealAdd:
        FADD
        RET

@RealSub:
        FSUB
        RET

@RealMul:
        FMUL
        RET

@RealDvd:
        FDIV
        RET

@VarOpString:
        CMP     BL,opAdd
        JNE     @VarOpReal
        MOV     EAX,EDI
        MOV     EDX,ESI
        JMP     VarStrCat

@VarOpBoolean:
        CMP     BL,opAnd
        JB      @VarOpReal
        MOV     EAX,ESI
        CALL    _VarToBool
        PUSH    EAX
        MOV     EAX,EDI
        CALL    _VarToBool
        POP     EDX
        CALL    @IntegerOpTable.Pointer[EBX*4]
        MOV     EDX,EAX
        MOV     EAX,EDI
        JMP     _VarFromBool

@VarOpDate:
        CMP     BL,opSub
        JA      @VarOpReal
        JB      @DateOp
        MOV     AH,DL
        CMP     AX,btDat+btDat*256
        JE      @RealOp

@DateOp:
        CALL    @RealOp
        MOV     [EDI].TVarData.VType,varDate
        RET
end;

procedure _VarAdd;
asm
        MOV     ECX,opAdd
        JMP     VarOp
end;

procedure _VarSub;
asm
        MOV     ECX,opSub
        JMP     VarOp
end;

procedure _VarMul;
asm
        MOV     ECX,opMul
        JMP     VarOp
end;

procedure _VarDiv;
asm
        MOV     ECX,opDiv
        JMP     VarOp
end;

procedure _VarMod;
asm
        MOV     ECX,opMod
        JMP     VarOp
end;

procedure _VarAnd;
asm
        MOV     ECX,opAnd
        JMP     VarOp
end;

procedure _VarOr;
asm
        MOV     ECX,opOr
        JMP     VarOp
end;

procedure _VarXor;
asm
        MOV     ECX,opXor
        JMP     VarOp
end;

procedure _VarShl;
asm
        MOV     ECX,opShl
        JMP     VarOp
end;

procedure _VarShr;
asm
        MOV     ECX,opShr
        JMP     VarOp
end;

procedure _VarRDiv;
asm
        MOV     ECX,opDvd
        JMP     VarOp
end;

function VarCompareString(const S1, S2: string): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        OR      EAX,EAX
        JE      @@1
        MOV     EAX,[EAX-4]
@@1:    OR      EDX,EDX
        JE      @@2
        MOV     EDX,[EDX-4]
@@2:    MOV     ECX,EAX
        CMP     ECX,EDX
        JBE     @@3
        MOV     ECX,EDX
@@3:    CMP     ECX,ECX
        REPE    CMPSB
        JE      @@4
        MOVZX   EAX,BYTE PTR [ESI-1]
        MOVZX   EDX,BYTE PTR [EDI-1]
@@4:    SUB     EAX,EDX
        POP     EDI
        POP     ESI
end;

function VarCmpStr(const V1, V2: Variant): Integer;
begin
  Result := VarCompareString(V1, V2);
end;

function AnyCmp(var Dest: Variant; const Source: Variant): Integer;
var
  Temp: Variant;
  P: ^Variant;
begin
  asm
        PUSH    Dest
  end;
  P := @Source;
  if TVarData(Dest).VType = varAny then TAnyProc(ChangeAnyProc)(Dest);
  if TVarData(Source).VType = varAny then
  begin
    Temp := Source;
    TAnyProc(ChangeAnyProc)(Temp);
    P := @Temp;
  end;
  asm
        MOV     EDX,P
        POP     EAX
        CALL    _VarCmp
        PUSHF
        POP     EAX
        MOV     Result,EAX
  end;
end;

procedure _VarCmp;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX
        MOV     ESI,EDX
        MOV     EAX,[EDI].TVarData.VType.Integer
        MOV     EDX,[ESI].TVarData.VType.Integer
        AND     EAX,varTypeMask
        AND     EDX,varTypeMask
        CMP     EAX,varLast
        JBE     @@1
        CMP     EAX,varString
        JNE     @@4
        MOV     EAX,varOleStr
@@1:    CMP     EDX,varLast
        JBE     @@2
        CMP     EDX,varString
        JNE     @@3
        MOV     EDX,varOleStr
@@2:    MOV     AL,BaseTypeMap.Byte[EAX]
        MOV     DL,BaseTypeMap.Byte[EDX]
        MOVZX   ECX,OpTypeMap.Byte[EAX*8+EDX]
        JMP     @VarCmpTable.Pointer[ECX*4]
@@3:    MOV     EAX,EDX
@@4:    CMP     EAX,varAny
        JNE     @VarCmpError
        POP     EDI
        POP     ESI
        CALL    AnyCmp
        PUSH    EAX
        POPF
        RET

@VarCmpTable:
        DD      @VarCmpError
        DD      @VarCmpNull
        DD      @VarCmpInteger
        DD      @VarCmpReal
        DD      @VarCmpCurr
        DD      @VarCmpString
        DD      @VarCmpBoolean
        DD      @VarCmpDate

@VarCmpError:
        POP     EDI
        POP     ESI
        JMP     VarInvalidOp

@VarCmpNull:
        CMP     AL,DL
        JMP     @Exit

@VarCmpInteger:
        MOV     EAX,ESI
        CALL    _VarToInt
        XCHG    EAX,EDI
        CALL    _VarToInt
        CMP     EAX,EDI
        JMP     @Exit

@VarCmpReal:
@VarCmpDate:
        MOV     EAX,EDI
        CALL    _VarToReal
        SUB     ESP,12
        FSTP    TBYTE PTR [ESP]
        MOV     EAX,ESI
        CALL    _VarToReal
        FLD     TBYTE PTR [ESP]
        ADD     ESP,12

@RealCmp:
        FCOMPP
        FNSTSW  AX
        MOV     AL,AH   { Move CF into SF }
        AND     AX,4001H
        ROR     AL,1
        OR      AH,AL
        SAHF
        JMP     @Exit

@VarCmpCurr:
        MOV     EAX,EDI
        CALL    _VarToCurr
        SUB     ESP,12
        FSTP    TBYTE PTR [ESP]
        MOV     EAX,ESI
        CALL    _VarToCurr
        FLD     TBYTE PTR [ESP]
        ADD     ESP,12
        JMP     @RealCmp

@VarCmpString:
        MOV     EAX,EDI
        MOV     EDX,ESI
        CALL    VarCmpStr
        CMP     EAX,0
        JMP     @Exit

@VarCmpBoolean:
        MOV     EAX,ESI
        CALL    _VarToBool
        XCHG    EAX,EDI
        CALL    _VarToBool
        MOV     EDX,EDI
        CMP     AL,DL

@Exit:
        POP     EDI
        POP     ESI
end;

procedure _VarNeg;
asm
        MOV     EDX,[EAX].TVarData.VType.Integer
        AND     EDX,varTypeMask
        CMP     EDX,varLast
        JBE     @@1
        CMP     EDX,varString
        JNE     @VarNegError
        MOV     EDX,varOleStr
@@1:    MOV     DL,BaseTypeMap.Byte[EDX]
        JMP     @VarNegTable.Pointer[EDX*4]
@@2:    CMP     EAX,varAny
        JNE     @VarNegError
        PUSH    EAX
        CALL    [ChangeAnyProc]
        POP     EAX
        JMP     _VarNeg

@VarNegTable:
        DD      @VarNegError
        DD      @VarNegNull
        DD      @VarNegInteger
        DD      @VarNegReal
        DD      @VarNegCurr
        DD      @VarNegReal
        DD      @VarNegInteger
        DD      @VarNegDate

@VarNegError:
        JMP     VarInvalidOp

@VarNegNull:
        RET

@VarNegInteger:
        PUSH    EAX
        CALL    _VarToInt
        NEG     EAX
        MOV     EDX,EAX
        POP     EAX
        JMP     _VarFromInt

@VarNegReal:
        PUSH    EAX
        CALL    _VarToReal
        FCHS
        POP     EAX
        JMP     _VarFromReal

@VarNegCurr:
        FILD    [EAX].TVarData.VCurrency
        FCHS
        FISTP   [EAX].TVarData.VCurrency
        FWAIT
        RET

@VarNegDate:
        FLD     [EAX].TVarData.VDate
        FCHS
        FSTP    [EAX].TVarData.VDate
        FWAIT
end;

procedure _VarNot;
asm
        MOV     EDX,[EAX].TVarData.VType.Integer
        AND     EDX,varTypeMask
        JE      @@2
        CMP     EDX,varBoolean
        JE      @@3
        CMP     EDX,varNull
        JE      @@4
        CMP     EDX,varLast
        JBE     @@1
        CMP     EDX,varString
        JE      @@1
        CMP     EAX,varAny
        JNE     @@2
        PUSH    EAX
        CALL    [ChangeAnyProc]
        POP     EAX
        JMP     _VarNot
@@1:    PUSH    EAX
        CALL    _VarToInt
        NOT     EAX
        MOV     EDX,EAX
        POP     EAX
        JMP     _VarFromInt
@@2:    JMP     VarInvalidOp
@@3:    MOV     DX,[EAX].TVarData.VBoolean
        NEG     DX
        SBB     EDX,EDX
        NOT     EDX
        MOV     [EAX].TVarData.VBoolean,DX
@@4:
end;

procedure _VarCopyNoInd;
asm
        JMP     VarCopyNoInd
end;

procedure VariantClr;
asm
        JMP _VarClr
end;

procedure _VarClr;
asm
        PUSH    EAX
        CALL    _VarClear
        POP     EAX
end;

procedure VariantAddRef;
asm
	JMP	_VarAddRef
end;

procedure _VarAddRef;
asm
        CMP     [EAX].TVarData.VType,varOleStr
        JB      @@1
        PUSH    [EAX].Integer[12]
        PUSH    [EAX].Integer[8]
        PUSH    [EAX].Integer[4]
        PUSH    [EAX].Integer[0]
        MOV     [EAX].TVarData.VType,varEmpty
        MOV     EDX,ESP
        CALL    _VarCopy
        ADD     ESP,16
@@1:
end;

function VarType(const V: Variant): Integer;
asm
        MOVZX   EAX,[EAX].TVarData.VType
end;

function VarAsType(const V: Variant; VarType: Integer): Variant;
begin
  _VarCast(Result, V, VarType);
end;

function VarIsEmpty(const V: Variant): Boolean;
begin
  with TVarData(V) do
    Result := (VType = varEmpty) or ((VType = varDispatch) or
      (VType = varUnknown)) and (VDispatch = nil);
end;

function VarIsNull(const V: Variant): Boolean;
begin
  Result := TVarData(V).VType = varNull;
end;

function VarToStr(const V: Variant): string;
begin
  if TVarData(V).VType <> varNull then Result := V else Result := '';
end;

function VarFromDateTime(DateTime: TDateTime): Variant;
begin
  _VarClear(Result);
  TVarData(Result).VType := varDate;
  TVarData(Result).VDate := DateTime;
end;

function VarToDateTime(const V: Variant): TDateTime;
var
  Temp: TVarData;
begin
  Temp.VType := varEmpty;
  _VarCast(Variant(Temp), V, varDate);
  Result := Temp.VDate;
end;

function _WriteVariant(var T: Text; const V: Variant; Width: Integer): Pointer;
var
  S: string;
begin
  if TVarData(V).VType >= varSmallint then S := V;
  Write(T, S: Width);
  Result := @T;
end;

function _Write0Variant(var T: Text; const V: Variant): Pointer;
begin
  Result := _WriteVariant(T, V, 0);
end;

{ ----------------------------------------------------- }
{       Variant array support                           }
{ ----------------------------------------------------- }

function VarArrayCreate(const Bounds: array of Integer;
  VarType: Integer): Variant;
var
  I, DimCount: Integer;
  VarArrayRef: PVarArray;
  VarBounds: array[0..63] of TVarArrayBound;
begin
  if not Odd(High(Bounds)) or (High(Bounds) > 127) then
    Error(reVarArrayCreate);
  DimCount := (High(Bounds) + 1) div 2;
  for I := 0 to DimCount - 1 do
    with VarBounds[I] do
    begin
      LowBound := Bounds[I * 2];
      ElementCount := Bounds[I * 2 + 1] - LowBound + 1;
    end;
  VarArrayRef := SafeArrayCreate(VarType, DimCount, VarBounds);
  if VarArrayRef = nil then Error(reVarArrayCreate);
  _VarClear(Result);
  TVarData(Result).VType := VarType or varArray;
  TVarData(Result).VArray := VarArrayRef;
end;

function VarArrayOf(const Values: array of Variant): Variant;
var
  I: Integer;
begin
  Result := VarArrayCreate([0, High(Values)], varVariant);
  for I := 0 to High(Values) do Result[I] := Values[I];
end;

procedure _VarArrayRedim(var A : Variant; HighBound: Integer);
var
  VarBound: TVarArrayBound;
begin
  if (TVarData(A).VType and (varArray or varByRef)) <> varArray then
    Error(reVarNotArray);
  with TVarData(A).VArray^ do
    VarBound.LowBound := Bounds[DimCount - 1].LowBound;
  VarBound.ElementCount := HighBound - VarBound.LowBound + 1;
  if SafeArrayRedim(TVarData(A).VArray, VarBound) <> 0 then
    Error(reVarArrayCreate);
end;

function GetVarArray(const A: Variant): PVarArray;
begin
  if TVarData(A).VType and varArray = 0 then Error(reVarNotArray);
  if TVarData(A).VType and varByRef <> 0 then
    Result := PVarArray(TVarData(A).VPointer^) else
    Result := TVarData(A).VArray;
end;

function VarArrayDimCount(const A: Variant): Integer;
begin
  if TVarData(A).VType and varArray <> 0 then
    Result := GetVarArray(A)^.DimCount else
    Result := 0;
end;

function VarArrayLowBound(const A: Variant; Dim: Integer): Integer;
begin
  if SafeArrayGetLBound(GetVarArray(A), Dim, Result) <> 0 then
    Error(reVarArrayBounds);
end;

function VarArrayHighBound(const A: Variant; Dim: Integer): Integer;
begin
  if SafeArrayGetUBound(GetVarArray(A), Dim, Result) <> 0 then
    Error(reVarArrayBounds);
end;

function VarArrayLock(const A: Variant): Pointer;
begin
  if SafeArrayAccessData(GetVarArray(A), Result) <> 0 then
    Error(reVarNotArray);
end;

procedure VarArrayUnlock(const A: Variant);
begin
  if SafeArrayUnaccessData(GetVarArray(A)) <> 0 then
    Error(reVarNotArray);
end;

function VarArrayRef(const A: Variant): Variant;
begin
  if TVarData(A).VType and varArray = 0 then Error(reVarNotArray);
  _VarClear(Result);
  TVarData(Result).VType := TVarData(A).VType or varByRef;
  if TVarData(A).VType and varByRef <> 0 then
    TVarData(Result).VPointer := TVarData(A).VPointer else
    TVarData(Result).VPointer := @TVarData(A).VArray;
end;

function VarIsArray(const A: Variant): Boolean;
begin
  Result := TVarData(A).VType and varArray <> 0;
end;

function _VarArrayGet(var A: Variant; IndexCount: Integer;
  Indices: Integer): Variant; cdecl;
var
  VarArrayPtr: PVarArray;
  VarType: Integer;
  P: Pointer;
begin
  if TVarData(A).VType and varArray = 0 then Error(reVarNotArray);
  VarArrayPtr := GetVarArray(A);
  if VarArrayPtr^.DimCount <> IndexCount then Error(reVarArrayBounds);
  VarType := TVarData(A).VType and varTypeMask;
  _VarClear(Result);
  if VarType = varVariant then
  begin
    if SafeArrayPtrOfIndex(VarArrayPtr, @Indices, P) <> 0 then
      Error(reVarArrayBounds);
    Result := PVariant(P)^;
  end else
  begin
  if SafeArrayGetElement(VarArrayPtr, @Indices,
      @TVarData(Result).VPointer) <> 0 then Error(reVarArrayBounds);
    TVarData(Result).VType := VarType;
  end;
end;

procedure _VarArrayPut(var A: Variant; const Value: Variant;
  IndexCount: Integer; Indices: Integer); cdecl;
type
  TAnyPutArrayProc = procedure (var A: Variant; const Value: Variant; Index: Integer);
var
  VarArrayPtr: PVarArray;
  VarType: Integer;
  P: Pointer;
  Temp: TVarData;
begin
  if TVarData(A).VType and varArray = 0 then Error(reVarNotArray);
  VarArrayPtr := GetVarArray(A);
  if VarArrayPtr^.DimCount <> IndexCount then Error(reVarArrayBounds);
  VarType := TVarData(A).VType and varTypeMask;
  if (VarType = varVariant) and (TVarData(Value).VType <> varString) then
  begin
    if SafeArrayPtrOfIndex(VarArrayPtr, @Indices, P) <> 0 then
      Error(reVarArrayBounds);
    PVariant(P)^ := Value;
  end else
  begin
    Temp.VType := varEmpty;
    try
      if VarType = varVariant then
      begin
        VarStringToOleStr(Variant(Temp), Value);
        P := @Temp;
      end else
      begin
        _VarCast(Variant(Temp), Value, VarType);
        case VarType of
          varOleStr, varDispatch, varUnknown:
            P := Temp.VPointer;
        else
          P := @Temp.VPointer;
        end;
      end;
      if SafeArrayPutElement(VarArrayPtr, @Indices, P) <> 0 then
        Error(reVarArrayBounds);
    finally
      _VarClear(Variant(Temp));
    end;
  end;
end;


function VarArrayGet(const A: Variant; const Indices: array of Integer): Variant;
asm
        {     ->EAX     Pointer to A            }
        {       EDX     Pointer to Indices      }
        {       ECX     High bound of Indices   }
        {       [EBP+8] Pointer to result       }

        PUSH    EBX

        MOV     EBX,ECX
        INC     EBX
        JLE     @@endLoop
@@loop:
        PUSH    [EDX+ECX*4].Integer
        DEC     ECX
        JNS     @@loop
@@endLoop:
        PUSH    EBX
        PUSH    EAX
        MOV     EAX,[EBP+8]
        PUSH    EAX
        CALL    _VarArrayGet
        LEA     ESP,[ESP+EBX*4+3*4]

        POP     EBX
end;

procedure VarArrayPut(var A: Variant; const Value: Variant; const Indices: array of Integer);
asm
        {     ->EAX     Pointer to A            }
        {       EDX     Pointer to Value        }
        {       ECX     Pointer to Indices      }
        {       [EBP+8] High bound of Indices   }

        PUSH    EBX

        MOV     EBX,[EBP+8]

        TEST    EBX,EBX
        JS      @@endLoop
@@loop:
        PUSH    [ECX+EBX*4].Integer
        DEC     EBX
        JNS     @@loop
@@endLoop:
        MOV     EBX,[EBP+8]
        INC     EBX
        PUSH    EBX
        PUSH    EDX
        PUSH    EAX
        CALL    _VarArrayPut
        LEA     ESP,[ESP+EBX*4+3*4]

        POP     EBX
end;


{ 64-bit Integer helper routines - recycling C++ RTL routines }

procedure __llmul;      external;    {$L _LL  }
procedure __lldiv;      external;    {   _LL  }
procedure __llmod;      external;    {   _LL  }
procedure __llmulo;     external;    {   _LL  (overflow version) }
procedure __lldivo;     external;    {   _LL  (overflow version) }
procedure __llmodo;     external;    {   _LL  (overflow version) }
procedure __llshl;      external;    {   _LL  }
procedure __llushr;     external;    {   _LL  }
procedure __llumod;     external;    {   _LL  }
procedure __lludiv;     external;    {   _LL  }

function _StrInt64(val: Int64; width: Integer): ShortString;
var
  d: array[0..31] of Char;  { need 19 digits and a sign }
  i, k: Integer;
  sign: Boolean;
  spaces: Integer;
begin
  { Produce an ASCII representation of the number in reverse order }
  i := 0;
  sign := val < 0;
  repeat
    d[i] := Chr( Abs(val mod 10) + Ord('0') );
    Inc(i);
    val := val div 10;
  until val = 0;
  if sign then
  begin
    d[i] := '-';
    Inc(i);
  end;

  { Fill the Result with the appropriate number of blanks }
  if width > 255 then
    width := 255;
  k := 1;
  spaces := width - i;
  while k <= spaces do
  begin
    Result[k] := ' ';
    Inc(k);
  end;

  { Fill the Result with the number }
  while i > 0 do
  begin
    Dec(i);
    Result[k] := d[i];
    Inc(k);
  end;

  { Result is k-1 characters long }
  SetLength(Result, k-1);

end;

function _Str0Int64(val: Int64): ShortString;
begin
  Result := _StrInt64(val, 0);
end;

procedure       _WriteInt64;
asm
{       PROCEDURE _WriteInt64( VAR t: Text; val: Int64; with: Longint);        }
{     ->EAX     Pointer to file record  }
{       [ESP+4] Value                   }
{       EDX     Field width             }

        SUB     ESP,32          { VAR s: String[31];    }

        PUSH    EAX
        PUSH    EDX

        PUSH    dword ptr [ESP+8+32+8]    { Str( val : 0, s );    }
        PUSH    dword ptr [ESP+8+32+8]
        XOR     EAX,EAX
        LEA     EDX,[ESP+8+8]
        CALL    _StrInt64

        POP     ECX
        POP     EAX

        MOV     EDX,ESP         { Write( t, s : width );}
        CALL    _WriteString

        ADD     ESP,32
        RET     8
end;

procedure       _Write0Int64;
asm
{       PROCEDURE _Write0Long( VAR t: Text; val: Longint);      }
{     ->EAX     Pointer to file record  }
{       EDX     Value                   }
        XOR     EDX,EDX
        JMP     _WriteInt64
end;

procedure       _ReadInt64;     external;       {$L ReadInt64 }

function _ValInt64(const s: AnsiString; var code: Integer): Int64;
var
  i: Integer;
  dig: Integer;
  sign: Boolean;
  empty: Boolean;
begin
  i := 1;
  dig := 0;
  Result := 0;
  if s = '' then
  begin
    code := i;
    exit;
  end;
  while s[i] = ' ' do
    Inc(i);
  sign := False;
  if s[i] = '-' then
  begin
    sign := True;
    Inc(i);
  end
  else if s[i] = '+' then
    Inc(i);
  empty := True;
  if (s[i] = '$') or (s[i] = '0') and (Upcase(s[i+1]) = 'X') then
  begin
    if s[i] = '0' then
      Inc(i);
    Inc(i);
    while True do
    begin
      case s[i] of
      '0'..'9': dig := Ord(s[i]) -  Ord('0');
      'A'..'F': dig := Ord(s[i]) - (Ord('A') - 10);
      'a'..'f': dig := Ord(s[i]) - (Ord('a') - 10);
      else
        break;
      end;
      if (Result < 0) or (Result > $0FFFFFFFFFFFFFFF) then
        break;
      Result := Result shl 4 + dig;
      Inc(i);
      empty := False;
    end;
    if sign then
      Result := - Result;
  end
  else
  begin
    while True do
    begin
      case s[i] of
      '0'..'9': dig := Ord(s[i]) - Ord('0');
      else
        break;
      end;
      if (Result < 0) or (Result > $7FFFFFFFFFFFFFFF div 10) then
        break;
      Result := Result*10 + dig;
      Inc(i);
      empty := False;
    end;
    if sign then
      Result := - Result;
    if (Result <> 0) and (sign <> (Result < 0)) then
      Dec(i);
  end;
  if (s[i] <> #0) or empty then
    code := i
  else
    code := 0;
end;

procedure _DynArrayLength;
asm
{       FUNCTION _DynArrayLength(const a: array of ...): Longint; }
{     ->EAX     Pointer to array or nil                           }
{     <-EAX     High bound of array + 1 or 0                      }
        TEST    EAX,EAX
        JZ      @@skip
        MOV     EAX,[EAX-4]
@@skip:
end;

procedure _DynArrayHigh;
asm
{       FUNCTION _DynArrayHigh(const a: array of ...): Longint; }
{     ->EAX     Pointer to array or nil                         }
{     <-EAX     High bound of array or -1                       }
        CALL  _DynArrayLength
        DEC     EAX
end;

type
  PLongint = ^Longint;
  PointerArray = array [0..512*1024*1024 -2] of Pointer;
  PPointerArray = ^PointerArray;
  PDynArrayTypeInfo = ^TDynArrayTypeInfo;
  TDynArrayTypeInfo = packed record
    kind: Byte;
    name: string[0];
    elSize: Longint;
    elType: ^PDynArrayTypeInfo;
    varType: Integer;
  end;


procedure CopyArray(dest, source, typeInfo: Pointer; cnt: Integer);
asm
        PUSH    dword ptr [EBP+8]
        CALL    _CopyArray
end;

procedure FinalizeArray(p, typeInfo: Pointer; cnt: Integer);
asm
        JMP     _FinalizeArray
end;

procedure DynArrayClear(var a: Pointer; typeInfo: Pointer);
asm
        CALL    _DynArrayClear
end;

procedure DynArraySetLength(var a: Pointer; typeInfo: PDynArrayTypeInfo; dimCnt: Longint; lengthVec: PLongint);
var
  i: Integer;
  newLength, oldLength, minLength: Longint;
  elSize: Longint;
  neededSize: Longint;
  p, pp: Pointer;
begin
  p := a;

  // Fetch the new length of the array in this dimension, and the old length
  newLength := PLongint(lengthVec)^;
  if newLength <= 0 then
  begin
    if newLength < 0 then
      Error(reRangeError);
    DynArrayClear(a, typeInfo);
    exit;
  end;

  oldLength := 0;
  if p <> nil then
  begin
    Dec(PLongint(p));
    oldLength := PLongint(p)^;
    Dec(PLongint(p));
  end;

  // Calculate the needed size of the heap object
  Inc(PChar(typeInfo), Length(typeInfo.name));
  elSize := typeInfo.elSize;
  if typeInfo.elType <> nil then
    typeInfo := typeInfo.elType^
  else
    typeInfo := nil;
  neededSize := newLength*elSize;
  if neededSize div newLength <> elSize then
    Error(reRangeError);
  Inc(neededSize, Sizeof(Longint)*2);

  // If the heap object isn't shared (ref count = 1), just resize it. Otherwise, we make a copy
  if (p = nil) or (PLongint(p)^ = 1) then
  begin
    pp := p;
    if (newLength < oldLength) and (typeInfo <> nil) then
      FinalizeArray(PChar(p) + Sizeof(Longint)*2 + newLength*elSize, typeInfo, oldLength - newLength);
    ReallocMem(pp, neededSize);
    p := pp;
  end
  else
  begin
    Dec(PLongint(p)^);
    GetMem(p, neededSize);
    minLength := oldLength;
    if minLength > newLength then
      minLength := newLength;
    if typeInfo <> nil then
    begin
      FillChar((PChar(p) + Sizeof(Longint)*2)^, minLength*elSize, 0);
      CopyArray(PChar(p) + Sizeof(Longint)*2, a, typeInfo, minLength)
    end
    else
      Move(PChar(a)^, (PChar(p) + Sizeof(Longint)*2)^, minLength*elSize);
  end;

  // The heap object will now have a ref count of 1 and the new length
  PLongint(p)^ := 1;
  Inc(PLongint(p));
  PLongint(p)^ := newLength;
  Inc(PLongint(p));

  // Set the new memory to all zero bits
  FillChar((PChar(p) + elSize * oldLength)^, elSize * (newLength - oldLength), 0);

  // Take care of the inner dimensions, if any
  if dimCnt > 1 then
  begin
    Inc(lengthVec);
    Dec(dimCnt);
    for i := 0 to newLength-1 do
      DynArraySetLength(PPointerArray(p)[i], typeInfo, dimCnt, lengthVec);
  end;
  a := p;
end;

procedure _DynArraySetLength;
asm
{       PROCEDURE _DynArraySetLength(var a: dynarray; typeInfo: PDynArrayTypeInfo; dimCnt: Longint; lengthVec: ^Longint) }
{     ->EAX     Pointer to dynamic array (= pointer to pointer to heap object) }
{       EDX     Pointer to type info for the dynamic array                     }
{       ECX     number of dimensions                                           }
{       [ESP+4] dimensions                                                     }
        PUSH    ESP
        ADD     dword ptr [ESP],4
        CALL    DynArraySetLength
end;

procedure _DynArrayCopy(a: Pointer; typeInfo: Pointer; var Result: Pointer);
begin
  if a <> nil then
    _DynArrayCopyRange(a, typeInfo, 0, PLongint(PChar(a)-4)^, Result);
end;

procedure _DynArrayCopyRange(a: Pointer; typeInfo: Pointer; index, count : Integer; var Result: Pointer);
var
  arrayLength: Integer;
  elSize: Integer;
  typeInf: PDynArrayTypeInfo;
  p: Pointer;
begin
  p := nil;
  if a <> nil then
  begin
    typeInf := typeInfo;

    // Limit index and count to values within the array
    if index < 0 then
    begin
      Inc(count, index);
      index := 0;
    end;
    arrayLength := PLongint(PChar(a)-4)^;
    if index > arrayLength then
      index := arrayLength;
    if count > arrayLength - index then
      count := arrayLength - index;
    if count < 0 then
      count := 0;

    if count > 0 then
    begin
      // Figure out the size and type descriptor of the element type
      Inc(PChar(typeInf), Length(typeInf.name));
      elSize := typeInf.elSize;
      if typeInf.elType <> nil then
        typeInf := typeInf.elType^
      else
        typeInf := nil;

      // Allocate the amount of memory needed
      GetMem(p, count*elSize + Sizeof(Longint)*2);

      // The reference count of the new array is 1, the length is count
      PLongint(p)^ := 1;
      Inc(PLongint(p));
      PLongint(p)^ := count;
      Inc(PLongint(p));
      Inc(PChar(a), index*elSize);

      // If the element type needs destruction, we must copy each element,
      // otherwise we can just copy the bits
      if count > 0 then
      begin
        if typeInf <> nil then
        begin
          FillChar(p^, count*elSize, 0);
          CopyArray(p, a, typeInf, count)
        end
        else
          Move(a^, p^, count*elSize);
      end;
    end;
  end;
  DynArrayClear(Result, typeInfo);
  Result := p;
end;

procedure _DynArrayClear;
asm
{     ->EAX     Pointer to dynamic array (Pointer to pointer to heap object }
{       EDX     Pointer to type info                                        }

        {       Nothing to do if Pointer to heap object is nil }
        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      @@exit

        {       Set the variable to be finalized to nil }
        MOV     dword ptr [EAX],0

        {       Decrement ref count. Nothing to do if not zero now. }
{X LOCK} DEC     dword ptr [ECX-8]
        JNE     @@exit

        {       Save the source - we're supposed to return it }
        PUSH    EAX
        MOV     EAX,ECX

        {       Fetch the type descriptor of the elements }
        XOR     ECX,ECX
        MOV     CL,[EDX].TDynArrayTypeInfo.name;
        MOV     EDX,[EDX+ECX].TDynArrayTypeInfo.elType;

        {       If it's non-nil, finalize the elements }
        TEST    EDX,EDX
        JE      @@noFinalize
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@noFinalize
        MOV     EDX,[EDX]
        CALL    _FinalizeArray
@@noFinalize:
        {       Now deallocate the array }
        SUB     EAX,8
        CALL    _FreeMem
        POP     EAX
@@exit:
end;


procedure _DynArrayAsg;
asm
{     ->EAX     Pointer to destination (pointer to pointer to heap object }
{       EDX     source (pointer to heap object }
{       ECX     Pointer to rtti describing dynamic array }

        PUSH    EBX
        MOV     EBX,[EAX]

        {       Increment ref count of source if non-nil }

        TEST    EDX,EDX
        JE      @@skipInc
{X LOCK} INC     dword ptr [EDX-8]
@@skipInc:
        {       Dec ref count of destination - if it becomes 0, clear dest }
        TEST    EBX,EBX
        JE  @@skipClear
{X LOCK} DEC     dword ptr[EBX-8]
        JNZ     @@skipClear
        PUSH    EAX
        PUSH    EDX
        MOV     EDX,ECX
        INC     dword ptr[EBX-8]
        CALL    _DynArrayClear
        POP     EDX
        POP     EAX
@@skipClear:
        {       Finally store source into destination }
        MOV     [EAX],EDX

        POP     EBX
end;

procedure _DynArrayAddRef;
asm
{     ->EAX     Pointer to heap object }
        TEST    EAX,EAX
        JE      @@exit
{X LOCK} INC     dword ptr [EAX-8]
@@exit:
end;


function DynArrayIndex(const P: Pointer; const Indices: array of Integer; const TypInfo: Pointer): Pointer;
asm
        {     ->EAX     P                       }
        {       EDX     Pointer to Indices      }
        {       ECX     High bound of Indices   }
        {       [EBP+8] TypInfo                 }

        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        PUSH    EBP

        MOV     ESI,EDX
        MOV     EDI,[EBP+8]
        MOV     EBP,EAX

        XOR     EBX,EBX                 {  for i := 0 to High(Indices) do       }
        TEST    ECX,ECX
        JGE     @@start
@@loop:
        MOV     EBP,[EBP]
@@start:
        XOR     EAX,EAX
        MOV     AL,[EDI].TDynArrayTypeInfo.name
        ADD     EDI,EAX
        MOV     EAX,[ESI+EBX*4]         {    P := P + Indices[i]*TypInfo.elSize }
        MUL     [EDI].TDynArrayTypeInfo.elSize
        MOV     EDI,[EDI].TDynArrayTypeInfo.elType
        TEST    EDI,EDI
        JE      @@skip
        MOV     EDI,[EDI]
@@skip:
        ADD     EBP,EAX
        INC     EBX
        CMP     EBX,ECX
        JLE     @@loop

@@loopEnd:

        MOV     EAX,EBP

        POP     EBP
        POP     EDI
        POP     ESI
        POP     EBX
end;



type
  TBoundArray = array of Integer;
  PPointer    = ^Pointer;


{ Returns the DynArrayTypeInfo of the Element Type of the specified DynArrayTypeInfo }
function DynArrayElTypeInfo(typeInfo: PDynArrayTypeInfo): PDynArrayTypeInfo;
begin
  Result := nil;
  if typeInfo <> nil then
  begin
    Inc(PChar(typeInfo), Length(typeInfo.name));
    if typeInfo.elType <> nil then
      Result := typeInfo.elType^;
  end;
end;

{ Returns # of dimemsions of the DynArray described by the specified DynArrayTypeInfo}
function DynArrayDim(typeInfo: PDynArrayTypeInfo): Integer;
begin
  Result := 0;
  while (typeInfo <> nil) and (typeInfo.kind = tkDynArray) do
  begin
    Inc(Result);
    typeInfo := DynArrayElTypeInfo(typeInfo);
  end;
end;

{ Returns size of the Dynamic Array}
function DynArraySize(a: Pointer): Integer;
asm
        TEST EAX, EAX
        JZ   @@exit
        MOV  EAX, [EAX-4]
@@exit:
end;

// Returns whether array is rectangular
function IsDynArrayRectangular(const DynArray: Pointer; typeInfo: PDynArrayTypeInfo): Boolean;
var
  Dim, I, J, Size, SubSize: Integer;
  P: Pointer;
begin
  // Assume we have a rectangular array
  Result := True;

  P := DynArray;
  Dim := DynArrayDim(typeInfo);

  {NOTE: Start at 1. Don't need to test the first dimension - it's rectangular by definition}
  for I := 1 to dim-1 do
  begin
    if P <> nil then
    begin
      { Get size of this dimension }
      Size := DynArraySize(P);

      { Get Size of first sub. dimension }
      SubSize := DynArraySize(PPointerArray(P)[0]);

      { Walk through every dimension making sure they all have the same size}
      for J := 1  to Size-1 do
        if DynArraySize(PPointerArray(P)[J]) <> SubSize then
        begin
          Result := False;
          Exit;
        end;

      { Point to next dimension}
      P := PPointerArray(P)[0];
    end;
  end;
end;

// Returns Bounds of a DynamicArray in a format usable for creating a Variant.
//  i.e. The format of the bounds returns contains pairs of lo and hi bounds where
//       lo is always 0, and hi is the size dimension of the array-1.
function DynArrayVariantBounds(const DynArray: Pointer; typeInfo: PDynArrayTypeInfo): TBoundArray;
var
  Dim, I: Integer;
  P: Pointer;
begin
  P := DynArray;

  Dim := DynArrayDim(typeInfo);
  SetLength(Result, Dim*2);

  I := 0;
  while I < dim*2 do
  begin
    Result[I] := 0;   // Always use 0 as low-bound in low/high pair
    Inc(I);
    if P <> nil then
    begin
      Result[I] := DynArraySize(P)-1; // Adjust for 0-base low-bound
      P := PPointerArray(p)[0];       // Assume rectangular arrays
    end;
    Inc(I);
  end;
end;

// Returns Bounds of Dynamic array as an array of integer containing the 'high' of each dimension
function DynArrayBounds(const DynArray: Pointer; typeInfo: PDynArrayTypeInfo): TBoundArray;
var
  Dim, I: Integer;
  P: Pointer;
begin
  P := DynArray;

  Dim := DynArrayDim(typeInfo);
  SetLength(Result, Dim);

  for I := 0 to dim-1 do
    if P <> nil then
    begin
      Result[I] := DynArraySize(P)-1;
      P := PPointerArray(P)[0]; // Assume rectangular arrays
    end;
end;

// The dynamicArrayTypeInformation contains the VariantType of the element type
// when the kind == tkDynArray. This function returns that VariantType.
function DynArrayVarType(typeInfo: PDynArrayTypeInfo): Integer;
begin
  Result := varNull;
  if (typeInfo <> nil) and (typeInfo.Kind = tkDynArray) then
  begin
    Inc(PChar(typeInfo), Length(typeInfo.name));
    Result := typeInfo.varType;
  end;

  { NOTE: DECL.H and SYSTEM.PAS have different values for varString }
  if Result = $48 then
    Result := varString;
end;

type
  IntegerArray  = array[0..$effffff] of Integer;
  PIntegerArray = ^IntegerArray;
  PSmallInt     = ^SmallInt;
  PInteger      = ^Integer;
  PSingle       = ^Single;
  PDouble       = ^Double;
  PDate         = ^Double;
  PDispatch     = ^IDispatch;
  PPDispatch    = ^PDispatch;
  PError        = ^LongWord;
  PWordBool     = ^WordBool;
  PUnknown      = ^IUnknown;
  PPUnknown     = ^PUnknown;
  PByte         = ^Byte;
  PPWideChar    = ^PWideChar;

{ Decrements to next lower index - Returns True if successful }
{ Indices: Indices to be decremented }
{ Bounds : High bounds of each dimension }
function DecIndices(var Indices: TBoundArray; const Bounds: TBoundArray): Boolean;
var
  I, J: Integer;
begin
  { Find out if we're done: all at zeroes }
  Result := False;
  for I := Low(Indices)  to High(Indices) do
    if Indices[I] <> 0  then
    begin
      Result := True;
      break;
    end;
  if not Result then
    Exit;

  { Two arrays must be of same length }
  Assert(Length(Indices) = Length(Bounds));

  { Find index of item to tweak }
  for I := High(Indices) downto Low(Bounds) do
  begin
    // If not reach zero, dec and bail out
    if Indices[I] <> 0 then
    begin
      Dec(Indices[I]);
      Exit;
    end
    else
    begin
      J := I;
      while Indices[J] = 0 do
      begin
        // Restore high bound when we've reached zero on a particular dimension
        Indices[J] := Bounds[J];
        // Move to higher dimension
        Dec(J);
        Assert(J >= 0);
      end;
      Dec(Indices[J]);
      Exit;
    end;
  end;
end;

// Copy Contents of Dynamic Array to Variant
// NOTE: The Dynamic array must be rectangular
//       The Dynamic array must contain items whose type is Automation compatible
// In case of failure, the function returns with a Variant of type VT_EMPTY.
procedure DynArrayToVariant(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);
var
  VarBounds, Bounds, Indices: TBoundArray;
  DAVarType, VVarType, DynDim: Integer;
  PDAData: Pointer;
  Value: Variant;
begin
  VarBounds := nil;
  Bounds    := nil;
  { This resets the Variant to VT_EMPTY - flag which is used to determine whether the }
  { the cast to Variant succeeded or not }
  VarClear(V);

  { Get variantType code from DynArrayTypeInfo }
  DAVarType := DynArrayVarType(PDynArrayTypeInfo(TypeInfo));

  { Validate the Variant Type }
  if ((DAVarType > varNull) and (DAVarType <= varByte)) or (DAVarType = varString) then
  begin
    {NOTE: Map varString to varOleStr for SafeArrayCreate call }
    if DAVarType = varString then
      VVarType := varOleStr
    else
      VVarType := DAVarType;

    { Get dimension of Dynamic Array }
    DynDim := DynarrayDim(PDynArrayTypeInfo(TypeInfo));

    { If more than one dimension, make sure we're dealing with a rectangular array }
    if DynDim > 1 then
      if not IsDynArrayRectangular(DynArray, PDynArrayTypeInfo(TypeInfo)) then
        Exit;

    { Get Variant-style Bounds (lo/hi pair) of Dynamic Array }
    VarBounds := DynArrayVariantBounds(DynArray, TypeInfo);

    { Get DynArray Bounds }
    Bounds := DynArrayBounds(DynArray, TypeInfo);
    Indices:= Copy(Bounds);

    { Create Variant of SAFEARRAY }
    V := VarArrayCreate(VarBounds, VVarType);
    Assert(VarArrayDimCount(V) = DynDim);

    repeat
      PDAData := DynArrayIndex(DynArray, Indices, TypeInfo);
      if PDAData <> nil then
      begin
        case DAVarType of
          varSmallInt:  Value := PSmallInt(PDAData)^;
          varInteger:   Value := PInteger(PDAData)^;
          varSingle:    value := PSingle(PDAData)^;
          varDouble:    value := PDouble(PDAData)^;
          varCurrency:  Value := PCurrency(PDAData)^;
          varDate:      Value := PDouble(PDAData)^;
          varOleStr:    Value := PWideString(PDAData)^;
          varDispatch:  Value := PDispatch(PDAData)^;
          varError:     Value := PError(PDAData)^;
          varBoolean:   Value := PWordBool(PDAData)^;
          varVariant:   Value := PVariant(PDAData)^;
          varUnknown:   Value := PUnknown(PDAData)^;
          varByte:      Value := PByte(PDAData)^;
          varString:    Value := PString(PDAData)^;
        else
          VarClear(Value);
        end; { case }
        VarArrayPut(V, Value, Indices);
      end;
    until not DecIndices(Indices, Bounds);
  end;
end;

// Copies data from the Variant to the DynamicArray
procedure DynArrayFromVariant(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);
var
  DADimCount, VDimCount : Integer;
  DAVarType, I: Integer;
  lengthVec: PLongInt;
  Bounds, Indices: TBoundArray;
  Value: Variant;
  PDAData: Pointer;
begin
  { Get Variant information }
  VDimCount:= VarArrayDimCount(V);

  { Allocate vector for lengths }
  GetMem(lengthVec, VDimCount * sizeof(Integer));

  { Initialize lengths - NOTE: VarArrayxxxxBound are 1-based.}
  for I := 0  to  VDimCount-1 do
    PIntegerArray(lengthVec)[I]:= (VarArrayHighBound(V, I+1) - VarArrayLowBound(V, I+1)) + 1;

  { Set Length of DynArray }
  DynArraySetLength(DynArray, PDynArrayTypeInfo(TypeInfo), VDimCount, lengthVec);

  { Get DynArray information }
  DADimCount:= DynArrayDim(PDynArrayTypeInfo(TypeInfo));
  DAVarType := DynArrayVarType(PDynArrayTypeInfo(TypeInfo));
  Assert(VDimCount = DADimCount);

  { Get DynArray Bounds }
  Bounds := DynArrayBounds(DynArray, TypeInfo);
  Indices:= Copy(Bounds);

  { Copy data over}
  repeat
    Value   := VarArrayGet(V, Indices);
    PDAData := DynArrayIndex(DynArray, Indices, TypeInfo);
    case DAVarType of
      varSmallInt:  PSmallInt(PDAData)^   := Value;
      varInteger:   PInteger(PDAData)^    := Value;
      varSingle:    PSingle(PDAData)^     := Value;
      varDouble:    PDouble(PDAData)^     := Value;
      varCurrency:  PCurrency(PDAData)^   := Value;
      varDate:      PDouble(PDAData)^     := Value;
      varOleStr:    PWideString(PDAData)^ := Value;
      varDispatch:  PDispatch(PDAData)^   := Value;
      varError:     PError(PDAData)^      := Value;
      varBoolean:   PWordBool(PDAData)^   := Value;
      varVariant:   PVariant(PDAData)^    := Value;
      varUnknown:   PUnknown(PDAData)^    := value;
      varByte:      PByte(PDAData)^       := Value;
      varString:    PString(PDAData)^     := Value;
    end; { case }
  until not DecIndices(Indices, Bounds);

  { Free vector of lengths }
  FreeMem(lengthVec);
end;



{ Package/Module registration/unregistration }

const
  LOCALE_SABBREVLANGNAME = $00000003;   { abbreviated language name }
  LOAD_LIBRARY_AS_DATAFILE = 2;
  HKEY_CURRENT_USER = $80000001;
  KEY_ALL_ACCESS = $000F003F;

  OldLocaleOverrideKey = 'Software\Borland\Delphi\Locales'; // do not localize
  NewLocaleOverrideKey = 'Software\Borland\Locales'; // do not localize

function FindHInstance(Address: Pointer): LongWord;
var
  MemInfo: TMemInfo;
begin
  VirtualQuery(Address, MemInfo, SizeOf(MemInfo));
  if MemInfo.State = $1000{MEM_COMMIT} then
    Result := Longint(MemInfo.AllocationBase)
  else Result := 0;
end;

function FindClassHInstance(ClassType: TClass): LongWord;
begin
  Result := FindHInstance(Pointer(ClassType));
end;

function FindResourceHInstance(Instance: LongWord): LongWord;
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  while CurModule <> nil do
  begin
    if (Instance = CurModule.Instance) or
       (Instance = CurModule.CodeInstance) or
       (Instance = CurModule.DataInstance) then
    begin
      Result := CurModule.ResInstance;
      Exit;
    end;
    CurModule := CurModule.Next;
  end;
  Result := Instance;
end;

function LoadResourceModule(ModuleName: PChar): LongWord;
var
  FileName: array[0..260] of Char;
  Key: LongWord;
  LocaleName, LocaleOverride: array[0..4] of Char;
  Size: Integer;
  P: PChar;

  function FindBS(Current: PChar): PChar;
  begin
    Result := Current;
    while (Result^ <> #0) and (Result^ <> '\') do
      Result := CharNext(Result);
  end;

  function ToLongPath(AFileName: PChar): PChar;
  var
    CurrBS, NextBS: PChar;
    Handle, L: Integer;
    FindData: TWin32FindData;
    Buffer: array[0..260] of Char;
    GetLongPathName: function (ShortPathName: PChar; LongPathName: PChar;
      cchBuffer: Integer): Integer stdcall;
  begin
    Result := AFileName;
    Handle := GetModuleHandle(kernel);
    if Handle <> 0 then
    begin
      @GetLongPathName := GetProcAddress(Handle, 'GetLongPathNameA');
      if Assigned(GetLongPathName) and
         (GetLongPathName(AFileName, Buffer, SizeOf(Buffer)) <> 0) then
      begin
        lstrcpy(AFileName, Buffer);
        Exit;
      end;
    end;

    if AFileName[0] = '\' then
    begin
      if AFileName[1] <> '\' then Exit;
      CurrBS := FindBS(AFileName + 2);  // skip server name
      if CurrBS^ = #0 then Exit;
      CurrBS := FindBS(CurrBS + 1);     // skip share name
      if CurrBS^ = #0 then Exit;
    end else
      CurrBS := AFileName + 2;          // skip drive name

    L := CurrBS - AFileName;
    lstrcpyn(Buffer, AFileName, L + 1);
    while CurrBS^ <> #0 do
    begin
      NextBS := FindBS(CurrBS + 1);
      if L + (NextBS - CurrBS) + 1 > SizeOf(Buffer) then Exit;
      lstrcpyn(Buffer + L, CurrBS, (NextBS - CurrBS) + 1);

      Handle := FindFirstFile(Buffer, FindData);
      if (Handle = -1) then Exit;
      FindClose(Handle);

      if L + 1 + lstrlen(FindData.cFileName) + 1 > SizeOf(Buffer) then Exit;
      Buffer[L] := '\';
      lstrcpy(Buffer + L + 1, FindData.cFileName);
      Inc(L, lstrlen(FindData.cFileName) + 1);
      CurrBS := NextBS;
    end;
    lstrcpy(AFileName, Buffer);
  end;

begin
  GetModuleFileName(0, FileName, SizeOf(FileName)); // Get host appliation name
  LocaleOverride[0] := #0;
  if (RegOpenKeyEx(HKEY_CURRENT_USER, NewLocaleOverrideKey, 0, KEY_ALL_ACCESS, Key) = 0) or
   (RegOpenKeyEx(HKEY_CURRENT_USER, OldLocaleOverrideKey, 0, KEY_ALL_ACCESS, Key) = 0) then
  try
    Size := SizeOf(LocaleOverride);
    if RegQueryValueEx(Key, ToLongPath(FileName), nil, nil, LocaleOverride, @Size) <> 0 then
      RegQueryValueEx(Key, '', nil, nil, LocaleOverride, @Size);
  finally
    RegCloseKey(Key);
  end;
  lstrcpy(FileName, ModuleName);
  GetLocaleInfo(GetThreadLocale, LOCALE_SABBREVLANGNAME, LocaleName, SizeOf(LocaleName));
  Result := 0;
  if (FileName[0] <> #0) and ((LocaleName[0] <> #0) or (LocaleOverride[0] <> #0)) then
  begin
    P := PChar(@FileName) + lstrlen(FileName);
    while (P^ <> '.') and (P <> @FileName) do Dec(P);
    if P <> @FileName then
    begin
      Inc(P);
      // First look for a locale registry override
      if LocaleOverride[0] <> #0 then
      begin
        lstrcpy(P, LocaleOverride);
        Result := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
      end;
      if (Result = 0) and (LocaleName[0] <> #0) then
      begin
        // Then look for a potential language/country translation
        lstrcpy(P, LocaleName);
        Result := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
        if Result = 0 then
        begin
          // Finally look for a language only translation
          LocaleName[2] := #0;
          lstrcpy(P, LocaleName);
          Result := LoadLibraryEx(FileName, 0, LOAD_LIBRARY_AS_DATAFILE);
        end;
      end;
    end;
  end;
end;

procedure EnumModules(Func: TEnumModuleFunc; Data: Pointer); assembler;
begin
  EnumModules(TEnumModuleFuncLW(Func), Data);
end;

procedure EnumResourceModules(Func: TEnumModuleFunc; Data: Pointer);
begin
  EnumResourceModules(TEnumModuleFuncLW(Func), Data);
end;

procedure EnumModules(Func: TEnumModuleFuncLW; Data: Pointer);
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  while CurModule <> nil do
  begin
    if not Func(CurModule.Instance, Data) then Exit;
    CurModule := CurModule.Next;
  end;
end;

procedure EnumResourceModules(Func: TEnumModuleFuncLW; Data: Pointer);
var
  CurModule: PLibModule;
begin
  CurModule := LibModuleList;
  while CurModule <> nil do
  begin
    if not Func(CurModule.ResInstance, Data) then Exit;
    CurModule := CurModule.Next;
  end;
end;

procedure AddModuleUnloadProc(Proc: TModuleUnloadProc);
begin
  AddModuleUnloadProc(TModuleUnloadProcLW(Proc));
end;

procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProc);
begin
  RemoveModuleUnloadProc(TModuleUnloadProcLW(Proc));
end;

procedure AddModuleUnloadProc(Proc: TModuleUnloadProcLW);
var
  P: PModuleUnloadRec;
begin
  New(P);
  P.Next := ModuleUnloadList;
  @P.Proc := @Proc;
  ModuleUnloadList := P;
end;

procedure RemoveModuleUnloadProc(Proc: TModuleUnloadProcLW);
var
  P, C: PModuleUnloadRec;
begin
  P := ModuleUnloadList;
  if (P <> nil) and (@P.Proc = @Proc) then
  begin
    ModuleUnloadList := ModuleUnloadList.Next;
    Dispose(P);
  end else
  begin
    C := P;
    while C <> nil do
    begin
      if (C.Next <> nil) and (@C.Next.Proc = @Proc) then
      begin
        P := C.Next;
        C.Next := C.Next.Next;
        Dispose(P);
        Break;
      end;
      C := C.Next;
    end;
  end;
end;

procedure NotifyModuleUnload(HInstance: LongWord);
var
  P: PModuleUnloadRec;
begin
  P := ModuleUnloadList;
  while P <> nil do
  begin
    try
      P.Proc(HInstance);
    except
      // Make sure it doesn't stop notifications
    end;
    P := P.Next;
  end;
end;

procedure RegisterModule(LibModule: PLibModule);
begin
  LibModule.Next := LibModuleList;
  LibModuleList := LibModule;
end;

{X- procedure UnregisterModule(LibModule: PLibModule); -renamed }
procedure UnRegisterModuleSafely( LibModule: PLibModule );
var
  CurModule: PLibModule;
begin
  try
    NotifyModuleUnload(LibModule.Instance);
  finally
    if LibModule = LibModuleList then
      LibModuleList := LibModule.Next
    else
    begin
      CurModule := LibModuleList;
      while CurModule <> nil do
      begin
        if CurModule.Next = LibModule then
        begin
          CurModule.Next := LibModule.Next;
          Break;
        end;
        CurModule := CurModule.Next;
      end;
    end;
  end;
end;

{X+} // "Light" version of UnRegisterModule - without using of try-except
procedure UnRegisterModuleLight( LibModule: PLibModule );
var
  P: PModuleUnloadRec;
begin
  P := ModuleUnloadList;
  while P <> nil do
  begin
    P.Proc(LibModule.Instance);
    P := P.Next;
  end;
end;
{X-}

{ ResString support function }

function LoadResString(ResStringRec: PResStringRec): string;
var
  Buffer: array[0..1023] of Char;
begin
  if ResStringRec <> nil then
  if ResStringRec.Identifier < 64*1024 then
    SetString(Result, Buffer, LoadString(FindResourceHInstance(ResStringRec.Module^),
    ResStringRec.Identifier, Buffer, SizeOf(Buffer)))
  else
    Result := PChar(ResStringRec.Identifier);
end;

procedure _IntfClear(var Dest: IUnknown);
asm
        MOV     EDX,[EAX]
        TEST    EDX,EDX
        JE      @@1
        MOV     DWORD PTR [EAX],0
        PUSH    EAX
        PUSH    EDX
        MOV     EAX,[EDX]
        CALL    [EAX].vmtRelease.Pointer
        POP     EAX
@@1:
end;

procedure _IntfCopy(var Dest: IUnknown; const Source: IUnknown);
asm
        MOV     ECX,[EAX]       { save dest }
        MOV     [EAX],EDX       { assign dest }
        TEST    EDX,EDX         { need to addref source before releasing dest }
        JE      @@1             { to make self assignment (I := I) work right }
        PUSH    ECX
        PUSH    EDX
        MOV     EAX,[EDX]
        CALL    [EAX].vmtAddRef.Pointer
        POP     ECX
@@1:    TEST    ECX,ECX
        JE      @@2
        PUSH    ECX
        MOV     EAX,[ECX]
        CALL    [EAX].vmtRelease.Pointer
@@2:
end;

procedure _IntfCast(var Dest: IUnknown; const Source: IUnknown; const IID: TGUID);
asm
        TEST    EDX,EDX
        JE      _IntfClear
        PUSH    EAX
        PUSH    ECX
        PUSH    EDX
        MOV     ECX,[EAX]
        TEST    ECX,ECX
        JE      @@1
        PUSH    ECX
        MOV     EAX,[ECX]
        CALL    [EAX].vmtRelease.Pointer
        MOV     EDX,[ESP]
@@1:    MOV     EAX,[EDX]
        CALL    [EAX].vmtQueryInterface.Pointer
        TEST    EAX,EAX
        JE      @@2
        MOV     AL,reIntfCastError
        JMP     Error
@@2:
end;

procedure _IntfAddRef(const Dest: IUnknown);
begin
  if Dest <> nil then Dest._AddRef;
end;

procedure TInterfacedObject.AfterConstruction;
begin
// Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);
end;

procedure TInterfacedObject.BeforeDestruction;
begin
  if RefCount <> 0 then Error(reInvalidPtr);
end;

// Set an implicit refcount so that refcounting
// during construction won't destroy the object.
class function TInterfacedObject.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TInterfacedObject(Result).FRefCount := 1;
end;

function TInterfacedObject.QueryInterface(const IID: TGUID; out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

function TInterfacedObject._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TInterfacedObject._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

procedure _CheckAutoResult;
asm
        TEST    EAX,EAX
        JNS     @@2
        MOV     ECX,SafeCallErrorProc
        TEST    ECX,ECX
        JE      @@1
        MOV     EDX,[ESP]
        CALL    ECX
@@1:    MOV     AL,reSafeCallError
        JMP     Error
@@2:
end;


procedure _IntfDispCall;
asm
        JMP     DispCallByIDProc
end;


procedure _IntfVarCall;
asm
end;

function  CompToDouble(acomp: Comp): Double; cdecl;
begin
  Result := acomp;
end;

procedure  DoubleToComp(adouble: Double; var result: Comp); cdecl;
begin
  result := adouble;
end;

function  CompToCurrency(acomp: Comp): Currency; cdecl;
begin
  Result := acomp;
end;

procedure  CurrencyToComp(acurrency: Currency; var result: Comp); cdecl;
begin
  result := acurrency
end;

function GetMemory(Size: Integer): Pointer; cdecl;
begin
  Result := {X- SysGetMem(Size); -replaced to use current memory manager}
            MemoryManager.GetMem( Size );
end;

function FreeMemory(P: Pointer): Integer; cdecl;
begin
  if P = nil then
    Result := 0
  else
    Result := {X- SysFreeMem(P); - replaced to use current memory manager}
              MemoryManager.FreeMem( P );
end;

function ReallocMemory(P: Pointer; Size: Integer): Pointer; cdecl;
begin
  {X- Result := SysReallocMem(P, Size); - replaced to use current memory manager}
  Result := MemoryManager.ReallocMem( P, Size );
end;

function GetCurrentThreadId: DWORD; stdcall; external kernel name 'GetCurrentThreadId';

{X} // convert var CmdLine : PChar to a function:
{X} function CmdLine : PChar;
{X} begin
{X}   Result := GetCommandLine;
{X} end;

initialization

  {X- initialized by 0 anyway
  ExitCode  := 0;
  ErrorAddr := nil;

  RandSeed := 0;
  X+}

  {X- initialized statically
  FileMode := 2;

  Test8086 := 2;
  Test8087 := 3;
  X+}

  {X- moved to SysVarnt.pas

  TVarData(Unassigned).VType := varEmpty;
  TVarData(Null).VType := varNull;
  TVarData(EmptyParam).VType := varError;
  TVarData(EmptyParam).VError := $80020004; //DISP_E_PARAMNOTFOUND

  ClearAnyProc := @VarInvalidOp;
  ChangeAnyProc := @VarCastError;
  RefAnyProc := @VarInvalidOp;

  X+}

  {X-
  if _isNECWindows then _FpuMaskInit;
  FpuInit();
  X+}

  {X- to use Input/Output, call UseInputOutput (or include
      following two lines into your code and call Close(Input),
      Close(Output) at the end of execution).
  _Assign( Input, '' );
  _Assign( Output, '' );
  X+}

{X-  CmdLine := GetCommandLine; converted to a function }
{X-  CmdShow := GetCmdShow;     converted to a function }
  MainThreadID := GetCurrentThreadID;

finalization
  {X}if assigned( CloseInputOutput ) then
  {X}   CloseInputOutput;
  {X-
  Close(Input);
  Close(Output);
  X+}
{X  UninitAllocator; - replaced with call to UninitMemoryManager handler. }
  UninitMemoryManager;
end.
