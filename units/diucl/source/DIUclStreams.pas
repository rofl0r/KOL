{ ------------------------------------------------------------------------------

  DIUclStreams.pas -- UCL Compression and Decompression Streams

  This file is part of the DIUcl package.

  Copyright (c) 2003 Ralf Junker - The Delphi Inspiration
  All Rights Reserved.

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  Ralf Junker - The Delphi Inspiration
  <delphi@zeitungsjunge.de>
  http://www.zeitungsjunge.de/delphi/

  UCL is Copyright (c) 1996-2002 Markus Franz Xaver Johannes Oberhumer
  All Rights Reserved.

  Markus F.X.J. Oberhumer
  <markus@oberhumer.com>
  http://www.oberhumer.com/opensource/ucl/

------------------------------------------------------------------------------ }

(* @abstract (UCL Compression and Decompressions Streams.)
   @Name supports KOL (<A href="http://bonanzas.rinet.ru" target=_blank>
   http://bonanzas.rinet.ru</A>) via a compile time option. Compilation for
   KOL is controlled by defining the 'KOL' compiler directive via the menu
   option Project -> Options -> Directories/Conditionals -> Conditional Defines
   and enter 'KOL' there, or at the command line (-DKOL), or by editing the
   source code of this unit: Remove the "." from the {.$DEFINE KOL} sequence.
   In any case: Make sure to rebuld your code after each change by invoking
   the Project -> Build menu entry. *)
unit DIUclStreams;
{* UCL Compression and Decompression Streams. }

{$I DI.inc}

{.$DEFINE KOL}// Default: Off
{ Define to create small applications using KOL (http://bonanzas.rinet.ru). }

interface

uses
  {$IFDEF KOL}
  Windows,
  KOL
  {$ELSE}
  SysUtils,
  Classes,
  DIUclApi
  {$ENDIF}
  ; // One semicolon only, the KOL XHelpGen gets confused otherwise!

{$IFDEF KOL}
const
  STREAM_ERROR = $FFFFFFFF;

type
  TUclProgressEvent = procedure(const Sender: PObj; const InBytes, OutBytes: Cardinal) of object;
  {* Progress callback procedure definition for UclCompressStream and
     UclDecompressStream. }

function NewUclCStream(const CompressionLevel: Integer; const BufferSize: Cardinal; const Destination: PStream; const OnProgress: TUclProgressEvent = nil): PStream;
{* Creates a new UCL compression stream. Returns nil if UCL initialization
   fails. The Read/Write functions return STREAM_ERROR ($FFFFFFFF) on errors.
   This is true also for Seek.
   |<P>
   CompressionLevel range is from 1 for minumum to 10 for maximum compression.
   Whenever possible, use maximum compression (10). Higher values take longer
   to compress, but decompression is not affected. It will always be extremely
   fast.
   |<P>
   BufferSize determines how much memory will be used for a single block memory
   compression. Larger buffers will achieve better compression. A BufferSize of
   $40000 achieves reasonable compression similar to ZIP archives. Use $80000 or
   above to challenge BZip2.
   |<P>
   Important: BufferSize must be the same for both the compression and
   decompression streams.
   |<P>
   See also: NewUclDStream. }

function NewUclCCStream(out Stream: PStream; const CompressionLevel: Integer; BufferSize: Cardinal; const Destination: PStream; OnProgress: TUclProgressEvent = nil): Boolean;
{* Calls NewUclCStream and returns @True if Result <> nil; Stream = Result. }

function NewUclDStream(const BufferSize: Cardinal; const Source: PStream; const OnProgress: TUclProgressEvent = nil): PStream;
{* Creates a new UCL decompression stream. Returns nil if UCL initialization
   fails. The Read/Write functions return STREAM_ERROR ($FFFFFFFF) on errors.
   This is true also for Seek.
   |<P>
   BufferSize determines how much memory will be used to decompress a single
   block of memory. It must be the same as that used by for compressing the
   stream.
   |<P>
   See also: NewUclCStream. }

function NewUclDDStream(out Stream: PStream; const BufferSize: Cardinal; const Source: PStream; const OnProgress: TUclProgressEvent = nil): Boolean;
{* Calls NewUclDStream and returns True if Result <> nil; Stream = Result. }

{$ELSE KOL}

type
  TUclCustomStream = class;

  { Progress callback procedure definition for @link(UclCompressStream) and
    @link(UclDecompressStream). }
  TUclProgressEvent = procedure(const Sender: TUclCustomStream; const InBytes, OutBytes: Cardinal) of object;

  { ---------------------------------------------------------------------------- }
  { TUclCustomStream
  { ---------------------------------------------------------------------------- }

  { @abstract(Base class for @link(TUclCompressionStream) and @link(TUclDecompressionStream).) }
  TUclCustomStream = class(TStream)
  private
    FStream: TStream;
    FBuffer: ^Byte;
    FBufferPos: ^Byte;
    FBufferSize: Cardinal;
    FBufferAlloc: Cardinal;
    FBufferFree: Cardinal;
    FTotalIn: Cardinal;
    FTotalOut: Cardinal;
    FOnProgress: TUclProgressEvent;
    class procedure ErrorCheck(const ErrorCode: Integer);
  protected
    class procedure Error(const ResStringRec: PResStringRec; const Args: array of const);
    { Called periodically to indicate compression / decompression progress.
      Triggers @link(OnProgress). }
    procedure DoProgress(const InBytes, OutBytes: Cardinal); dynamic;
    { Progress Event, triggered periodically to indicate compression /
      decompression progress. }
    property OnProgress: TUclProgressEvent read FOnProgress write FOnProgress;
  public
    { @abstract(Creates a new UCL compression stream.)
      Upon creating @ClassName, an exception will be raised if UCL
      initialization fails.
      <P>BufferSize determines how much memory will be used to compress /
      decompress a single block of memory. It must be the same for decompression
      as was used for compressing the stream.
      <P>See also: @link(TUclCompressionStream), @link(TUclDecompressionStream). }
    constructor Create(const BufferSize: Cardinal; const Stream: TStream);
    { Destroys an instance of @ClassName. }
    destructor Destroy; override;
  end;

  { ---------------------------------------------------------------------------- }
  { TUclCompressionStream
  { ---------------------------------------------------------------------------- }

  { @abstract(@Name compresses data on the fly it is written, and stores it to
    another stream.)
    @Name is write-only and strictly sequential. Reading from the
    stream will raise an exception.
    <P>Output data is cached internally, written to the output stream only when
    the internal output buffer is full. All pending output data is flushed
    when the stream is destroyed.
    <P>The @link(OnProgress) event is called periodically when the output buffer
    is filled and written to the output stream. This is useful for updating a
    progress indicator when you are writing a large chunk of data to the
    compression stream in a single call.
    <P>Seek operations are limited to the beginning of the stream and the
    current position only. }
  TUclCompressionStream = class(TUclCustomStream)
  private
    FBufferStart: ^Byte;
    FCallback: ucl_progress_callback_t;
    FCompressionLevel: Integer;
  public
    { @abstract(Creates a new UCL compression stream.)
      Upon creating @ClassName, an exception will be raised if UCL
      initialization fails.
      <P>CompressionLevel range is from 1 for minumum to 10 for maximum
      compression. Whenever possible, use maximum compression (10). Higher
      values take longer to compress, but decompression is not affected. It will
      always be extremely fast.
      <P>BufferSize determines how much memory will be used for a single block
      memory compression. Larger buffers will achieve better compression. A
      BufferSize of $40000 achieves reasonable compression similar to ZIP
      archives. Use $80000 or above to challenge BZip2.
      <P>Important: BufferSize must be the same for both the compression and
      decompression streams.
      <P>See also: @link(TUclDecompressionStream), @link(TUclCustomStream). }
    constructor Create(const CompressionLevel: Integer; const BufferSize: Cardinal; const Dest: TStream);
    { Destroys an instance of @ClassName. }
    destructor Destroy; override;
    { Not allowed, will raise an exception. }
    function Read(var Buffer; Count: Integer): Integer; override;
    { Writes to the compressed stream, compressing on the fly. }
    function Write(const Buffer; Count: Integer): Integer; override;
    { Moves the current position of the stream. Seek operations are limited
      to the beginning of the stream and to the current position only. Moving
      to the beginning of the stream clears all data compressed so far. }
    function Seek(Offset: Integer; Origin: Word): Integer; override;
    { See inherited @Inherited. }
    property OnProgress;
  end;

  { ---------------------------------------------------------------------------- }
  { TUclDeCompressionStream
  { ---------------------------------------------------------------------------- }

  { @abstract(@Name decompresses data on the fly as data is read from it.)
    Compressed data comes from a separate source stream. @Name is read-only. You
    can seek in the stream: Seeking forward decompresses data until the
    requested position in the uncompressed data has been reached. Seeking
    backwards, seeking relative to the end of the stream, requesting the size
    of the stream, and writing to the stream all use forward seeking internally.
    Excessive random seeking in a compressed stream can decrease performance and
    is not recommended. Seeking does not generate progress events. }
  TUclDeCompressionStream = class(TUclCustomStream)
  public
    { Reads from the compressed stream, decompressing on the fly. }
    function Read(var Buffer; Count: Integer): Integer; override;
    { Not allowed, will raise an exception. }
    function Write(const Buffer; Count: Integer): Integer; override;
    { Moves the current position of the stream. All seek operations are allowed,
      but seeking backwards can decrease performance and is therefore not
      recommendet. }
    function Seek(Offset: Integer; Origin: Word): Integer; override;
    { See inherited @Inherited. }
    property OnProgress;
  end;

  { }
  EUclError = class(Exception);

resourcestring
  SUclError = 'UCL Error %d';
  SInvalidUclStreamData = 'Invalid UCL stream data';
  SInvalidUclStreamOperation = 'Invalid UCL stream operation';
  {$ENDIF KOL}

type
  { Progress callback procedure definition for @link(UclCompressStream) and
    @link(UclDecompressStream). }
  TUclProgress = procedure(const InBytes, OutBytes: Cardinal; const User: Pointer);
  {* Progress callback procedure definition for UclCompressStream and
     UclDecompressStream. }

  { Compresses AInStream to OutStream. The compression format of AOutStream is
    compatible with @link(TUclCompressionStream) and @link(TUclDecompressionStream).
    <P>@Name periodically calls AOnProgress, if assigned. AUser is passed to the
    @link(TUclProgress) procedure unchanged.
    <P>See also: @link(UclDeCompressStream). }
function UclCompressStream(const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF}; const ACompressionLevel: Integer = 10; const ABufferSize: Cardinal = $1000; const AOnProgress: TUclProgress = nil; const AUser: Pointer = nil): Boolean;
{* Compresses AInStream to AOutStream. The compression format of OutStream is
   compatible with TUclCompressionStream and TUclDecompressionStream.
   |<P>
   UclCompressStream periodically calls AOnProgress, if assigned. AUser is
   passed to the TUclProgress procedure unchanged.
   |<P>
   See also: UclDeCompressStream. }

{ Decompresses InStream to OutStream. The compression format of InStream must be
  compatible with @link(TUclCompressionStream) and @link(TUclDecompressionStream).
  <P>@Name periodically calls AOnProgress, if assigned. AUser is passed to the
  @link(TUclProgress) procedure unchanged.
  <P>See also: @link(UclCompressStream). }
function UclDeCompressStream(const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF}; const ABufferSize: Cardinal = $1000; const AOnProgress: TUclProgress = nil; const AUser: Pointer = nil): Boolean;
{* Decompresses InStream to OutStream. The compression format of InStream must be
   compatible with TUclCompressionStream and TUclDecompressionStream.
   |<P>
   UclDeCompressStream periodically calls AOnProgress, if assigned. AUser is
   passed to the TUclProgress procedure unchanged.
   |<P>
   See also: UclCompressStream. }

implementation

{$IFDEF KOL}
uses
  DIUclApi;
{$ELSE}
uses
  {$IFDEF COMPILER_6_UP}RTLConsts{$ELSE}Consts{$ENDIF};
{$ENDIF}

{ ---------------------------------------------------------------------------- }

type
  PUclUser = ^TUclUser;
  TUclUser = record
    InBytes: Cardinal;
    OutBytes: Cardinal;
    OnProgress: TUclProgress;
    User: Pointer;
  end;

  { ---------- }

procedure UclCompressStreamCallback(ATextSize: Cardinal; ACodeSize: Cardinal; AState: Integer; AUser: Pointer);
begin
  with PUclUser(AUser)^ do
    OnProgress(InBytes + ATextSize, OutBytes + ACodeSize, User);
end;

{ ---------- }

function UclCompressStream(const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF}; const ACompressionLevel: Integer = 10; const ABufferSize: Cardinal = $1000; const AOnProgress: TUclProgress = nil; const AUser: Pointer = nil): Boolean;
var
  b, s: ^Byte;
  a, r, f: Cardinal;
  Callback: ucl_progress_callback_t;
  cb: ucl_progress_callback_p;
  User: TUclUser;
begin
  if Assigned(AOnProgress) then
    begin
      User.InBytes := 0;
      User.OutBytes := 0;
      User.OnProgress := AOnProgress;
      User.User := AUser;
      Callback.Callback := UclCompressStreamCallback;
      Callback.User := @User;
      cb := @Callback;
    end
  else
    cb := nil;

  a := ucl_output_block_size(ABufferSize);
  GetMem(b, a);
  try
    s := b;
    Inc(s, a - ABufferSize);
    r := AInStream.Read(s^, ABufferSize);
    if r > 0 then
      repeat
        f := ABufferSize;
        Result := ucl_nrv2e_99_compress(s, r, b, f, cb, ACompressionLevel, nil, nil) = UCL_E_OK;
        if not Result then Break;
        Result := AOutStream.Write(f, SizeOf(f)) = SizeOf(f);
        if not Result then Break;
        Result := Cardinal(AOutStream.Write(b^, f)) = f;
        if not Result then Break;
        Inc(User.InBytes, r);
        Inc(User.OutBytes, f);
        r := AInStream.Read(s^, ABufferSize);
      until r = 0
    else
      Result := True;
  finally
    FreeMem(b);
  end;
end;

{ ---------------------------------------------------------------------------- }

function UclDeCompressStream(const AInStream, AOutStream: {$IFDEF KOL}PStream{$ELSE}TStream{$ENDIF}; const ABufferSize: Cardinal = $1000; const AOnProgress: TUclProgress = nil; const AUser: Pointer = nil): Boolean;
label
  Fail;
var
  b, s: ^Byte;
  a, f, r, InBytes, OutBytes: Cardinal;
begin
  a := ucl_output_block_size(ABufferSize);
  InBytes := 0;
  OutBytes := 0;
  GetMem(b, a);
  try
    repeat
      f := AInStream.Read(r, SizeOf(r));
      Result := f = 0;
      if Result then Break;
      Result := f = SizeOf(r);
      if not Result then Break;
      Result := r <= a;
      if not Result then Break;
      s := b;
      Inc(s, a - r);
      Result := Cardinal(AInStream.Read(s^, r)) = r;
      if not Result then Break;
      f := a;
      {$IFDEF KOL}
      Result := ucl_nrv2e_decompress_asm_safe_8(s, r, b, f, nil) = UCL_E_OK;
      {$ELSE}
      Result := ucl_nrv2e_decompress_asm_fast_safe_8(s, r, b, f, nil) = UCL_E_OK;
      {$ENDIF}
      if not Result then Break;
      Result := Cardinal(AOutStream.Write(b^, f)) = f;
      if not Result then Break;
      if Assigned(AOnProgress) then
        begin
          Inc(InBytes, r);
          Inc(OutBytes, f);
          AOnProgress(InBytes, OutBytes, AUser);
        end;
    until False;
  finally
    FreeMem(b);
  end;
end;

{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}
type
  TUclCData = record
    FStream: PStream;
    FBuffer: ^Byte;
    FBufferPos: ^Byte;
    FBufferSize: Cardinal;
    FBufferAlloc: Cardinal;
    FBufferFree: Cardinal;
    FTotalIn: Cardinal;
    FTotalOut: Cardinal;
    FOnProgress: TUclProgressEvent;
    FBufferStart: ^Byte;
    FCallback: ucl_progress_callback_t;
    FCompressionLevel: Integer;
  end;
  PUclCData = ^TUclCData;

  TUclDData = record
    FStream: PStream;
    FBuffer: ^Byte;
    FBufferPos: ^Byte;
    FBufferSize: Cardinal;
    FBufferAlloc: Cardinal;
    FBufferFree: Cardinal;
    FTotalIn: Cardinal;
    FTotalOut: Cardinal;
    FOnProgress: TUclProgressEvent;
  end;
  PUclDData = ^TUclDData;
  {$ENDIF}

  { ---------------------------------------------------------------------------- }
  { TUclCustomStream
  { ---------------------------------------------------------------------------- }

  {$IFNDEF KOL}
constructor TUclCustomStream.Create(const BufferSize: Cardinal; const Stream: TStream);
begin
  inherited Create;
  ErrorCheck(ucl_init);
  FStream := Stream;
  FBufferSize := BufferSize;
  FBufferAlloc := ucl_output_block_size(BufferSize);
  GetMem(FBuffer, FBufferAlloc);
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF KOL}
destructor TUclCustomStream.Destroy;
begin
  FreeMem(FBuffer);
  inherited Destroy;
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF KOL}
procedure TUclCustomStream.DoProgress(const InBytes, OutBytes: Cardinal);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, InBytes, OutBytes);
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF KOL}
class procedure TUclCustomStream.Error(const ResStringRec: PResStringRec; const Args: array of const);
  function ReturnAddr: Pointer;
  asm
    mov eax, [ebp + 4]
  end;
