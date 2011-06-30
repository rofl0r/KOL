(*
 *  File:     $RCSfile: OBuffer.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: OBuffer.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
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
{$DEFINE SEEK_STOP}
unit KolOBuffer;

interface
uses
  Windows,kol;

const
  OBUFFERSIZE  = 2 * 1152;  // max. 2 * 1152 samples per frame
  MAX_CHANNELS = 2;         // max. number of channels

type
  // Abstract base class for audio output classes:

  PObuffer=^ TObuffer;
  TOBuffer = object(Tobj)
  public
    // this function takes a 16 Bit PCM sample
    procedure Append(Channel: Cardinal; Value: SmallInt); virtual;

    // this function should write the samples to the filedescriptor
    // or directly to the audio hardware
    procedure WriteBuffer; virtual;

{$IFDEF SEEK_STOP}
    // Clears all data in the buffer (for seeking)
    procedure ClearBuffer; virtual;

    // Notify the buffer that the user has stopped the stream
    procedure SetStopFlag; virtual;
{$ENDIF}
  end;

implementation

{ TOBuffer }

procedure TOBuffer.Append(Channel: Cardinal; Value: SmallInt);
begin

end;

procedure TOBuffer.ClearBuffer;
begin

end;

procedure TOBuffer.SetStopFlag;
begin

end;

procedure TOBuffer.WriteBuffer;
begin

end;

end.
