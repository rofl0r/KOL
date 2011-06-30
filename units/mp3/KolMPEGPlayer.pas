(*
 *  File:     $RCSfile: MPEGPlayer.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: MPEGPlayer.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
 *  Author:   $Author: fobmagog $
 *  Homepage: http://delphimpeg.sourceforge.net/
 *            Kol translation and Thread adaption by Thaddy de Koning
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
unit KolMPEGPlayer;

interface

uses
  Kol, windows, err, KolArgs, KolSynthFilter, KolCRC, KolLayer3, KolShared,
  KolHeader, kolplayer, kolobuffer_mci;

type
  PMPEGPlayer = ^TMPEGPlayer;
  TMPEGPlayer = object(TObj)
  private
    FFilename: string;
    FArgs: PMPEGArgs;
    FFilter1: PSynthesisFilter;
    FFilter2: PSynthesisFilter;
    FCRC: PCRC16;
    FOutput: POBuffer_mci;
    FLayer: cardinal;
    FLayer3: PLayerIII_Decoder;
    FDoRepeat: boolean;
    FIsPlaying: boolean;
    FStartTime: cardinal;
    FThread: PThread;
    function threadproc(Sender: PThread): integer;
    procedure DoDecode;
  protected
    function GetPosition: integer; virtual;
    function GetLength: integer; virtual;
    function GetMode: TMode; virtual;
    function GetChannels: TChannels; virtual;
    function GetVersion: TVersion; virtual;
    function GetLayer: integer; virtual;
    function GetFrequency: integer; virtual;
    function GetBitrate: integer; virtual;
    function GetIsPlaying: boolean; virtual;
    function GetDoRepeat: boolean; virtual;
    procedure SetDoRepeat(Value: boolean); virtual;

  public
    property Position: integer read GetPosition;
    property Length: integer read Getlength;
    property Mode: TMode read getmode;
    property Channels: Tchannels read Getchannels;
    property Version: TVersion read Getversion;
    property Layer: integer read getlayer;
    property Frequency: integer read GetFrequency;
    property Bitrate: integer read getbitrate;
    property IsPlaying: boolean read getisplaying;
    property DoRepeat: boolean read getdorepeat write setdorepeat;
    property filename: string read FFilename;
    property Thread:PThread Read Fthread;
    destructor Destroy; virtual;

    procedure LoadFile(aFileName: string); virtual;
    procedure SetOutput(Output: POBuffer_mci); virtual;
    procedure Play; virtual;
    procedure Pause; virtual;
    procedure Continue;
    procedure Stop; virtual;
  end;

function newMPEGPlayer: PMpegplayer;

implementation

uses

  KolBitStream, kolSubBand, kolSubBand1, kolSubBand2;

  { TMPEGPlayer }

function newMPEGPlayer: PMpegplayer;
begin
  New(Result, Create);
  with Result^ do
  begin
    FArgs := NewMPEGArgs;
    FArgs.MPEGHeader := NewHeader;
    FFilter1 := NewSynthesisFilter(0);
    FFilter2 := NewSynthesisFilter(1);
    FCRC := nil;
    FOutput := nil;
    FIsPlaying := False;
    FDoRepeat := False;
  end;
end;

destructor TMPEGPlayer.Destroy;
begin
  Stop;
  if (Assigned(FCRC)) then
    FCRC.free;
  if Assigned(FArgs.Stream) then
    FArgs.Stream.free;
  if Assigned(FOutput) then
    FOutput.free;
  FFilter1.free;
  FFilter2.free;
  FArgs.MPEGHeader.free;
  FArgs.free;
end;

procedure TMPEGPlayer.DoDecode;
var
  aMode: TMode;
  NumSubBands, i: cardinal;
  SubBands: array[0..31] of PSubBand;
  ReadReady, WriteReady: boolean;
begin
  // is there a change in important parameters?
  // (bitrate switching is allowed)
  if (FArgs.MPEGHeader.Layer <> FLayer) then
  begin
    // layer switching is allowed
    if (FArgs.MPEGHeader.Layer = 3) then
      FLayer3 := NewLayerIII_Decoder(FArgs.Stream, FArgs.MPEGHeader,
        FFilter1, FFilter2, FOutput, FArgs.WhichC)
    else if (FLayer = 3) then
      FLayer3.free;

    FLayer := FArgs.MPEGHeader.Layer;
  end;

  if (FLayer <> 3) then
  begin
    NumSubBands := FArgs.MPEGHeader.NumberOfSubbands;
    aMode := FArgs.MPEGHeader.Mode;

    // create subband objects:
    if (FLayer = 1) then
    begin
      if (aMode = SingleChannel) then
        for i := 0 to NumSubBands - 1 do
          SubBands[i] := NewSubbandLayer1(i)
      else if (aMode = JointStereo) then
      begin
        for i := 0 to FArgs.MPEGHeader.IntensityStereoBound - 1 do
          SubBands[i] := NewSubbandLayer1Stereo(i);

        i := FArgs.MPEGHeader.IntensityStereoBound;
        while (cardinal(i) < NumSubBands) do
        begin
          SubBands[i] := NewSubbandLayer1IntensityStereo(i);
          inc(i);
        end;
      end
      else
      begin
        for i := 0 to NumSubBands - 1 do
          SubBands[i] := NewSubbandLayer1Stereo(i);
      end;
    end
    else
    begin  // Layer II
      if (aMode = SingleChannel) then
        for i := 0 to NumSubBands - 1 do
          SubBands[i] := NewSubbandLayer2(i)
      else if (aMode = JointStereo) then
      begin
        for i := 0 to FArgs.MPEGHeader.IntensityStereoBound - 1 do
          SubBands[i] := NewSubbandLayer2Stereo(i);

        i := FArgs.MPEGHeader.IntensityStereoBound;
        while (cardinal(i) < NumSubBands) do
        begin
          SubBands[i] := NewSubbandLayer2IntensityStereo(i);
          inc(i);
        end;
      end
      else
      begin
        for i := 0 to NumSubBands - 1 do
          SubBands[i] := NewSubbandLayer2Stereo(i);
      end;
    end;

    // start to read audio data:
    for i := 0 to NumSubBands - 1 do
      SubBands[i].ReadAllocation(FArgs.Stream, FArgs.MPEGHeader, FCRC);

    if (FLayer = 2) then
      for i := 0 to NumSubBands - 1 do
        PSubBandLayer2(SubBands[i]).ReadScaleFactorSelection(FArgs.Stream, FCRC);

    if (FCRC = nil) or (FArgs.MPEGHeader.ChecksumOK) then
    begin
      // no checksums or checksum ok, continue reading from stream:
      for i := 0 to NumSubBands - 1 do
        SubBands[i].ReadScaleFactor(FArgs.Stream, FArgs.MPEGHeader);

      repeat
        ReadReady := True;
        for i := 0 to NumSubBands - 1 do
          ReadReady := SubBands[i].ReadSampleData(FArgs.Stream);

        repeat
          WriteReady := True;
          for i := 0 to NumSubBands - 1 do
            WriteReady := SubBands[i].PutNextSample(FArgs.WhichC, FFilter1, FFilter2);

          FFilter1.CalculatePCMSamples(FOutput);
          if ((FArgs.WhichC = Both) and (aMode <> SingleChannel)) then
            FFilter2.CalculatePCMSamples(FOutput);
        until (WriteReady);
      until (ReadReady);

      FOutput.WriteBuffer;
    end;

    for i := 0 to NumSubBands - 1 do
      SubBands[i].free;
  end
  else  // Layer III
    FLayer3.Decode;
end;

function TMPEGPlayer.GetBitrate: integer;
begin
  Result := FArgs.MPEGHeader.Bitrate;
end;

function TMPEGPlayer.GetChannels: TChannels;
begin
  Result := FArgs.WhichC;
end;

function TMPEGPlayer.GetDoRepeat: boolean;
begin
  Result := FDoRepeat;
end;

function TMPEGPlayer.GetFrequency: integer;
begin
  Result := FArgs.MPEGHeader.Frequency;
end;

function TMPEGPlayer.GetIsPlaying: boolean;
begin
  Result := FIsPlaying;
end;

function TMPEGPlayer.GetLayer: integer;
begin
  Result := FArgs.MPEGHeader.Layer;
end;

function TMPEGPlayer.GetLength: integer;
begin
  Result := Round(FArgs.MPEGHeader.TotalMS(FArgs.Stream) / 1000);
end;

function TMPEGPlayer.GetMode: TMode;
begin
  Result := FArgs.MPEGHeader.Mode;
end;

function TMPEGPlayer.GetPosition: integer;
begin
    if Fthread = nil then
      Result := 0
    else
      Result := (GetTickCount - FStartTime) div 1000;
end;

function TMPEGPlayer.GetVersion: TVersion;
begin
  Result := FArgs.MPEGHeader.Version;
end;

procedure TMPEGPlayer.LoadFile(aFileName: string);
begin
  FFilename := aFilename;
  if (Assigned(FCRC)) then
    FCRC.free;
  FArgs.Stream := NewBitStream(PChar(aFileName));
  FArgs.WhichC := Both;
  FArgs.MPEGHeader.ReadHeader(FArgs.Stream, FCRC);
end;

procedure TMPEGPlayer.Pause;
begin
  Fthread.suspend;
end;

procedure TMPEGPlayer.Continue;
begin
  FThread.Resume;
end;

procedure TMPEGPlayer.Play;
begin
  // Start the thread.
  // Adapted by Thaddy to support multiple platforms and Pause/continue
  FIsPlaying := True;
  Fthread := NewThreadAutoFree(ThreadProc);
  Fthread.PriorityClass:=HIGH_PRIORITY_CLASS;

  //Better performance on proper multithreaded systems
  //but proper response of the GUI thread on older versions
  //if Ord(winver) >= ord(wvNT) then
  //  Fthread.ThreadPriority:=THREAD_PRIORITY_HIGHEST;
  FStartTime := GetTickCount;
end;

procedure TMPEGPlayer.SetDoRepeat(Value: boolean);
begin
  FDoRepeat := Value;
end;

procedure TMPEGPlayer.SetOutput(Output: POBuffer_mci);
begin
  FOutput := Output;
end;

procedure TMPEGPlayer.Stop;
begin
  FIsplaying := False;
  if assigned(Fthread) then
    Fthread.Terminate;
end;

function TMpegPlayer.threadproc(Sender: PThread): integer;
var
  FrameRead: boolean;
  Curr, Total: cardinal;
begin
  FrameRead := True;
  while (FrameRead) and (FIsPlaying) do
  begin
    DoDecode;
    FrameRead := FArgs.MPEGHeader.ReadHeader(FArgs.Stream, FCRC);
    //Give remaining timeslice back to the system
    Sleep(0);

    Curr := FArgs.Stream.CurrentFrame;
    Total := FArgs.MPEGHeader.MaxNumberOfFrames(FArgs.Stream);

    if (FDoRepeat) then
    begin
      if ((not FrameRead) and (Curr + 20 >= Total)) or (Curr >= Total) then
      begin
        FArgs.Stream.Restart;
        if (Assigned(FCRC)) then
          FCRC.free;

        FrameRead := FArgs.MPEGHeader.ReadHeader(FArgs.Stream, FCRC);
      end;

      if (GetTickCount >= FStartTime + Round(FArgs.MPEGHeader.TotalMS(FArgs.Stream))) then
        FStartTime := GetTickCount;
    end;
  end;
  FIsPlaying := False;
  Result := 0;
end;

end.




