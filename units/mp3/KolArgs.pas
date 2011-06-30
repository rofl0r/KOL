(*
 *  File:     $RCSfile: Args.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: Args.pas,v 1.1.1.1 2002/04/21 12:57:16 fobmagog Exp $
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
unit KolArgs;

interface

uses
  Windows, Kol, MMSystem, KolBitStream, KolHeader, KolShared;

type
  TOutput = (WAVEMAPPER, DIRECTSOUND, WAVEFILE);
  PArgs = ^TArgs;
  TArgs = object(Tobj)
  public
    Stop: boolean;
    Pause: boolean;
    Done: boolean;
    NonSeekable: boolean;
    DesiredPosition: integer;
    PositionChange: boolean;
    PlayMutex: THandle;

    constructor Create;
  end;

  // A class to contain arguments for maplay.
  PMpegArgs = ^TMpegArgs;
  TMPEGArgs = object(TArgs)
  private
    FErrorCode: cardinal;

  public
    Stream: PBitStream;
    MPEGHeader: PHeader;
    WhichC: TChannels;
    UseOwnScaleFactor: boolean;
    ScaleFactor: single;
    StartPos: cardinal;  // start and finish positions (in frames)
    EndPos: cardinal;
    MusicPos: cardinal;  // current position (in frames)
    PlayMode: cardinal;  // -1 - not initialized, 0 - closed, 1 - opened, 2 - stopped
    //  3 - playing, 4 - paused

    phwo: HWAVEOUT;
    OutputMode: TOutput;
    OutputFileName: array[0..MAX_PATH - 1] of char;

    //constructor Create; 

    function ErrorCode: cardinal;
  end;

function newMPEGArgs: pMPEGArgs;

implementation

{ TArgs }

constructor TArgs.Create;
begin
  inherited;
  Stop := False;
  Pause := False;
  Done := False;
  NonSeekable := False;
  DesiredPosition := 0;
  PositionChange := False;
end;

{ TMPEGArgs }

function newMPEGArgs: pMPEGArgs;
begin
  New(Result, Create);
  with Result^ do
  begin
    Stream := nil;
    MPEGHeader := nil;
    WhichC := Both;
    UseOwnScalefactor := False;
    ScaleFactor := 32768.0;

    OutputMode := WAVEFILE;
    OutputFileName := '';
  end;
end;

function TMPEGArgs.ErrorCode: cardinal;
begin
  Result := FErrorcode;
  FErrorcode := 0;
end;

end.