begin
  raise EUclError.CreateFmt('Class ' + ClassName + ': ' + LoadResString(ResStringRec), Args)At ReturnAddr;
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF KOL}
class procedure TUclCustomStream.ErrorCheck(const ErrorCode: Integer);
begin
  if ErrorCode <> UCL_E_OK then
    Error(PResStringRec(@SUclError), [ErrorCode]);
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ TUclCompressionStream
{ ---------------------------------------------------------------------------- }

procedure UclCompressionCallback(TextSize: Cardinal; CodeSize: Cardinal; State: Integer; User: Pointer);
begin
  {$IFDEF KOL}
  with PUclCData(PStream(User).Methods.fCustom)^ do
    if Assigned(FOnProgress) then
      FOnProgress(User, FTotalIn + TextSize, FTotalOut + CodeSize);
  {$ELSE}
  with TUclCompressionStream(User) do
    DoProgress(FTotalIn + TextSize, FTotalOut + CodeSize);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF KOL}
constructor TUclCompressionStream.Create(const CompressionLevel: Integer; const BufferSize: Cardinal; const Dest: TStream);
begin
  inherited Create(BufferSize, Dest);
  FBufferFree := BufferSize;
  FBufferStart := FBuffer;
  Inc(FBufferStart, FBufferAlloc - BufferSize);
  FBufferPos := FBufferStart;
  FCompressionLevel := CompressionLevel;
  with FCallback do
    begin
      Callback := UclCompressionCallback;
      User := Self;
    end;
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}
procedure UclCCloseStream(Strm: PStream);
{$ELSE}
destructor TUclCompressionStream.Destroy;
{$ENDIF}
var
  c, l: Cardinal;
