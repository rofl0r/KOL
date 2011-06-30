{ ------------------------------------------------------------------------------

  DIUcl Demo project to show in-memory compression and in-place decompression
  using the UCL Compression Library.

  This demo uses the nrv2e algorithm, which offers a slightly higher compression
  ratio than the nrv2d and nrv2b algorightms, which compress slightly faster.

  Copyright (c) 2003 Ralf Junker - The Delphi Inspiration
  <delphi@zeitungsjunge.de>
  http://www.zeitungsjunge.de/delphi/

------------------------------------------------------------------------------ }

program UCL_Overlap;

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
  LSource, lDest, Offset: Cardinal;
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

  { Prepare for overlapping compression. First alloc plenty of memory. The
    values are taken from the LZO overlap.c example and seem to work for UCL as
    well. Next copy the uncompressed data to the end of the compression block.
    For real-world applications, this could be files, etc.

    Notice that the comperssor uses a single block of memory which initially
    contains the uncompressed data which will be partially replaced by the
    compressed data during the course of compression:

    Before Compression: |      |Uncompressed Data -----------------------------|
    After Compression:  |Compressed Data---------------------|                 |
    Overlap:            |      |-----------------------------|                 |
    }
  lDest := Size;
  { The next line is taken from LZO's overlap.c example. UCL does not document
    overlapping compression, but refers to LZO instead. }
  if lDest < $BFFF then lDest := $BFFF;
  lDest := ucl_output_block_size(lDest);
  SetString(Dest, nil, lDest);

  Offset := lDest - Size + 1;
  Move(Pointer(Source)^, Pointer(Cardinal(Dest) + Offset)^, Size);

  { The actual compression. }
  e := ucl_nrv2e_99_compress(Pointer(Cardinal(Dest) + Offset), Size, Pointer(Dest), lDest, nil, CompressionLevel, nil, nil);
  if e <> UCL_E_OK then
    begin
      WriteLn('Compression Error: ', e);
      goto Quit;
    end;
  WriteLn;
  WriteLn('Compressed Size:    ', lDest);
  WriteLn('Compression Ratio:  ', 100 - lDest * 100 div Size, ' %');
  SetLength(Dest, lDest);

  { Prepare for in-place decompression. Alloc memory and copy the compressed
    data to the end of the decompression block. For real-world applications,
    this could be files, etc.

    Notice that the decompressor uses a single block of memory which initially
    contains the compressed data which will be partially replaced by the
    decompressed data during the course of decompression:

    Before Decompression: |                   |Compressed Data ----------------|
    After Decompression:  |Decompressed Data--------------------------|        |
    Overlap:              |                   |-----------------------|        |
    }
  LSource := ucl_output_block_size(Size);
  SetString(Source, nil, LSource);
  Offset := LSource - lDest + 1;
  Move(Pointer(Dest)^, Pointer(Cardinal(Source) + Offset)^, lDest);

  { Test, if overlap buffer is sufficient. }
  e := ucl_nrv2e_test_overlap_8(Pointer(Source), Offset, lDest, LSource, nil);
  if e <> UCL_E_OK then
    begin
      WriteLn('Testing Overlap Error: ', e);
      goto Quit;
    end;

  { The actual decompression. }
  e := ucl_nrv2e_decompress_asm_fast_safe_8(Pointer(Cardinal(Source) + Offset), lDest, Pointer(Source), LSource, nil);
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

