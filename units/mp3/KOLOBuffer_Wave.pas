(*
 *  File:     $RCSfile: OBuffer_Wave.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: OBuffer_Wave.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
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
unit KOLOBuffer_Wave;

interface

uses
  Windows, MMSystem, kol, KolShared, kolplayer, kolobuffer, err;

type
  POBuffer_wave = ^TOBuffer_wave;
  TOBuffer_Wave = object(TObuffer)
  private
    FBufferP: array[0..MAX_CHANNELS - 1] of cardinal;
    FChannels: cardinal;
    FDataSize: cardinal;

    FTemp: PByteArray;

    hmmioOut: HMMIO;
    mmioinfoOut: MMIOINFO;
    ckOutRIFF: MMCKINFO;
    ckOut: MMCKINFO;

  public
    //  constructor Create(NumberOfChannels: Cardinal; Player: PObj; Filename: String);
    destructor Destroy; virtual;

    procedure Append(Channel: cardinal; Value: smallint); virtual;
    procedure WriteBuffer; virtual;

    {$IFDEF SEEK_STOP}
    procedure ClearBuffer; virtual;
    procedure SetStopFlag; virtual;
    {$ENDIF}
  end;
function NewObuffer_wave(NumberOfChannels: cardinal; Player: PPlayer;
  Filename: string): POBuffer_wave;
function CreateWaveFileOBffer(Player: PPlayer; Filename: string): POBuffer_wave;

implementation

uses
  KolMath, KolHeader;

function CreateWaveFileOBffer(Player: PPlayer; Filename: string): POBuffer_wave;
var 
  Mode: TMode;
  WhichChannels: TChannels;
begin
  Mode := Player.Mode;
  WhichChannels := Player.Channels;
  try
    if ((Mode = SingleChannel) or (WhichChannels <> both)) then
      Result := NewObuffer_wave(1, Player, Filename)   // mono
    else
      Result := NewObuffer_wave(2, Player, Filename);  // stereo
  except
    on E: Exception do
      Result := nil;
  end;
end;

{ TOBuffer_Wave }

// Need to break up the 32-bit integer into 2 8-bit bytes.
// (ignore the first two bytes - either 0x0000 or 0xffff)
// Note that Intel byte order is backwards!!!
procedure TOBuffer_Wave.Append(Channel: cardinal; Value: smallint);
begin
  FTemp[FBufferP[Channel]] := (Value and $ff);
  FTemp[FBufferP[Channel] + 1] := (Value shr 8);

  inc(FBufferP[Channel], FChannels shl 1);
end;

procedure TOBuffer_Wave.ClearBuffer;
begin
  // Since we write each frame, and seeks and stops occur between
  // frames, nothing is needed here.
end;

//constructor TOBuffer_Wave.Create
function newobuffer_wave(NumberOfChannels: cardinal; Player: PPlayer;
  Filename: string): PObuffer_wave;
var 
  pwf: TWAVEFORMATEX;
  i: cardinal;
begin
  New(Result, Create);
  with Result^ do
  begin
    FChannels := NumberOfChannels;

    FDataSize := FChannels * OBUFFERSIZE;

    if (Player.Version = MPEG2_LSF) then
      FDataSize := FDataSize shr 1;

    if (Player.Layer = 1) then
      FDataSize := FDataSize div 3;

    FTemp := AllocMem(FDataSize);

    hmmioOut := mmioOpen(PChar(FileName), nil, MMIO_ALLOCBUF or MMIO_WRITE or MMIO_CREATE);
    if (hmmioOut = 0) then
      raise Exception.Create(e_Custom, 'Output device failure');

    // Create the output file RIFF chunk of form type WAVE.
    ckOutRIFF.fccType := Ord('W') or (Ord('A') shl 8) or (Ord('V') shl 16) or
      (Ord('E') shl 24);
    ckOutRIFF.cksize := 0;
    if (mmioCreateChunk(hmmioOut, @ckOutRIFF, MMIO_CREATERIFF) <> MMSYSERR_NOERROR) then
      raise Exception.Create(e_Custom, 'Output device failure');

    // Initialize the WAVEFORMATEX structure

    pwf.wBitsPerSample := 16;  // No 8-bit support yet
    pwf.wFormatTag := WAVE_FORMAT_PCM;
    pwf.nChannels := FChannels;
    pwf.nSamplesPerSec := Player.Frequency;
    pwf.nAvgBytesPerSec := (FChannels * Player.Frequency shl 1);
    pwf.nBlockAlign := (FChannels shl 1);
    pwf.cbSize := 0;

    // Create the fmt chunk
    ckOut.ckid := Ord('f') or (Ord('m') shl 8) or (Ord('t') shl 16) or (Ord(' ') shl 24);
    ckOut.cksize := sizeof(pwf);

    if (mmioCreateChunk(hmmioOut, @ckOut, 0) <> MMSYSERR_NOERROR) then
      raise Exception.Create(e_Custom, 'Output device failure');

    // Write the WAVEFORMATEX structure to the fmt chunk.

    if (mmioWrite(hmmioOut, @pwf, sizeof(pwf)) <> sizeof(pwf)) then
      raise Exception.Create(e_Custom, 'Output device failure');

    // Ascend out of the fmt chunk, back into the RIFF chunk.
    if (mmioAscend(hmmioOut, @ckOut, 0) <> MMSYSERR_NOERROR) then
      raise Exception.Create(e_Custom, 'Output device failure');

    // Create the data chunk that holds the waveform samples.
    ckOut.ckid := Ord('d') or (Ord('a') shl 8) or (Ord('t') shl 16) or (Ord('a') shl 24);
    ckOut.cksize := 0;
    if (mmioCreateChunk(hmmioOut, @ckOut, 0) <> MMSYSERR_NOERROR) then
      raise Exception.Create(e_Custom, 'Output device failure');

    mmioGetInfo(hmmioOut, @mmioinfoOut, 0);

    for i := 0 to FChannels - 1 do
      FBufferP[i] := i * FChannels;
  end;
end;

destructor TOBuffer_Wave.Destroy;
begin
  // Mark the current chunk as dirty and flush it
  mmioinfoOut.dwFlags := mmioinfoOut.dwFlags or MMIO_DIRTY;
  if (mmioSetInfo(hmmioOut, @mmioinfoOut, 0) <> MMSYSERR_NOERROR) then
    raise Exception.Create(e_Custom, 'Output device failure');

  // Ascend out of data chunk
  if (mmioAscend(hmmioOut, @ckOut, 0) <> MMSYSERR_NOERROR) then
    raise Exception.Create(e_Custom, 'Output device failure');

  // Ascend out of RIFF chunk
  if (mmioAscend(hmmioOut, @ckOutRIFF, 0) <> MMSYSERR_NOERROR) then
    raise Exception.Create(e_Custom, 'Output device failure');

  // Close the file
  if (mmioClose(hmmioOut, 0) <> MMSYSERR_NOERROR) then
    raise Exception.Create(e_Custom, 'Output device failure');

  // Free the buffer memory
  try
    FreeMem(FTemp);
  except
    on E: Exception do;
  end;
end;

procedure TOBuffer_Wave.SetStopFlag;
begin
end;

function Min(A, B: cardinal): integer; overload;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

procedure TOBuffer_Wave.WriteBuffer;
var 
  Write, i: cardinal;
begin
  Write := Min(FDataSize, cardinal(mmioinfoOut.pchEndWrite) - cardinal(mmioinfoOut.pchNext));

  Move(FTemp^, mmioinfoOut.pchNext^, Write);
  inc(cardinal(mmioinfoOut.pchNext), Write);

  if (Write < FDataSize) then 
  begin
    mmioinfoOut.dwFlags := mmioinfoOut.dwFlags or MMIO_DIRTY;

    if (mmioAdvance(hmmioOut, @mmioinfoOut, MMIO_WRITE) <> MMSYSERR_NOERROR) then
      raise Exception.Create(e_Custom, 'Output device failure');
  end;

  Move(FTemp[Write], mmioinfoOut.pchNext^, FDataSize - Write);
  inc(cardinal(mmioinfoOut.pchNext), FDataSize - Write);

  // Reset buffer pointers
  for i := 0 to FChannels - 1 do
    FBufferP[i] := i * FChannels;
end;

end.
