{ ------------------------------------------------------------------------------

  DIUcl Demo project to show simple in memory block compression and
  decompression using the UCL Compression Library.

  This demo uses the nrv2e algorithm, which offers a slightly higher compression
  ratio than the nrv2d and nrv2b algorightms, which compress slightly faster.

  Copyright (c) 2003 Ralf Junker - The Delphi Inspiration
  <delphi@zeitungsjunge.de>
  http://www.zeitungsjunge.de/delphi/

------------------------------------------------------------------------------ }

program UCL_Simple;

{$APPTYPE Console}

uses
  DIUclApi;

const
  Size = $4000;
  CompressionLevel = 10; // From 1 (Minimum Compression) to 10 (Maximum Compression).

  {$I ..\FillRandom.inc}

label
  Quit;
var
  Source, Dest: AnsiString;
  LSource, lDest: Cardinal;
  e: Integer;
begin
  if ucl_init <> UCL_E_OK then
    begin
      WriteLn('ucl_init failed');
      Exit;
    end;

  WriteLn('UCL-Version:        ', ucl_version_string);
  WriteLn('UCL-Date:           ', ucl_version_date);

  { Set up a source string, filled with random data. }
  SetString(Source, nil, Size);
  FillRandom(Source);
  WriteLn;
  WriteLn('Original Size:      ', Size);

  { Prepare the destination string. }
  lDest := ucl_output_block_size(Size);
  SetString(Dest, nil, lDest);

  { Compress Source string to Dest string. }
  e := ucl_nrv2e_99_compress(Pointer(Source), Size, Pointer(Dest), lDest, nil, CompressionLevel, nil, nil);
  if e <> UCL_E_OK then
    begin
      WriteLn('Compression Error: ', e);
      goto Quit;
    end;
  WriteLn;
  WriteLn('Compressed Size:    ', lDest);
  WriteLn('Compression Ratio:  ', 100 - lDest * 100 div Size, ' %');
  SetLength(Dest, lDest);

  LSource := Size;
  { Decompress Dest string to Source string. Choose any of the decompression
    implementations of your liking. }

  { Use standard decompression. }
  // if ucl_nrv2e_decompress_8(Pointer(Dest), lDest, Pointer(Source), LSource, nil) <> UCL_E_OK then

  { Use assembler decompression optimized for small executable file size. }
  // if ucl_nrv2e_decompress_asm_small_8(Pointer(Dest), lDest, Pointer(Source), LSource, nil) <> UCL_E_OK then

  { Use assembler decompression optimized for speed. }
  // e := ucl_nrv2e_decompress_asm_fast_8(Pointer(Dest), lDest, Pointer(Source), LSource, nil);

  { Use safe assembler decompression optimized for speed. }
  e := ucl_nrv2e_decompress_asm_fast_safe_8(Pointer(Dest), lDest, Pointer(Source), LSource, nil);
  if e <> UCL_E_OK then
    begin
      WriteLn('Decompression Error: ', e);
      goto Quit;
    end;
  WriteLn;
  WriteLn('Decompressed Size:  ', LSource);
  SetLength(Source, LSource);

  Quit:
  WriteLn;
  WriteLn('Press Enter to exit');

  Readln;
end.

