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

program UCL_Streams;

{$APPTYPE CONSOLE}

uses
  {$IFDEF KOL}
  KOL,
  {$ELSE}
  SysUtils, Classes,
  {$ENDIF}
  DIUclStreams;

const
  s = 'This is some text to test. This is some text to test. This is some text to test.';
var
  {$IFDEF KOL}
  InStream, OutStream: PStream;
  Str: AnsiString;
  {$ELSE}
  InStream, OutStream: TStringStream;
  {$ENDIF}
begin
  WriteLn('Original Text:');
  Write(s);
  WriteLn; WriteLn;

  {$IFDEF KOL}
  InStream := NewMemoryStream;
  InStream.WriteStr(s);
  InStream.Seek(0, spBegin);
  OutStream := NewMemoryStream;
  {$ELSE}
  InStream := TStringStream.Create(s);
  OutStream := TStringStream.Create('');
  {$ENDIF}

  if UclCompressStream(InStream, OutStream) then
    begin
      WriteLn('Compressed Text:');
      {$IFDEF KOL}
      OutStream.Seek(0, spBegin);
      SetLength(Str, OutStream.Size);
      OutStream.Read(Pointer(Str)^, OutStream.Size);
      Write(Str);
      {$ELSE}
      Write(OutStream.DataString);
      {$ENDIF}
    end
  else
    WriteLn('UCL Compression Error');
  WriteLn; WriteLn;

  InStream.Size := 0;
  {$IFDEF KOL}
  OutStream.Seek(0, spBegin);
  {$ELSE}
  OutStream.Seek(0, soFromBeginning);
  {$ENDIF}

  if UclDeCompressStream(OutStream, InStream) then
    begin
      WriteLn('Decompressed Text:');
      {$IFDEF KOL}
      InStream.Seek(0, spBegin);
      SetLength(Str, InStream.Size);
      InStream.Read(Pointer(Str)^, InStream.Size);
      Write(Str);
      {$ELSE}
      Write(InStream.DataString);
      {$ENDIF}
    end
  else
    WriteLn('UCL Decompression Error');

  InStream.Free;
  OutStream.Free;

  Readln;
end.

