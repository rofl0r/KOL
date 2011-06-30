(*
 *  File:     $RCSfile: Player.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: Player.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
 *  Author:   $Author: fobmagog $
 *  Homepage: http://delphimpeg.sourceforge.net/
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
unit KolPlayer;

interface
uses
  Kol, kolOBuffer, kolShared, kolHeader;

type
  PPlayer = ^TPlayer;
  TPlayer = object(Tobj)
  protected
    function GetPosition: Integer; virtual;
    function GetLength: Integer; virtual;
    function GetMode: TMode; virtual;
    function GetChannels: TChannels; virtual;
    function GetVersion: TVersion; virtual;
    function GetLayer: Integer; virtual;
    function GetFrequency: Integer; virtual;
    function GetBitrate: Integer; virtual;
    function GetIsPlaying: Boolean; virtual;
    function GetDoRepeat: Boolean; virtual;
    procedure SetDoRepeat(Value: Boolean); virtual;

  public
    property Position: Integer read GetPosition;
    property Length: Integer read GetLength;
    property Mode: TMode read GetMode;
    property Channels: TChannels read GetChannels;
    property Version: TVersion read GetVersion;
    property Layer: Integer read GetLayer;
    property Frequency: Integer read GetFrequency;
    property Bitrate: Integer read GetBitrate;
    property IsPlaying: Boolean read GetIsPlaying;
    property DoRepeat: Boolean read GetDoRepeat write SetDoRepeat;

    procedure LoadFile(FileName: String); virtual; abstract;
    procedure SetOutput(Output: TOBuffer); virtual; abstract;
    procedure Play; virtual; abstract;
    procedure Pause; virtual; abstract;
    procedure Stop; virtual; abstract;
  end;

implementation

{ TPlayer }

function TPlayer.GetBitrate: Integer;
begin

end;

function TPlayer.GetChannels: TChannels;
begin

end;

function TPlayer.GetDoRepeat: Boolean;
begin

end;

function TPlayer.GetFrequency: Integer;
begin

end;

function TPlayer.GetIsPlaying: Boolean;
begin

end;

function TPlayer.GetLayer: Integer;
begin

end;

function TPlayer.GetLength: Integer;
begin

end;

function TPlayer.GetMode: TMode;
begin

end;

function TPlayer.GetPosition: Integer;
begin

end;

function TPlayer.GetVersion: TVersion;
begin

end;

procedure TPlayer.SetDoRepeat(Value: Boolean);
begin

end;

end.
