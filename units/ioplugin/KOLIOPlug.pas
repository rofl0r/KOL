////////////////////////////////////////////////////////////////////////////////
//
//      Winamp I/O plugin header adaption for Delphi/Pascal by Snake
//      Converted to KOL by Dimaxx
//
////////////////////////////////////////////////////////////////////////////////
//
// (Based on the mini-SDK from Justin Frankel/Nullsoft Inc.)
//
// This ioplug.pas unit contains the follwing converted C-headers:
// in2.h, out.h
//
// Download:
// E-Mail: <snakers@gmx.net>
//
// This unit has 4 managment-functions:
//
// function InitInputDLL(dll:string) : Boolean;
// Loads the proc-address for getInModule from <dll> at runtime.
//
// function InitOutputDLL(dll:string) : Boolean;
// Loads the proc-address for getOutModule from <dll> at runtime.
//
// procedure CloseInputDLL;
// Releases the runtime-link to the input DLL and sets all proc-addresses to nil.
// You don't have to call this procedure, because the Finalization section do it for you.
//
// procedure CloseOutputDLL;
// Releases the runtime-link to the Output DLL and sets all proc-addresses to nil.
// You don't have to call this procedure, because the Finalization section do it for you.
//
// Modyfied: 8. Dec. 1999
//
////////////////////////////////////////////////////////////////////////////////

unit KOLIOPlug;

{$MINENUMSIZE 4}
{$ALIGN ON}

interface

uses Windows;

///////////////////////////////////////////////////////////////////////////////
//	MODULE PROTOTYPES
///////////////////////////////////////////////////////////////////////////////

type
  TData = array[1..10] of byte;
  TInModule = record
    // module type (IN_VER)
    Version: integer;
    // description of module, with version string
    Description: PChar;
    // winamp's main window (filled in by winamp)
    hMainWindow: integer;
    // DLL instance handle (Also filled in by winamp)
    hDllInstance: longword;
    // "mp3\0Layer 3 MPEG\0mp2\0Layer 2 MPEG\0mpg\0Layer 1 MPEG\0"
    // May be altered from Config, so the user can select what they want
    FileExtensions: PChar;
    // is this stream seekable?
    IsSeekable: integer;
    // does this plug-in use the output plug-ins? (musn't ever change, ever :)
    UsesOutputPlug: integer;
    // configuration dialog
    Config: procedure(hwndParent: HWND); cdecl;
    // about dialog
    About: procedure(hwndParent: HWND); cdecl;
    // called at program init
    Init: procedure; cdecl;
    // called at program quit
    Quit: procedure; cdecl;
    // if file = NULL, current playing is used
    GetFileInfo: procedure(var _File,Title: PChar; var LengthInMs: integer); cdecl;
    InfoBox: function(_File: PChar; hwndParent: HWND):integer;cdecl;
    // called before extension checks, to allow detection of mms:
    IsOurFile: function(FN: PChar): integer; cdecl;

///////////////////////////////////////////////////////////////////////////////
//	playback stuff
///////////////////////////////////////////////////////////////////////////////

    // return zero on success, -1 on file-not-found, some other value on other
    // (stopping winamp) error
    Play: function(FN: PChar): integer; cdecl;
    // pause stream
    Pause: procedure; cdecl;
    // unpause stream
    UnPause: procedure; cdecl;
    // ispaused? return 1 if paused, 0 if not
    IsPaused: function: integer; cdecl;
    // stop (unload) stream
    Stop: procedure; cdecl;

///////////////////////////////////////////////////////////////////////////////
//	time stuff
///////////////////////////////////////////////////////////////////////////////

    // get length in ms
    GetLength: function: integer; cdecl;
    // returns current output time in ms. (usually returns outMod->GetOutputTime()
    GetOutputTime: function: integer; cdecl;
    // seeks to point in stream (in ms). Usually you signal yoru thread to seek,
    // which seeks and calls outMod->Flush().
    SetOutputTime: procedure(TimeInMs: integer); cdecl;