begin
  {$IFDEF KOL}
  with PUclCData(Strm^.Methods^.fCustom)^ do
    begin
      {$ENDIF}
      c := FBufferSize - FBufferFree;
      if c > 0 then
        begin
          Inc(FTotalOut, 4);
          { Compress the buffer and write. }
          l := FBufferAlloc;
          {$IFDEF KOL}
          if ucl_nrv2e_99_compress(FBufferStart, c, FBuffer, l, @FCallback, FCompressionLevel, nil, nil) <> UCL_E_OK then
            Exit;
          {$ELSE}
          ErrorCheck(ucl_nrv2e_99_compress(FBufferStart, c, FBuffer, l, @FCallback, FCompressionLevel, nil, nil));
          {$ENDIF}
          FStream.Write(l, SizeOf(l));
          FStream.Write(FBuffer^, l);
        end;
      {$IFDEF KOL}
      FreeMem(FBuffer);
    end;
  FreeMem(Strm^.Methods^.fCustom);
  {$ELSE}
      inherited Destroy;
      {$ENDIF}
    end;

  { ---------------------------------------------------------------------------- }

  {$IFNDEF KOL}
  {$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function TUclCompressionStream.Read(var Buffer; Count: Integer): Integer;
begin
  Error(PResStringRec(@SInvalidUclStreamOperation), []);
end; // Warning can be ignored.
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}
function UclCWriteStream(Strm: PStream; var Buffer; Count: DWORD): DWORD;
{$ELSE}
function TUclCompressionStream.Write(const Buffer; Count: Integer): Integer;
{$ENDIF}
{$IFDEF KOL}
label
  lblError;
  {$ENDIF}
