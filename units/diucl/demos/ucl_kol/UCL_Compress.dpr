{ ------------------------------------------------------------------------------

  UCL_Compress -- Example using a UCL Compression stream with KOL

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

program Compress;

{$APPTYPE CONSOLE}

uses
  Windows,
  KOL, // Download from http://bonanzas.rinet.ru
  DIUclStreams;

  // Cut from Classes.TStream.CopyFrom with some small modifications...
function StreamCopy(Dest, Source: PStream; Count: DWORD): DWORD;
const
  MaxBufSize = $80000;
var
  BufSize: DWORD;
  Readed: DWORD;
  Buffer: PAnsiChar;
  Need: DWORD;
begin
  if Count = 0 then
    begin
      Source.Seek(0, spBegin);
      Count := Source.Size;
    end;
  Result := 0;
  if Count > MaxBufSize then BufSize := MaxBufSize else BufSize := Count;
  GetMem(Buffer, BufSize);
  try // => try .. finally works for 'Exit' command even without Kol_Err.pas !
    repeat
      if Count > BufSize then Need := BufSize else Need := Count;
      Readed := Source.Read(Buffer^, Need);
      if Readed = STREAM_ERROR then Exit;
      if Dest.Write(Buffer^, Readed) = STREAM_ERROR then Exit;
      Dec(Count, Readed);
      Inc(Result, Readed);
    until (Count = 0) or (Readed = 0) or (Readed = STREAM_ERROR);
  finally
    // Exit brings us here...
    FreeMem(Buffer, BufSize);
  end;
end;

var
  Source: PStream;
  Dest: PStream;
  UclStream: PStream;
  Error: Boolean;
  Size: DWORD;
begin
  if ParamCount < 2 then
    begin
      WriteLn('Usage: UCL_Compress.exe InFile OutFile');
      WriteLn('Press Enter to exit');
      Readln;
      Exit;
    end;

  Error := False;
  Source := NewReadFileStream(ParamStr(1));
  try
    if Source.Size = STREAM_ERROR then
      Exit;
    Dest := NewWriteFileStream(ParamStr(2));
    try
      if Dest.Size = STREAM_ERROR then
        Exit;
      Size := Source.Size;
      Dest.Write(Size, 4);
      if not NewUclCCStream(UclStream, 10, $40000, Dest, nil) then Exit;
      { If you receive a compilation error here, make sure to define
        the KOL compiler directive. There are various options to do so:

        1. Project -> Options -> Directives/Conditionals -> Conditional Defines,
           enter KOL there.

        2. There is a also ready-made entry in DIUclStreams.pas which you can
           easily uncomment.

        When done, make sure to rebuild the project: Projects -> Build. }
      Error := not (StreamCopy(UclStream, Source, 0) = Source.Size);
      UclStream.Free;
    finally
      Dest.Free;
      if Error then
        DeleteFile(PAnsiChar(ParamStr(2)));
    end;
  finally
    Source.Free;
  end;
end.