///////////////////////////////////////////////////////////////////////////////
//	volume stuff
///////////////////////////////////////////////////////////////////////////////

    // from 0 to 255.. usually just call outMod->SetVolume
    SetVolume: procedure(Volume: integer); cdecl;
    // from -127 to 127.. usually just call outMod->SetPan
    SetPan: procedure(Pan: integer); cdecl;

///////////////////////////////////////////////////////////////////////////////
//	in-window builtin vis stuff
///////////////////////////////////////////////////////////////////////////////

    // call once in Play(). maxlatency_in_ms should be the value returned from
    // outMod->Open()
    SAVSAInit: procedure(MaxLatencyInMs,Srate: integer); cdecl;
    // call in Stop()
    SAVSADeInit: procedure; cdecl;

///////////////////////////////////////////////////////////////////////////////
//	simple vis supplying mode
///////////////////////////////////////////////////////////////////////////////

    // sets the spec data directly from PCM data quick and easy way to get
    // vis working :) needs at least 576 samples :) Advanced vis supplying
    // mode, only use if you're cool. Use SAAddPCMData for most stuff.
    SAAddPCMData: procedure(PCMData: pointer; Nch,Bps,Timestamp: integer); cdecl;
    // gets csa (the current type (4=ws,2=osc,1=spec)) use when calling SAAdd()
    SAGetMode: function: integer; cdecl;
    // sets the spec data, filled in by winamp vis stuff (plug-in)
    // simple vis supplying mode
    SAAdd: procedure(Data: pointer; Timestamp,Csa: integer); cdecl;
    // sets the vis data directly from PCM data
    // quick and easy way to get vis working :)
    // needs at least 576 samples :)
    VSAAddPCMData: procedure(PCMData: pointer; Nch,Bps,Timestamp: integer); cdecl;
    // advanced vis supplying mode, only use if you're cool. Use VSAAddPCMData
    // for most stuff. Use to figure out what to give to VSAAdd
    VSAGetMode: function(var SpecNch,WaveNch: integer): integer; cdecl;
    // filled in by winamp, called by plug-in
    VSAAdd: procedure(Data: pointer; Timestamp: integer); cdecl;
    // call this in Play() to tell the vis plug-ins the current output params.
    VSASetInfo: procedure(Nch,SRate: integer); cdecl;

    // dsp plug-in processing:
    // (filled in by winamp, called by input plug)
    // returns 1 if active (which means that the number of samples returned by
    // dsp_dosamples could be greater than went in. Use it to estimate if you'll
    // have enough room in the output buffer
    DspIsActive: function: integer; cdecl;
    // returns number of samples to output. This can be as much as twice
    // numsamples. Be sure to allocate enough buffer for samples, then.
    DspDoSamples: function(Samples: pointer; NumSamples,Bps,Nch,SRate: integer): integer; cdecl;

