{ ------------------------------------------------------------------------------

  DIUcl Demo project to show stream compression and decompression
  using the UCL Compression Library.

  This Demo uses the Stream Compression function UclCompressStream and
  UclDecompressStream. The compressed output stream, however, is compatible
  to the format used by the UCL Compression and Decompression Streams classes.

  To use the KOL library to create smaller applications, define the 'KOL'
  compiler directive.

  Copyright (c) 2003 Ralf Junker - The Delphi Inspiration
  <delphi@zeitungsjunge.de>
  http://www.zeitungsjunge.de/delphi/

------------------------------------------------------------------------------ }

program UCL_Streams_File;

{$APPTYPE CONSOLE}

uses
  {$IFDEF KOL}
  KOL,
  {$ELSE}
  SysUtils, Classes,
  {$ENDIF}
  DIUclStreams;

{ ---------------------------------------------------------------------------- }

procedure UclCallback(const InBytes, OutBytes: Cardinal; const User: Pointer);
begin
  Write('.');
  { Uncomment the following line to write detailed progress. }
  //  WriteLn('In: ', InBytes, ' - Out: ', OutBytes);
end;

{ ---------------------------------------------------------------------------- }

const
  BufferSize = $8000;
var
  InFile, OutFile: AnsiString;
  InStream, OutStream: {$IFDEF KOL}PStream{$ELSE}TFileStream{$ENDIF};
begin
  InFile := ParamStr(0);
  OutFile := ChangeFileExt(InFile, '.ucl');

  {$IFDEF KOL}
  InStream := NewReadFileStream(InFile);
  OutStream := NewWriteFileStream(OutFile);
  {$ELSE}
  InStream := TFileStream.Create(InFile, fmOpenRead or fmShareDenyWrite);
  OutStream := TFileStream.Create(OutFile, fmCreate);
  {$ENDIF}

  WriteLn('Compressing ', InFile, ' ');
  if UclCompressStream(InStream, OutStream, 10, BufferSize, UclCallback) then
    begin
      WriteLn;
      WriteLn('UCL Compression OK');
    end
  else
    begin
      WriteLn;
      WriteLn('UCL Compression Error');
    end;
  WriteLn; WriteLn;

  InStream.Free;
  OutStream.Free;

  InFile := OutFile;
  OutFile := ChangeFileExt(InFile, '.ucl.exe');

  {$IFDEF KOL}
  InStream := NewReadFileStream(InFile);
  OutStream := NewWriteFileStream(OutFile);
  {$ELSE}
  InStream := TFileStream.Create(InFile, fmOpenRead or fmShareDenyWrite);
  OutStream := TFileStream.Create(OutFile, fmCreate);
  {$ENDIF}

  WriteLn('Decompressing ', InFile);
  if UclDeCompressStream(InStream, OutStream, BufferSize, UclCallback) then
    begin
      WriteLn;
      WriteLn('UCL Decompression OK');
    end
  else
    begin
      WriteLn;
      WriteLn('UCL Decompression Error');
    end;

  InStream.Free;
  OutStream.Free;

  ReadLn;
end.