var
  PSource: ^Byte;
  l: Cardinal;
begin
  Result := 0;

  if Count > 0 then
    {$IFDEF KOL}
    with PUclCData(Strm.Methods.fCustom)^ do
      {$ENDIF}
      begin
        PSource := @Buffer;
        repeat
          l := FBufferFree;
          if l > 0 then
            begin
              { If count fits into buffer, copy it and exit. }
              if Cardinal(Count) <= l then
                begin
                  Move(PSource^, FBufferPos^, Count);
                  Inc(Result, Count);
                  Inc(FBufferPos, Count);
                  Dec(FBufferFree, Count);
                  Break;
                end;

              Move(PSource^, FBufferPos^, l);
              Inc(Result, l);
              Inc(PSource, l);
              Dec(Count, l);
              FBufferFree := 0;
            end;

          Inc(FTotalOut, 4);
          { Compress the buffer and write. }
          l := FBufferAlloc;
          {$IFDEF KOL}
          if ucl_nrv2e_99_compress(FBufferStart, FBufferSize, FBuffer, l, @FCallback, FCompressionLevel, nil, nil) <> UCL_E_OK then
            goto lblError;
          {$ELSE}
          ErrorCheck(ucl_nrv2e_99_compress(FBufferStart, FBufferSize, FBuffer, l, @FCallback, FCompressionLevel, nil, nil));
          {$ENDIF}
          FStream.Write(l, SizeOf(l));
          FStream.Write(FBuffer^, l);
          Inc(FTotalIn, FBufferSize);
          Inc(FTotalOut, l);
          FBufferFree := FBufferSize;
          FBufferPos := FBufferStart;
        until Count <= 0;
      end;

  {$IFDEF KOL}
  Exit;
  lblError:
  Result := STREAM_ERROR;
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}
function UclCSeekStream(Strm: PStream; Offset: Integer; Origin: TMoveMethod): DWORD;
{$ELSE}
{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function TUclCompressionStream.Seek(Offset: Integer; Origin: Word): Integer;
{$ENDIF}
label
  OperationError, Rewind;
var
  p: Integer;
begin
  {$IFDEF KOL}
  with PUclCData(Strm.Methods.fCustom)^ do
    {$ENDIF}
    case Origin of
      {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF}:
        if Offset = 0 then
          begin
            Rewind:
            Result := 0;
            FStream.Seek(Result, {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF}); // Rewind destination stream.
            FBufferFree := FBufferSize; // Empty internal buffer.
            FBufferPos := FBufferStart;
            FTotalIn := Result; // Reset statistics
            FTotalOut := Result;
          end
        else
          if Offset = Integer(FTotalIn + FBufferSize - FBufferFree) then
            Result := Offset
          else
            goto OperationError;

      {$IFDEF KOL}spCurrent{$ELSE}soFromCurrent{$ENDIF},
      {$IFDEF KOL}spEnd{$ELSE}soFromEnd{$ENDIF}:
        begin
          p := FTotalIn + FBufferSize - FBufferFree;
          if Offset = 0 then
            Result := p
          else
            if Offset = -p then
              goto Rewind
            else
              goto OperationError;
        end;

    else
      OperationError:
      {$IFDEF KOL}
      Result := STREAM_ERROR;
      {$ELSE}
      Error(PResStringRec(@SInvalidUclStreamOperation), []);
      {$ENDIF}
    end;
end; // Warning can be ignored.
{$IFNDEF KOL}
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}
{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ TUclDecompressionStream
{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}
procedure UclDCloseStream(Strm: PStream);
begin
  FreeMem(PUclCData(Strm^.Methods^.fCustom)^.FBuffer);
  FreeMem(Strm^.Methods^.fCustom);
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}
function UclDReadStream(Strm: PStream; var Buffer; Count: DWORD): DWORD;
{$ELSE}
function TUclDeCompressionStream.Read(var Buffer; Count: Integer): Integer;
{$ENDIF}
label
  StreamError;
