
{*******************************************************} //  XCL version of SysInit
{                                                       } // unit. Created Jun-2000
{       Borland Delphi Runtime Library                  } // (C) by Kladov Vladimir
{       System Initialization Unit                      } //
{                                                       } // purpose: make XCL Delphi
{       Copyright (C) 1997,99 Inprise Corporation       } // programs even smaller.
{                                                       } //
{*******************************************************} // Changes are marked as {X}

unit SysInit;

interface

{X} // if your app really need to localize resource, call:
{X} procedure UseLocalizeResources;

var
  ModuleIsLib: Boolean;         { True if this module is a dll (a library or a package) }
  ModuleIsPackage: Boolean;     { True if this module is a package }
  ModuleIsCpp: Boolean;         { True if this module is compiled using C++ Builder }
  TlsIndex: Integer;            { Thread local storage index }
  TlsLast: Byte;                { Set by linker so its offset is last in TLS segment }
  HInstance: LongWord;          { Handle of this instance }
  {$EXTERNALSYM HInstance}
  (*$HPPEMIT 'namespace Sysinit' *)
  (*$HPPEMIT '{' *)
  (*$HPPEMIT 'extern PACKAGE HINSTANCE HInstance;' *)
  (*$HPPEMIT '} /* namespace Sysinit */' *)
  DllProc: Pointer;             { Called whenever DLL entry point is called }
  DataMark: Integer = 0;        { Used to find the virtual base of DATA seg }

procedure _GetTls;
function _InitPkg(Hinst: Integer; Reason: Integer; Resvd: Pointer): LongBool; stdcall;
procedure _InitLib;
procedure _InitExe;

{ Invoked by C++ startup code to allow initialization of VCL global vars }
procedure VclInit(isDLL, isPkg: Boolean; hInst: LongInt; isGui: Boolean); cdecl;
procedure VclExit; cdecl;

implementation