///////////////////////////////////////////////////////////////////////////////
//	eq stuff
///////////////////////////////////////////////////////////////////////////////

    // 0-64 each, 31 is +0, 0 is +12, 63 is -12. Do nothing to ignore.
    EQSet: procedure(On: integer; Sata: TData; Preamp: integer); cdecl;
    // info setting (filled in by winamp)
    // if -1, changes ignored? :)
    SetInfo:procedure(BitRate,SRate,Stereo,Synched: integer); cdecl;
    // filled in by winamp, optionally used :)
    OutMod: pointer;
  end;

  TOutModule=record
    // module version (OUT_VER)
    Version: integer;
    // description of module, with version string
    Description: PChar;
    // module id. each input module gets its own. non-nullsoft modules should
    // be >= 65536.
    ID: integer;
    // winamp's main window (filled in by winamp)
    hMainWindow: integer;
    // DLL instance handle (filled in by winamp)
    hDllInstance: longword;
    // configuration dialog
    Config: procedure(hwndParent: HWND); cdecl;
    // about dialog
    About: procedure(hwndParent: HWND); cdecl;
    // called when loaded
    Init: procedure; cdecl;
    // called when unloaded
    Quit: procedure; cdecl;
    // returns >=0 on success, <0 on failure
    // NOTE: bufferlenms and prebufferms are ignored in most if not all output
    // plug-ins. ... so don't expect the max latency returned to be what you asked
    // for. returns max latency in ms (0 for diskwriters, etc) bufferlenms and
    // prebufferms must be in ms. 0 to use defaults. prebufferms must be <= bufferlenms
    Open: function(SampleRate,NumChannels,BitsPerSamp,BufferLenMs,PreBufferMs: integer): integer; cdecl;
    // close the old output device.
    Close: procedure; cdecl;
    // 0 on success. Len == bytes to write (<= 8192 always). buf is straight audio data.
    // 1 returns not able to write (yet). Non-blocking, always.
    Write: function(Buf: pointer; Len: integer): integer; cdecl;
    // returns number of bytes possible to write at a given time.
    // Never will decrease unless you call Write (or Close, heh)
    CanWrite: function: integer; cdecl;
    // non 0 if output is still going or if data in buffers waiting to be
    // written (i.e. closing while IsPlaying() returns 1 would truncate the song
    IsPlaying: function: integer; cdecl;
    // returns previous pause state
    Pause: function(Pause: integer): integer; cdecl;
    // volume is 0-255
    SetVolume: procedure(Volume: integer); cdecl;
    // pan is -128 to 128
    SetPan: procedure(Pan: integer); cdecl;
    // flushes buffers and restarts output at time t (in ms). used for seeking
    Flush: procedure(T: integer); cdecl;
    // returns played time in MS
    GetOutputTime: function: integer; cdecl;
    // returns time written in MS (used for synching up vis stuff)
    GetWrittenTime: function: integer; cdecl;
end;

//---------------------------------------------------------------------------------------------------------

var
  GetInModule: function: pointer; stdcall;
  GetOutModule: function: pointer; stdcall;

const
  InputDLLHandle : THandle = 0;
  OutputDLLHandle: THandle = 0;

function InitInputDLL(DLL: string): boolean;
function InitOutputDLL(DLL: string): boolean;
procedure CloseInputDLL;
procedure CloseOutputDLL;

//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------

implementation

function InitInputDLL(DLL: string): boolean;
begin
  Result:=False;
  GetInModule:=nil;
  if InputDLLHandle<>0 then CloseInputDLL;
  InputDLLHandle:=LoadLibrary(PChar(DLL));
  if InputDLLHandle=0 then Exit;
  GetInModule:=GetProcAddress(InputDLLHandle,'winampGetInModule2');
  if @GetInModule<>nil then Result:=True;
end;

function InitOutputDLL(DLL: string): boolean;
begin
  Result:=False;
  GetOutModule:=nil;
  if OutputDLLHandle<>0 then CloseOutputDLL;
  OutputDLLHandle:=LoadLibrary(PChar(DLL));
  if OutputDLLHandle=0 then Exit;
  GetOutModule:=GetProcAddress(OutputDLLHandle,'winampGetOutModule');
  if @GetOutModule<>nil then Result:=True;
end;

procedure CloseInputDLL;
begin
  GetInModule:=nil;
  if InputDLLHandle<>0 then
    begin
      FreeLibrary(InputDLLHandle);
      InputDLLHandle:=0;
    end;
end;

procedure CloseOutputDLL;
begin
  GetOutModule:=nil;
  if OutputDLLHandle<>0 then
    begin
      FreeLibrary(OutputDLLHandle);
      OutputDLLHandle:=0;
    end;
end;

initialization
begin
  GetInModule:=nil;
  GetOutModule:=nil;
end

finalization
begin
  CloseInputDLL;
  CloseOutputDLL;
end

end.