var
  PDest, ReadTarget: ^Byte;
  l: Cardinal;
begin
  Result := 0;
  if Count > 0 then
    {$IFDEF KOL}
    with PUclCData(Strm.Methods.fCustom)^ do
      {$ENDIF}
      begin
        PDest := @Buffer;
        repeat
          l := FBufferFree;
          if l > 0 then
            begin
              { If count is decompressed, read and exit. }
              if Cardinal(Count) <= l then
                begin
                  Move(FBufferPos^, PDest^, Count);
                  Inc(Result, Count);
                  Inc(FBufferPos, Count);
                  Dec(FBufferFree, Count);
                  Break;
                end;

              { Read what's available, then refill the buffer and continue. }
              Move(FBufferPos^, PDest^, l);
              Inc(PDest, l);
              Inc(Result, l);
              Dec(Count, l);
              FBufferFree := 0; // For safety.
            end;

          { Fill the buffer. }
          if FStream.Read(l, SizeOf(l)) <> SizeOf(l) then
            Break; // No error - end of stream reached.
          if l > FBufferAlloc then
            goto StreamError;
          ReadTarget := FBuffer;
          Inc(ReadTarget, FBufferAlloc - l);
          if FStream.Read(ReadTarget^, l) <> {$IFNDEF KOL}Integer{$ENDIF}(l) then
            goto StreamError;

          FBufferFree := FBufferAlloc;
          {$IFDEF KOL}
          if ucl_nrv2e_decompress_asm_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil) <> UCL_E_OK then
            goto StreamError;
          {$ELSE}
          ErrorCheck(ucl_nrv2e_decompress_asm_fast_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil));
          {$ENDIF}

          Inc(FTotalIn, l + 4);
          Inc(FTotalOut, FBufferFree);

          {$IFDEF KOL}
          if Assigned(FOnProgress) then
            FOnProgress(Strm, FTotalIn, FTotalOut);
          {$ELSE}
          DoProgress(FTotalIn, FTotalOut);
          {$ENDIF}

          FBufferPos := FBuffer;
        until False;

      end;

  Exit;

  StreamError:
  {$IFDEF KOL}
  Result := STREAM_ERROR;
  {$ELSE}
  Error(PResStringRec(@SInvalidUclStreamData), []);
  {$ENDIF}