{X- moved to System.pas (by A.Torgashin)

const
  kernel = 'kernel32.dll';

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

{X+}

const
  tlsArray      = $2C;    { offset of tls array from FS: }
  LMEM_ZEROINIT = $40;

var
  TlsBuffer: Pointer;
  Module: TLibModule = (
    Next: nil;
    Instance: 0;
    CodeInstance: 0;
    DataInstance: 0;
    ResInstance: 0;
    Reserved: 0);

procedure       InitThreadTLS;
var
  p: Pointer;
begin
  if @TlsLast = nil then
    Exit;
  if TlsIndex < 0 then
    RunError(226);
  p := LocalAlloc(LMEM_ZEROINIT, Longint(@TlsLast));
  if p = nil then
    RunError(226)
  else
    TlsSetValue(TlsIndex, p);
  tlsBuffer := p;
end;


procedure       InitProcessTLS;
var
  i: Integer;
begin
  if @TlsLast = nil then
    Exit;
  i := TlsAlloc;
  TlsIndex := i;
  if i < 0 then
    RunError(226);
  InitThreadTLS;
end;


procedure       ExitThreadTLS;
var
  p: Pointer;
begin
  if @TlsLast = nil then
    Exit;
  if TlsIndex >= 0 then begin
    p := TlsGetValue(TlsIndex);
    if p <> nil then
      LocalFree(p);
  end;
end;


procedure       ExitProcessTLS;
begin
  if @TlsLast = nil then
    Exit;
  ExitThreadTLS;
  if TlsIndex >= 0 then
    TlsFree(TlsIndex);
end;


procedure _GetTls;
asm
        MOV     CL,ModuleIsLib
        MOV     EAX,TlsIndex
        TEST    CL,CL
        JNE     @@isDll
        MOV     EDX,FS:tlsArray
        MOV     EAX,[EDX+EAX*4]
        RET

@@initTls:
        CALL    InitThreadTLS
        MOV     EAX,TlsIndex
        PUSH    EAX
        CALL    TlsGetValue
        TEST    EAX,EAX
        JE      @@RTM32
        RET

@@RTM32:
        MOV     EAX, tlsBuffer
        RET

@@isDll:
        PUSH    EAX
        CALL    TlsGetValue
        TEST    EAX,EAX
        JE      @@initTls
end;


const
  DLL_PROCESS_DETACH = 0;
  DLL_PROCESS_ATTACH = 1;
  DLL_THREAD_ATTACH  = 2;
  DLL_THREAD_DETACH  = 3;

  TlsProc: array [DLL_PROCESS_DETACH..DLL_THREAD_DETACH] of procedure =
    (ExitProcessTLS,InitProcessTLS,InitThreadTLS,ExitThreadTLS);

procedure InitializeModule;
{X+
var
  FileName: array[0..260] of Char;
X-}
begin
  {X+
  GetModuleFileName(HInstance, FileName, SizeOf(FileName));
  Module.ResInstance := LoadResourceModule(FileName);
  if Module.ResInstance = 0 then
  X-}
     Module.ResInstance := Module.Instance;
  RegisterModule(@Module);
end;

procedure UseLocalizeResources;
var
  FileName: array[0..260] of Char;
begin
  GetModuleFileName(HInstance, FileName, SizeOf(FileName));
  Module.ResInstance := LoadResourceModule(FileName);
  if Module.ResInstance = 0 then
     Module.ResInstance := Module.Instance;
end;

procedure UninitializeModule;
begin
  UnregisterModule(@Module);
  if Module.ResInstance <> Module.Instance then FreeLibrary(Module.ResInstance);
end;

procedure VclInit(isDLL, isPkg: Boolean; hInst: LongInt; isGui: Boolean); cdecl;
begin
  if isPkg then
  begin
    ModuleIsLib := True;
    ModuleIsPackage := True;
  end else
  begin
    IsLibrary := isDLL;
    ModuleIsLib := isDLL;
    ModuleIsPackage := False; //!!! really unnessesary since DATASEG should be nulled
  end;
  HInstance := hInst;
  Module.Instance := hInst;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  ModuleIsCpp := True;
  InitializeModule;
  if not ModuleIsLib then
  begin
    Module.CodeInstance := FindHInstance(@VclInit);
    Module.DataInstance := FindHInstance(@DataMark);
{X  CmdLine := GetCommandLine; - converted to a function }
    IsConsole := not isGui;
  end;
end;

procedure VclExit; cdecl;
var
  P: procedure;
begin
  if not ModuleIsLib then
    while ExitProc <> nil do
    begin
      @P := ExitProc;
      ExitProc := nil;
      P;
    end;
  UnInitializeModule;
end;

function _InitPkg(Hinst: Longint; Reason: Integer; Resvd: Pointer): Longbool; stdcall;
begin
  ModuleIsLib := True;
  ModuleIsPackage := True;
  Module.Instance := Hinst;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  HInstance := Hinst;
  if @TlsLast <> nil then
    TlsProc[Reason];
  if Reason = DLL_PROCESS_ATTACH then
    InitializeModule
  else if Reason = DLL_PROCESS_DETACH then
    UninitializeModule;
  _InitPkg := True;
end;


procedure _InitLib;
asm
        { ->    EAX Inittable   }
        {       [EBP+8] Hinst   }
        {       [EBP+12] Reason }
        {       [EBP+16] Resvd  }

        MOV     EDX,offset Module
        CMP     dword ptr [EBP+12],DLL_PROCESS_ATTACH
        JNE     @@notInit

        PUSH    EAX
        PUSH    EDX
        MOV     ModuleIsLib,1
        MOV     ECX,[EBP+8]
        MOV     HInstance,ECX
        MOV     [EDX].TLibModule.Instance,ECX
        MOV     [EDX].TLibModule.CodeInstance,0
        MOV     [EDX].TLibModule.DataInstance,0
        CALL    InitializeModule
        POP     EDX
        POP     EAX

@@notInit:
        PUSH    DllProc
        MOV     ECX,offset TlsProc
        CALL    _StartLib
end;


procedure _InitExe;
asm
        { ->    EAX Inittable   }

{       MOV     ModuleIsLib,0   ; zero initialized anyway }

        PUSH    EAX

        PUSH    0
        CALL    GetModuleHandle

        MOV     EDX,offset Module
        PUSH    EDX
        MOV     HInstance,EAX
        MOV     [EDX].TLibModule.Instance,EAX
        MOV     [EDX].TLibModule.CodeInstance,0
        MOV     [EDX].TLibModule.DataInstance,0
        CALL    InitializeModule
        POP     EDX
        POP     EAX

        CALL    _StartExe
end;

end.
