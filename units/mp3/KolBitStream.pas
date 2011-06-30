(*
 *  File:     $RCSfile: BitStream.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: BitStream.pas,v 1.1.1.1 2002/04/21 12:57:16 fobmagog Exp $
 *  Author:   $Author: fobmagog $
 *  Homepage: http://delphimpeg.sourceforge.net/
 *            Kol translation by Thaddy de Koning
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *)
{$DEFINE SEEK_STOP}
{$DEFINE DAMN_INTEL_BYTE_ORDER}
unit KolBitStream;

interface

uses
  Windows, Kol, kolBitReserve, kolshared;

type
  TSyncMode = (INITIAL_SYNC, STRICT_SYNC);

const
  BUFFERINTSIZE = 433;
  // max. 1730 bytes per frame: 144 * 384kbit/s / 32000 Hz + 2 Bytes CRC

type
  PCardinal = ^cardinal;
  // Class to extract bitstrings from files:
  PBitstream = ^TBitstream;
  TBitStream = object(Tobj)
  private
    FStream: PStream;

    FBuffer: array[0..BUFFERINTSIZE - 1] of cardinal;
    FFrameSize: cardinal;     // number of valid bytes in buffer
    FWordPointer: PCardinal;  // position of next unsigned int for get_bits()
    FBitIndex: cardinal;
    // number (0-31, from MSB to LSB) of next bit for get_bits()
    FSyncWord: cardinal;
    FSingleChMode: boolean;
    FCurrentFrameNumber: integer;
    FLastFrameNumber: integer;

  public
    NonSeekable: boolean;
    StreamHandle: Pointer;
    PlayerObj: Pointer;

    property CurrentFrame: integer read FCurrentFrameNumber;
    property LastFrame: integer read FLastFrameNumber;

    //constructor Create(FileName: PChar);
    destructor Destroy; virtual;

    function Restart: boolean;
    function GetHeader(HeaderString: PCardinal; SyncMode: TSyncMode): boolean;
    // get next 32 bits from bitstream in an unsigned int,
    // returned value False => end of stream
    function ReadFrame(ByteSize: cardinal): Bool;
    // fill buffer with data from bitstream, returned value False => end of stream
    function GetBits(NumberOfBits: cardinal): cardinal;
    // read bits (1 <= number_of_bits <= 16) from buffer into the lower bits
    // of an unsigned int. The LSB contains the latest read bit of the stream.
    function GetBitsFloat(NumberOfBits: cardinal): single;
    // read bits (1 <= number_of_bits <= 16) from buffer into the lower bits
    // of a floating point. The LSB contains the latest read bit of the stream.
    procedure SetSyncWord(SyncWord: cardinal);
    // Set the word we want to sync the header to, in
    // Big-Endian byte order
    function FileSize: cardinal;
    // Returns the size, in bytes, of the input file.

    // Stream searching routines (Jeff Tsay)
    function Seek(Frame: integer; FrameSize: integer): boolean;
    // Seeks to frames
    function SeekPad(Frame: integer; FrameSize: integer; Header: PObj;
      Offset: PCardinalArray): boolean;
    // Seeks frames for 44.1 or 22.05 kHz (padded) files
  end;

function newbitstream(const aFilename: PChar): PBitstream;

implementation

uses
  KolCRC, KolHeader;

function SwapInt32(Value: cardinal): cardinal;
begin
  Result := (Value shl 24) or ((Value shl 8) and $00ff0000) or
    ((Value shr 8) and $0000ff00) or (Value shr 24);
end;

{ TBitStream }

//constructor TBitStream.Create(FileName: PChar);
function Newbitstream(const aFilename: PChar): PBitstream;
begin
  New(Result, Create);
  with Result^ do
  begin
    FStream := newreadfilestream(aFileName);

    Restart;
    NonSeekable := False;
  end;
end;

destructor TBitStream.Destroy;
begin
  Free_And_Nil(FStream);
  
  inherited Destroy;
end;

function TBitStream.FileSize: cardinal;
begin
  Result := FStream.Size;
end;

const
  BitMask: array[0..17] of cardinal = (0,  // dummy
    $00000001, $00000003, $00000007, $0000000F,
    $0000001F, $0000003F, $0000007F, $000000FF,
    $000001FF, $000003FF, $000007FF, $00000FFF,
    $00001FFF, $00003FFF, $00007FFF, $0000FFFF,
    $0001FFFF);

function TBitStream.GetBits(NumberOfBits: cardinal): cardinal;
var 
  ReturnValue: cardinal;
  Sum: cardinal;
begin
  Sum := FBitIndex + NumberOfBits;

  if (sum <= 32) then 
  begin
    // all bits contained in *wordpointer
    Result := (FWordPointer^ shr (32 - sum)) and BitMask[NumberOfBits];
    inc(FBitIndex, NumberOfBits);
    if (FBitIndex = 32) then 
    begin
      FBitIndex := 0;
      inc(FWordPointer);
    end;

    exit;
  end;

  {$IFDEF DAMN_INTEL_BYTE_ORDER}
  PWord(@PByteArray(@ReturnValue)[2])^ := PWord(FWordPointer)^;
  inc(FWordPointer);
  PWord(@ReturnValue)^ := PWord(@PByteArray(FWordPointer)[2])^;
  {$ELSE}
  PWord(@ReturnValue)^ := PWord(@PByteArray(FWordPointer)[2])^;
  inc(FWordPointer);
  PWord(@PByteArray(@ReturnValue)[2])^ := PWord(FWordPointer)^;
  {$ENDIF}

  ReturnValue := ReturnValue shr (48 - Sum);
  // returnvalue >>= 16 - (number_of_bits - (32 - bitindex))
  Result := ReturnValue and BitMask[NumberOfBits];
  FBitIndex := Sum - 32;