end;

{ ---------------------------------------------------------------------------- }

{$IFNDEF KOL}
{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function TUclDeCompressionStream.Write(const Buffer; Count: Integer): Integer;
begin
  Error(PResStringRec(@SInvalidUclStreamOperation), []);
end; // Warning can be ignored.
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}
{$ENDIF}

{ ---------------------------------------------------------------------------- }

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
{$IFDEF KOL}
function UclDSeekStream(Strm: PStream; Offset: Integer; Origin: TMoveMethod): DWORD;
{$ELSE}
function TUclDeCompressionStream.Seek(Offset: Integer; Origin: Word): Integer;
{$ENDIF}
label
  OperationError, StreamError, SeekCurrent, SeekAbsolute, SeekForward;
var
  ReadTarget: ^Byte;
  l, CurrentPos: Cardinal;
  MinPos: Integer;
begin
  {$IFDEF KOL}
  with PUclCData(Strm.Methods.fCustom)^ do
    {$ENDIF}
    case Origin of
      {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF}:
        begin
          CurrentPos := FTotalOut - FBufferFree;
          goto SeekAbsolute;
        end;

      {$IFDEF KOL}spCurrent{$ELSE}soFromCurrent{$ENDIF}:
        begin
          goto SeekCurrent;
        end;

      {$IFDEF KOL}spEnd{$ELSE}soFromEnd{$ENDIF}:
        begin
          // Seek to End - we have to do this anyway to seek backwards from the end.
          repeat
            Inc(FBufferPos, FBufferFree); // Forward, in case we hit end of stream.
            FBufferFree := 0;

            { Fill the buffer. }
            if FStream.Read(l, SizeOf(l)) <> SizeOf(l) then
              Break; // No error - found end of stream!
            if l > FBufferAlloc then
              goto StreamError;
            ReadTarget := FBuffer;
            Inc(ReadTarget, FBufferAlloc - l);
            if FStream.Read(ReadTarget^, l) <> {$IFNDEF KOL}Integer{$ENDIF}(l) then
              goto StreamError;

            FBufferFree := FBufferAlloc;
            {$IFDEF KOL}
            if ucl_nrv2e_decompress_asm_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil) <> UCL_E_OK then
              goto StreamError;
            {$ELSE}
            ErrorCheck(ucl_nrv2e_decompress_asm_fast_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil));
            {$ENDIF}

            Inc(FTotalIn, l + 4);
            Inc(FTotalOut, FBufferFree);

            FBufferPos := FBuffer;
          until False;

          { ---------------------------------------------------------------------------- }
          SeekCurrent:
          { ---------------------------------------------------------------------------- }

          CurrentPos := FTotalOut - FBufferFree;
          Inc(Offset, CurrentPos);

          { ---------------------------------------------------------------------------- }
          SeekAbsolute:
          { ---------------------------------------------------------------------------- }

          if Offset > Integer(FTotalOut) then
            begin // Seek forward
              goto SeekForward;
            end
          else
            begin
              MinPos := CurrentPos - (Cardinal(FBufferPos) - Cardinal(FBuffer));
              if Offset < MinPos then
                begin // Need to seek over from beginning
                  if Offset < 0 then
                    Offset := 0;

                  { Position at beginning. }
                  FTotalIn := 0;
                  FTotalOut := 0;
                  FStream.Seek(0, {$IFDEF KOL}spBegin{$ELSE}soFromBeginning{$ENDIF});

                  { ---------------------------------------------------------------------------- }
                  SeekForward:
                  { ---------------------------------------------------------------------------- }

                  repeat
                    FBufferFree := 0; // For safety.

                    { Fill the buffer. }
                    if FStream.Read(l, SizeOf(l)) <> SizeOf(l) then
                      goto OperationError;
                    if l > FBufferAlloc then
                      goto StreamError;
                    ReadTarget := FBuffer;
                    Inc(ReadTarget, FBufferAlloc - l);
                    if FStream.Read(ReadTarget^, l) <> {$IFNDEF KOL}Integer{$ENDIF}(l) then
                      goto StreamError;

                    FBufferFree := FBufferAlloc;
                    {$IFDEF KOL}
                    if ucl_nrv2e_decompress_asm_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil) <> UCL_E_OK then
                      goto StreamError;
                    {$ELSE}
                    ErrorCheck(ucl_nrv2e_decompress_asm_fast_safe_8(ReadTarget, l, FBuffer, FBufferFree, nil));
                    {$ENDIF}

                    Inc(FTotalIn, l + 4);
                    Inc(FTotalOut, FBufferFree);

                    FBufferPos := FBuffer;

                    if Cardinal(Offset) <= FTotalOut then
                      begin
                        Inc(FBufferPos, FBufferFree - (FTotalOut - Cardinal(Offset)));
                        FBufferFree := FTotalOut - Cardinal(Offset);
                        Break;
                      end;

                  until False;
                end
              else
                begin // Target is located within decompressed buffer.
                  FBufferPos := FBuffer;
                  Inc(FBufferPos, Offset - MinPos);
                  Inc(FBufferFree, CurrentPos - Cardinal(Offset));
                end;
            end;

          Result := Offset;
        end;
    else
      OperationError:
      {$IFDEF KOL}
      StreamError:
      Result := STREAM_ERROR;
      {$ELSE}
      Error(PResStringRec(@SInvalidUclStreamOperation), []);
      {$ENDIF}
    end;

  {$IFDEF KOL}
  {$ELSE}
  Exit; // Warning can be ignored.
  StreamError:
  Error(PResStringRec(@SInvalidUclStreamData), []);
  {$ENDIF}
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ KOL
{ ---------------------------------------------------------------------------- }

