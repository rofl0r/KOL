(*
 *  File:     $RCSfile: MPEGPlay.dpr,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: MPEGPlay.dpr,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
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
program MPEGPlay;

{$APPTYPE CONSOLE}

uses
  Windows,
  Kol,
  err,
  KOLOBuffer_Wave in 'KOLOBuffer_Wave.pas',
  KolOBuffer_MCI in 'KolOBuffer_MCI.pas',
  KolMPEGPlayer in 'KolMPEGPlayer.pas';

var
  Play: PMPEGPlayer;
begin
  Play := NewMPEGPlayer;
  Play.LoadFile('d:\sticky fingers\bitch.mp3');
  //  Play.LoadFile('M:\Misc Music\KoRn\Korn - Good God (Rammstein Mix).mp3');
  Play.SetOutput(CreateMCIOBffer(Play));
  Play.DoRepeat := True;
  Play.Play;
  try
    while Play.IsPlaying do 
    begin
      Write(Format(#13'Playing: %d:%.2d of %d:%.2d (%d KBps)',
        [Play.Position div 60, Play.Position mod 60, Play.Length div
        60, Play.Length mod 60, Play.Bitrate div 1000]));
      Sleep(50);

      if (GetKeyState(VK_ESCAPE) and $8000 <> 0) then 
      begin
        Play.Stop;
        break;
      end;
    end;
  except
    on E: Exception do
      Writeln(Format(#13'Exception: %s', [E.Message]));
  end;
  Writeln;
  Free_And_Nil(Play);
end.