end;

function TBitStream.GetBitsFloat(NumberOfBits: cardinal): single;
begin
  PCardinal(@Result)^ := GetBits(NumberOfBits);
end;

function TBitStream.GetHeader(HeaderString: PCardinal;
  SyncMode: TSyncMode): boolean;
var 
  Sync: boolean;
  NumRead: integer;
begin
  repeat
    // Read 4 bytes from the file, placing the number of bytes actually
    // read in numread
    NumRead := FStream.Read(HeaderString^, 4);
    Result := (NumRead = 4);
    if (not Result) then
      exit;

    if (SyncMode = INITIAL_SYNC) then
      Sync := ((HeaderString^ and $0000F0FF) = $0000F0FF)
    else
      Sync := ((HeaderString^ and $000CF8FF) = FSyncWord) and
        (((HeaderString^ and $C0000000) = $C0000000) = FSingleChMode);

    //  if ((HeaderString^ and $0000FFFF) = $0000FFFF) then
    //    Sync := false;

    if (not Sync) then
      // rewind 3 bytes in the file so we can try to sync again, if
      // successful set result to TRUE
      FStream.Seek(-3, spCurrent);
  until (Sync) or (not Result);

  if (not Result) then
    exit;

  {$IFDEF DAMN_INTEL_BYTE_ORDER}
  HeaderString^ := SwapInt32(HeaderString^);
  {$ENDIF}

  inc(FCurrentFrameNumber);

  {$IFDEF SEEK_STOP}
  if (FLastFrameNumber < FCurrentFrameNumber) then
    FLastFrameNumber := FCurrentFrameNumber;
  {$ENDIF}

  Result := True;
end;

function TBitStream.ReadFrame(ByteSize: cardinal): Bool;
var 
  NumRead: integer;
  {$IFDEF DAMN_INTEL_BYTE_ORDER}
  WordP: PCardinal;
  {$ENDIF}    
begin
  // read bytesize bytes from the file, placing the number of bytes
  // actually read in numread and setting result to TRUE if
  // successful
  NumRead := FStream.Read(FBuffer, ByteSize);

  FWordPointer := @FBuffer;
  FBitIndex := 0;
  FFrameSize := ByteSize;

  {$IFDEF DAMN_INTEL_BYTE_ORDER}
  WordP := @FBuffer[(ByteSize - 1) shr 2];
  while (cardinal(WordP) >= cardinal(@FBuffer)) do 
  begin
    WordP^ := SwapInt32(WordP^);
    dec(WordP);
  end;
  {$ENDIF}

  Result := cardinal(NumRead) = FFrameSize;
end;

function TBitStream.Restart: boolean;
begin
  FStream.Seek(0, spBegin);
  FWordPointer := @FBuffer;
  FBitIndex := 0;

  // Seeking variables
  FCurrentFrameNumber := -1;
  FLastFrameNumber := -1;
  Result := True;
end;

function TBitStream.Seek(Frame, FrameSize: integer): boolean;
begin
  FCurrentFrameNumber := Frame - 1;
  if (NonSeekable) then 
  begin
    Result := False;
    exit;
  end;

  FStream.Seek(Frame * (FrameSize + 4), spBegin);
  Result := True;
end;

function TBitStream.SeekPad(Frame, FrameSize: integer;
  Header: PObj; Offset: PCardinalArray): boolean;
var 
  CRC: PCRC16;
  TotalFrameSize: integer;
  Diff: integer;
begin
  // base_frame_size is the frame size _without_ padding.
  if (NonSeekable) then 
  begin
    Result := False;
    exit;
  end;

  CRC := nil;

  TotalFrameSize := FrameSize + 4;

  if (FLastFrameNumber < Frame) then 
  begin
    if (FLastFrameNumber >= 0) then
      Diff := Offset[FLastFrameNumber]
    else
      Diff := 0;

    // set the file pointer to ((last_frame_number+1) * total_frame_size)
    // bytes after the beginning of the file
    FStream.Seek((FLastFrameNumber + 1) * TotalFrameSize + Diff, spBegin);
    FCurrentFrameNumber := FLastFrameNumber;

    repeat
      if (not PHeader(Header).ReadHeader(@Self, CRC)) then 
      begin
        Result := False;
        exit;
      end;
    until (FLastFrameNumber >= Frame);

    Result := True;
  end 
  else 
  begin
    if (Frame > 0) then
      Diff := Offset[Frame - 1]
    else
      Diff := 0;

    // set the file pointer to (frame * total_frame_size  + diff) bytes
    // after the beginning of the file
    FStream.Seek(Frame * TotalFrameSize + Diff, spbegin);
    FCurrentFrameNumber := Frame - 1;
    Result := PHeader(Header).ReadHeader(@Self, CRC);
  end;
  
  if (CRC <> nil) then
    Free_And_Nil(CRC);
end;

procedure TBitStream.SetSyncWord(SyncWord: cardinal);
begin
  {$IFDEF DAMN_INTEL_BYTE_ORDER}
  FSyncWord := SwapInt32(Syncword and $FFFFFF3F);
  {$ELSE}
  FSyncWord := SyncWord and $FFFFFF3F;
  {$ENDIF}

  FSingleChMode := ((SyncWord and $000000C0) = $000000C0);
end;

end.