{$IFDEF KOL}

function DummyGetSize(Strm: PStream): DWORD;
begin
  Result := 0;
end;

{ ---------------------------------------------------------------------------- }

const
  BaseUclCMethods: TStreamMethods = (
    fSeek: UclCSeekStream;
    fGetSiz: DummyGetSize;
    fSetSiz: DummySetSize;
    fRead: DummyReadWrite;
    fWrite: UclCWriteStream;
    fClose: UclCCloseStream; );

  BaseUclDMethods: TStreamMethods = (
    fSeek: UclDSeekStream;
    fGetSiz: DummyGetSize;
    fSetSiz: DummySetSize;
    fRead: UclDReadStream;
    fWrite: DummyReadWrite;
    fClose: UclDCloseStream;
    );

function NewUclCStream(const CompressionLevel: Integer; const BufferSize: Cardinal; const Destination: PStream; const OnProgress: TUclProgressEvent): PStream;
var
  UclData: PUclCData;
begin
  if ucl_init = UCL_E_OK then
    begin
      UclData := AllocMem(SizeOf(UclData^));
      with UclData^ do
        begin
          FStream := Destination;
          FBufferSize := BufferSize;
          FBufferAlloc := ucl_output_block_size(BufferSize);
          GetMem(FBuffer, FBufferAlloc);

          FBufferFree := BufferSize;
          FBufferStart := FBuffer;
          Inc(FBufferStart, FBufferAlloc - BufferSize);
          FBufferPos := FBufferStart;
          FCompressionLevel := CompressionLevel;
          FOnProgress := OnProgress;

          Result := _NewStream(BaseUclCMethods);

          with FCallback do
            begin
              Callback := UclCompressionCallback;
              User := Result;
            end;
        end;

      Result.Methods.fCustom := UclData;
    end
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }

