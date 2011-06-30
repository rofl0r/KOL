(*
 *  File:     $RCSfile: Header.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: Header.pas,v 1.1.1.1 2002/04/21 12:57:16 fobmagog Exp $
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

unit KolHeader;

interface

uses
  Windows, Kol, KolCRC, KolBitStream, KolBitReserve;

type
  TVersion = (MPEG2_LSF, MPEG1);
  TMode = (Stereo, JointStereo, DualChannel, SingleChannel);
  TSampleFrequency = (FourtyFourPointOne, FourtyEight, ThirtyTwo, Unknown);

const
  FREQUENCIES: array[TVersion, TSampleFrequency] of cardinal = ((22050, 24000, 16000, 1),
    (44100, 48000, 32000, 1));

type
  // Class for extraction information from a frame header:
  PHeader = ^THeader;
  THeader = object(Tobj)
  private
    FLayer: cardinal;
    FProtectionBit: cardinal;
    FBitrateIndex: cardinal;
    FPaddingBit: cardinal;
    FModeExtension: cardinal;
    FVersion: TVersion;
    FMode: TMode;
    FSampleFrequency: TSampleFrequency;
    FNumberOfSubbands: cardinal;
    FIntensityStereoBound: cardinal;
    FCopyright: boolean;
    FOriginal: boolean;
    FInitialSync: boolean;
    FCRC: PCRC16;
    FOffset: PCardinalArray;
    FChecksum: cardinal;
    FFrameSize: cardinal;
    FNumSlots: cardinal;

    function GetFrequency: cardinal;
    function GetChecksums: boolean;
    function GetChecksumOK: boolean;
    function GetPadding: boolean;

  public
    property Version: TVersion read FVersion;
    property Layer: cardinal read FLayer;
    property BitrateIndex: cardinal read FBitrateIndex;
    property SampleFrequency: TSampleFrequency read FSampleFrequency;
    property Frequency: cardinal read GetFrequency;
    property Mode: TMode read FMode;
    property Checksums: boolean read GetChecksums;
    property Copyright: boolean read FCopyright;
    property Original: boolean read FOriginal;
    property ChecksumOK: boolean read GetChecksumOK;
    // compares computed checksum with stream checksum
    property Padding: boolean read GetPadding;
    property Slots: cardinal read FNumSlots;
    property ModeExtension: cardinal read FModeExtension;
    property NumberOfSubbands: cardinal read FNumberOfSubbands;
    // returns the number of subbands in the current frame
    property IntensityStereoBound: cardinal read FIntensityStereoBound;
    // (Layer II joint stereo only)
    // returns the number of subbands which are in stereo mode,
    // subbands above that limit are in intensity stereo mode

    //constructor Create;
    destructor Destroy; virtual;

    function ReadHeader(Stream: PBitStream; var CRC: PCRC16): boolean;
    // read a 32-bit header from the bitstream

    function Bitrate: cardinal;

    function CalculateFrameSize: cardinal;

    // Scrolling stuff
    function StreamSeek(Stream: PBitStream; SeekPos: cardinal): boolean;
    function MaxNumberOfFrames(Stream: PBitStream): integer;
    function MinNumberOfFrames(Stream: PBitStream): integer;

    function MSPerFrame: single;  // milliseconds per frame, for time display
    function TotalMS(Stream: PBitStream): single;
  end;

function Newheader: PHeader;

implementation

{ THeader }

const
  BITRATES: array[TVersion, 0..2, 0..15] of
  cardinal = (((0 {free format}, 32000, 48000, 56000, 64000, 80000, 96000,
    112000, 128000, 144000, 160000, 176000, 192000, 224000, 256000, 0),
    (0 {free format}, 8000, 16000, 24000, 32000, 40000, 48000, 56000, 64000,
    80000, 96000, 112000, 128000, 144000, 160000, 0),
    (0 {free format}, 8000, 16000, 24000, 32000, 40000, 48000, 56000, 64000,
    80000, 96000, 112000, 128000, 144000, 160000, 0)),
    ((0 {free format}, 32000, 64000, 96000, 128000, 160000, 192000, 224000,
    256000, 288000, 320000, 352000, 384000, 416000, 448000, 0),
    (0 {free format}, 32000, 48000, 56000, 64000, 80000, 96000, 112000,
    128000, 160000, 192000, 224000, 256000, 320000, 384000, 0),
    (0 {free format}, 32000, 40000, 48000, 56000, 64000, 80000, 96000,
    112000, 128000, 160000, 192000, 224000, 256000, 320000, 0))
    );

function THeader.Bitrate: cardinal;
begin
  Result := BITRATES[FVersion, FLayer - 1, FBitrateIndex];
end;

// calculates framesize in bytes excluding header size
function THeader.CalculateFrameSize: cardinal;
var 
  Val1, Val2: cardinal;
begin
  if (FLayer = 1) then 
  begin
    FFramesize := (12 * BITRATES[FVersion, 0, FBitrateIndex]) div FREQUENCIES[FVersion,
      FSampleFrequency];

    if (FPaddingBit <> 0) then
      inc(FFrameSize);

    FFrameSize := FFrameSize shl 2;  // one slot is 4 bytes long

    FNumSlots := 0;
  end 
  else 
  begin
    FFrameSize := (144 * BITRATES[FVersion, FLayer - 1, FBitrateIndex]) div
      FREQUENCIES[FVersion, FSampleFrequency];

    if (FVersion = MPEG2_LSF) then
      FFrameSize := FFrameSize shr 1;

    if (FPaddingBit <> 0) then
      inc(FFrameSize);

    // Layer III slots
    if (FLayer = 3) then 
    begin
      if (FVersion = MPEG1) then 
      begin
        if (FMode = SingleChannel) then
          Val1 := 17
        else
          Val1 := 32;

        if (FProtectionBit <> 0) then
          Val2 := 0
        else
          Val2 := 2;

        FNumSlots := FFramesize - Val1 - Val2 - 4;
        // header size
      end 
      else 
      begin  // MPEG-2 LSF
        if (FMode = SingleChannel) then
          Val1 := 9
        else
          Val1 := 17;

        if (FProtectionBit <> 0) then
          Val2 := 0
        else
          Val2 := 2;

        FNumSlots := FFramesize - Val1 - Val2 - 4;
        // header size
      end;
    end 
    else
      FNumSlots := 0;
  end;

  dec(FFrameSize, 4);  // subtract header size

  Result := FFrameSize;
end;

function newHeader: pHeader;
begin
  New(Result, Create);
  with Result^ do
  begin
    FFrameSize := 0;
    FNumSlots := 0;
    FCRC := nil;
    FOffset := nil;
    FInitialSync := False;
  end;
end;

destructor THeader.Destroy;
begin
  if (FOffset <> nil) then
    FreeMem(FOffset);

  inherited;
end;

function THeader.GetChecksumOK: boolean;
begin
  Result := (FChecksum = FCRC.Checksum);
end;

function THeader.GetChecksums: boolean;
begin
  Result := (FProtectionBit = 0);
end;

function THeader.GetFrequency: cardinal;
begin
  Result := FREQUENCIES[FVersion, FSampleFrequency];
end;

function THeader.GetPadding: boolean;
begin
  Result := (FPaddingBit <> 0);
end;

// Returns the maximum number of frames in the stream
function THeader.MaxNumberOfFrames(Stream: PBitStream): integer;
begin
  Result := Stream.FileSize div (FFrameSize + 4 - FPaddingBit);
end;

// Returns the minimum number of frames in the stream
function THeader.MinNumberOfFrames(Stream: PBitStream): integer;
begin
  Result := Stream.FileSize div (FFrameSize + 5 - FPaddingBit);
end;

const
  MSPerFrameArray: array[0..2, TSampleFrequency] of single = ((8.707483,  8.0, 12.0, 0),
    (26.12245, 24.0, 36.0, 0),
    (26.12245, 24.0, 36.0, 0));

function THeader.MSPerFrame: single;
begin
  Result := MSperFrameArray[FLayer - 1, FSampleFrequency];
end;

function THeader.ReadHeader(Stream: PBitStream; var CRC: PCRC16): boolean;
var 
  HeaderString, ChannelBitrate: cardinal;
  max, cf, lf, i: integer;
begin
  Result := False;
  if (not FInitialSync) then 
  begin
    if (not Stream.GetHeader(@HeaderString, INITIAL_SYNC)) then
      exit;

    FVersion := TVersion((HeaderString shr 19) and 1);
    FSampleFrequency := TSampleFrequency((HeaderString shr 10) and 3);
    if (FSampleFrequency = Unknown) then 
    begin
      // report error - not supported header
      exit;
    end;

    Stream.SetSyncWord(HeaderString and $FFF80CC0);

    FInitialSync := True;
  end 
  else 
  begin
    if (not Stream.GetHeader(@HeaderString, STRICT_SYNC)) then 
    begin
      exit;
    end;
  end;

  FLayer := 4 - (HeaderString shr 17) and 3;
  FProtectionBit := (HeaderString shr 16) and 1;
  FBitrateIndex := (HeaderString shr 12) and $F;
  FPaddingBit := (HeaderString shr 9) and 1;
  FMode := TMode((HeaderString shr 6) and 3);
  FModeExtension := (HeaderString shr 4) and 3;

  if (FMode = JointStereo) then
    FIntensityStereoBound := (FModeExtension shl 2) + 4
  else
    FIntensityStereoBound := 0;  // should never be used

  FCopyright := ((HeaderString shr 3) and 1 <> 0);
  FOriginal := ((HeaderString shr 2) and 1 <> 0);

  // calculate number of subbands:
  if (FLayer = 1) then
    FNumberOfSubbands := 32
  else 
  begin
    ChannelBitrate := FBitrateIndex;

    // calculate bitrate per channel:
    if (FMode <> SingleChannel) then
      if (ChannelBitrate = 4) then
        ChannelBitrate := 1
      else
        dec(ChannelBitrate, 4);

    if ((ChannelBitrate = 1) or (ChannelBitrate = 2)) then 
    begin
      if (FSampleFrequency = ThirtyTwo) then
        FNumberOfSubbands := 12
      else
        FNumberOfSubbands := 8;
    end 
    else 
    begin
      if ((FSampleFrequency = FourtyEight) or ((ChannelBitrate >= 3) and
        (ChannelBitrate <= 5))) then
        FNumberOfSubbands := 27
      else
        FNumberOfSubbands := 30;
    end;
  end;

  if (FIntensityStereoBound > FNumberOfSubbands) then
    FIntensityStereoBound := FNumberOfSubbands;

  // calculate framesize and nSlots
  CalculateFrameSize;

  // read framedata:
  if (not Stream.ReadFrame(FFrameSize)) then 
  begin
    exit;
  end;

  if (FProtectionBit = 0) then 
  begin
    // frame contains a crc checksum
    FChecksum := Stream.GetBits(16);
    if (FCRC = nil) then
      FCRC := NewCRC16;

    FCRC.AddBits(HeaderString, 16);
    CRC := FCRC;
  end 
  else
    CRC := nil;

  {$IFDEF SEEK_STOP}
  if (FSampleFrequency = FourtyFourPointOne) then 
  begin
    if (FOffset = nil) then 
    begin
      max := MaxNumberOfFrames(Stream);
      FOffset := AllocMem(Max * sizeof(cardinal));

      for i := 0 to max - 1 do
        FOffset[i] := 0;
    end;

    cf := Stream.CurrentFrame;
    lf := Stream.LastFrame;
    if ((cf > 0) and (cf = lf)) then
      FOffset[cf] := FOffset[cf - 1] + FPaddingBit
    else
      FOffset[0] := FPaddingBit;
  end;
  {$ENDIF}

  Result := True;
end;

// Stream searching routines
function THeader.StreamSeek(Stream: PBitStream;
  SeekPos: cardinal): boolean;
begin
  if (FSampleFrequency = FourtyFourPointOne) then
    Result := Stream.SeekPad(SeekPos, FFrameSize - FPaddingBit, PObj(@Self), FOffset)
  else
    Result := Stream.Seek(SeekPos, FFrameSize);
end;

function THeader.TotalMS(Stream: PBitStream): single;
begin
  Result := MaxNumberOfFrames(Stream) * MSPerFrame;
end;

end.
