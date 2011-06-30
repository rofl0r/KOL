(*
 *  File:     $RCSfile: OBuffer_MCI.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: OBuffer_MCI.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
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
unit KolOBuffer_MCI;

interface

uses
  Windows, kol, err, MMSystem, KolShared;

const
  TWO_TIMES = 5;
  BUFFERSIZE = OBUFFERSIZE shl TWO_TIMES;
  BIT_SELECT = $1f;
  SLEEPTIME = 20;

type
  PointerArray=array[0..65535] of pointer;
  PPointerArray=^ Pointerarray;

  POBuffer_MCI = ^TOBuffer_mci;
  TOBuffer_MCI = object(TObj)
  private
    FBuffer: array[0..MAX_CHANNELS - 1] of cardinal;
    FChannels: cardinal;
    FWF: PWaveFormatEx;
    FWaveHdrArr: PWaveHdr;
    FHWO: HWAVEOUT;
    FBufferCount: cardinal;
    FHdrSize: cardinal;
    FFillup: cardinal;
    FDataSize: cardinal;
    FUserStop: cardinal;

    procedure WaveSwap;

  public
    //constructor Create(NumberOfChannels: Cardinal; Player: PPlayer);
    destructor Destroy; virtual;

    procedure Append(Channel: cardinal; Value: smallint); virtual;
    procedure WriteBuffer; virtual;
    procedure ClearBuffer; virtual;
    procedure SetStopFlag; virtual;
  end;
function NewObuffer_mci(NumberOfChannels: cardinal; Player: PObj): PObuffer_mci;

function CreateMCIOBffer(Player: PObj): POBuffer_mci;

implementation

uses
  KolHeader, kolmpegplayer;

function CreateMCIOBffer(Player: PObj): POBuffer_mci;
var 
  Mode: TMode;
  WhichChannels: TChannels;
begin
  Mode := PMpegPlayer(Player).Mode;
  WhichChannels := PMpegPlayer(Player).Channels;
  try
    if ((Mode = SingleChannel) or (WhichChannels <> Both)) then
      Result := NewOBuffer_MCI(1, Player)   // mono
    else
      Result := NewOBuffer_MCI(2, Player);  // stereo
  except
    on E: Exception do
      Result := nil;
  end;
end;

{ TOBuffer_MCI }

// Need to break up the 32-bit integer into 2 8-bit bytes.
// (ignore the first two bytes - either 0x0000 or 0xffff)
// Note that Intel byte order is backwards!!!
procedure TOBuffer_MCI.Append(Channel: cardinal; Value: smallint);
var 
  Temp: PChar;
begin
  temp := PWAVEHDR(PPointerArray(FWaveHdrArr)[2]).lpData;

  temp[FBuffer[channel]] := chr(Value and $ff);
  temp[FBuffer[channel] + 1] := chr(Value shr 8);

  FBuffer[channel] := FBuffer[channel] + (FChannels shl 1);
end;

// Clear all the data in the buffers
procedure TOBuffer_MCI.ClearBuffer;
var 
  i, j: cardinal;
  temp: PWaveHdr;
begin
  waveOutReset(FHWO);

  for i := 0 to 2 do 
  begin
    temp := PPointerArray(FWaveHdrArr)[i];

    if (temp.dwUser <> 0) then
      waveOutUnprepareHeader(FHWO, temp, FHdrSize);

    temp.dwUser := 0;

    for j := 0 to FDataSize - 1 do
      temp.lpData[j] := #0;
  end;

  // Reset buffer pointers
  for i := 0 to FChannels - 1 do
    FBuffer[i] := i * FChannels;

  // Force the buffers to fillup before playing.
  FFillup := 0;
  FBufferCount := 0;
end;

function NewOBuffer_MCI(NumberOfChannels: cardinal;
  Player: PObj): Pobuffer_mci;
var 
  i: cardinal;
  temp: PWaveHdr;
begin
  New(Result, Create);
  with Result^ do
  begin
    FChannels := NumberOfChannels;
    FDataSize := FChannels * BUFFERSIZE;

    if (PMpegPlayer(Player).Version = MPEG2_LSF) then
      FDataSize := FDataSize shr 1;

    if (PMpegPlayer(Player).Layer = 1) then
      FDataSize := FDataSize div 3;

    FHdrSize := sizeof(TWAVEHDR);
    FFillup := 0;

    FWF := AllocMem(Sizeof(TWAVEFORMATEX));

    FWF.wBitsPerSample := 16;  // No 8-bit support yet
    FWF.wFormatTag := WAVE_FORMAT_PCM;
    FWF.nChannels := FChannels;
    FWF.nSamplesPerSec := PmpegPlayer(Player).Frequency;
    FWF.nAvgBytesPerSec := FChannels * pmpegplayer(Player).Frequency shl 1;
    FWF.nBlockAlign := (FChannels shl 1);
    FWF.cbSize := 0;

    if (waveOutOpen(@FHWO, WAVE_MAPPER, FWF, 0, 0, WAVE_ALLOWSYNC) <> MMSYSERR_NOERROR) then 
    begin
      FreeMem(FWF);
      raise Exception.Create(e_Custom, 'Output device failure');
    end;

    FBufferCount := 0;

    FWaveHdrArr := AllocMem(3 * sizeof(PWAVEHDR));
    for i := 0 to 2 do 
    begin
      PPointerArray(FWaveHdrArr)[i] := AllocMem(Sizeof(WAVEHDR));
      temp := PPointerArray(FWaveHdrArr)[i];

      if (temp = nil) then
        exit;

      temp.lpData := AllocMem(FDataSize);

      if (temp.lpData = nil) then
        exit;

      temp.dwBufferLength := FDataSize;
      temp.dwBytesRecorded := 0;
      temp.dwUser := 0;  // If played, dwUser = 1
      temp.dwLoops := 0;
      temp.dwFlags := 0;
    end;

    for i := 0 to FChannels - 1 do
      FBuffer[i] := i * FChannels;

    FUserStop := 0;
  end;
end;

destructor TOBuffer_MCI.Destroy;
var 
  i, j: integer;
begin
  if (FUserStop <> 0) then
    waveOutReset(FHWO)
  else 
  begin
    if (FWaveHdrArr <> nil) then 
    begin
      if (FFillup = 1) then 
      begin
        // Write the last header calculated (at the top of the array).
        waveOutPrepareHeader(FHWO, PPointerArray(FWaveHdrArr)[0], FHdrSize);
        waveOutWrite(FHWO, PPointerArray(FWaveHdrArr)[0], FHdrSize);

        // Header has been written.
        PWaveHdr(PPointerArray(FWaveHdrArr)[0]).dwUser := 1;
      end;

      if (FBufferCount <> 0) then 
      begin
        // Write the last wave header (probably not be written due to buffer
        // size increase.)

        for i := FBuffer[FChannels - 1] to FDataSize - 1 do
          PWaveHdr(PPointerArray(FWaveHdrArr)[2]).lpData[i] := #0;

        waveOutPrepareHeader(FHWO, PPointerArray(FWaveHdrArr)[2], FHdrSize);
        waveOutWrite(FHWO, PPointerArray(FWaveHdrArr)[2], FHdrSize);

        // Header has been written.
        PWaveHdr(PPointerArray(FWaveHdrArr)[2]).dwUser := 1;
        WaveSwap;
      end;
    end;
  end;

  // Unprepare and free the header memory.
  if (FWaveHdrArr <> nil) then 
  begin
    for j := 2 downto 0 do 
    begin
      if (PWaveHdr(PPointerArray(FWaveHdrArr)[j]).dwUser <> 0) and (FUserStop = 0) then
        while (waveOutUnprepareHeader(FHWO, PPointerArray(FWaveHdrArr)[j],
          FHdrSize) = WAVERR_STILLPLAYING) do
          sleep(SLEEPTIME);

      FreeMem(PWaveHdr(PPointerArray(FWaveHdrArr)[j]).lpData);
      FreeMem(PPointerArray(FWaveHdrArr)[j]);
    end;
    FreeMem(FWaveHdrArr);
  end;

  if (FWF <> nil) then
    FreeMem(FWF);

  while (waveOutClose(FHWO) = WAVERR_STILLPLAYING) do;
  sleep(SLEEPTIME);
end;

// Set the flag to avoid unpreparing non-existent headers
procedure TOBuffer_MCI.SetStopFlag;
begin
  FUserStop := 1;
end;

procedure TOBuffer_MCI.WaveSwap;
var 
  temp: Pointer;
begin
  temp := PPointerArray(FWaveHdrArr)[2];
  PPointerArray(FWaveHdrArr)[2] := PPointerArray(FWaveHdrArr)[1];
  PPointerArray(FWaveHdrArr)[1] := PPointerArray(FWaveHdrArr)[0];
  PPointerArray(FWaveHdrArr)[0] := temp;
end;

// Actually write only when buffer is actually full.
procedure TOBuffer_MCI.WriteBuffer;
var 
  i: cardinal;
begin
  inc(FBufferCount);
  if (FBufferCount and BIT_SELECT = 0) then 
  begin
    FBufferCount := 0;

    // Wait for 2 completed headers
    if (FFillup > 1) then 
    begin
      // Prepare & write newest header
      waveOutPrepareHeader(FHWO, PPointerArray(FWaveHdrArr)[2], FHdrSize);
      waveOutWrite(FHWO, PPointerArray(FWaveHdrArr)[2], FHdrSize);

      // Header has now been sent
      PWaveHdr(PPointerArray(FWaveHdrArr)[2]).dwUser := 1;

      WaveSwap;

      // Unprepare oldest header
      if (PWaveHdr(PPointerArray(FWaveHdrArr)[2]).dwUser <> 0) then 
      begin
        while (waveOutUnprepareHeader(FHWO, PPointerArray(FWaveHdrArr)[2],
          FHdrSize) = WAVERR_STILLPLAYING) do
          sleep(SLEEPTIME);
      end;
    end 
    else 
    begin
      inc(FFillup);
      if (FFillup = 2) then 
      begin
        // Write the previously calculated 2 headers
        waveOutPrepareHeader(FHWO, PPointerArray(FWaveHdrArr)[0], FHdrSize);
        waveOutWrite(FHWO, PPointerArray(FWaveHdrArr)[0], FHdrSize);

        // Header has now been sent
        PWaveHdr(PPointerArray(FWaveHdrArr)[0]).dwUser := 1;

        WaveSwap;

        waveOutPrepareHeader(FHWO, PPointerArray(FWaveHdrArr)[0], FHdrSize);
        waveOutWrite(FHWO, PPointerArray(FWaveHdrArr)[0], FHdrSize);

        // Header has now been sent
        PWaveHdr(PPointerArray(FWaveHdrArr)[0]).dwUser := 1;
      end 
      else
        WaveSwap;
    end;

    for i := 0 to FChannels - 1 do
      FBuffer[i] := i * FChannels;
  end;
end;

end.