function NewUclDStream(const BufferSize: Cardinal; const Source: PStream; const OnProgress: TUclProgressEvent): PStream;
var
  UclData: PUclDData;
begin
  if ucl_init = UCL_E_OK then
    begin
      UclData := AllocMem(SizeOf(UclData^));
      with UclData^ do
        begin
          FStream := Source;
          FBufferSize := BufferSize;
          FBufferAlloc := ucl_output_block_size(BufferSize);
          GetMem(FBuffer, FBufferAlloc);
          FOnProgress := OnProgress;
        end;
      Result := _NewStream(BaseUclDMethods);
      Result^.Methods^.fCustom := UclData;
    end
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }

function NewUclCCStream(out Stream: PStream; const CompressionLevel: Integer; BufferSize: Cardinal; const Destination: PStream; OnProgress: TUclProgressEvent): Boolean;
begin
  Stream := NewUclCStream(CompressionLevel, BufferSize, Destination, OnProgress);
  Result := Stream <> nil;
end;

{ ---------------------------------------------------------------------------- }

function NewUclDDStream(out Stream: PStream; const BufferSize: Cardinal; const Source: PStream; const OnProgress: TUclProgressEvent): Boolean;
begin
  Stream := NewUclDStream(BufferSize, Source, OnProgress);
  Result := Stream <> nil;
end;

{$ENDIF KOL}

end.

