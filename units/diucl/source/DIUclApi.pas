{ ------------------------------------------------------------------------------

  DIUclApi.pas -- UCL Compression Library API for Borland Delphi

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

{ @abstract(UCL Compression Library API.) }
unit DIUclApi;

{$I DI.inc}
{.$DEFINE HAVE_DICHELPERS}// Default: Off

interface

const
  { }
  UCL_VERSION_CONST = $010100;

  { Error codes for the compression/decompression functions. Negative
    values are errors, positive values will be used for special but
    normal events. }
  { }
  UCL_E_OK = 0;
  UCL_E_ERROR = -1;
  UCL_E_INVALID_ARGUMENT = -2;
  UCL_E_OUT_OF_MEMORY = -3;
  //* compression errors */
  { }
  UCL_E_NOT_COMPRESSIBLE = -101;
  //* decompression errors */
  { }
  UCL_E_INPUT_OVERRUN = -201;
  UCL_E_OUTPUT_OVERRUN = -202;
  UCL_E_LOOKBEHIND_OVERRUN = -203;
  UCL_E_EOF_NOT_FOUND = -204;
  UCL_E_INPUT_NOT_CONSUMED = -205;
  UCL_E_OVERLAP_OVERRUN = -206;

type
  PCardinal = ^Cardinal;

  ucl_progress_callback_p = ^ucl_progress_callback_t;
  ucl_progress_callback_t = record
    Callback: procedure(TextSize: Cardinal; CodeSize: Cardinal; State: Integer; User: Pointer);
    User: Pointer;
  end;

  ucl_compress_config_p = ^ucl_compress_config_t;
  ucl_compress_config_t = record
    bb_endian: Integer;
    bb_size: Integer;
    max_offset: Cardinal;
    max_match: Cardinal;
    s_level: Integer;
    h_level: Integer;
    p_level: Integer;
    c_flags: Integer;
    m_size: Cardinal;
  end;

  { ---------------------------------------------------------------------------- }

{ @Name should be the first function you call. Check the return code! }
function ucl_init: Integer;
function __ucl_init2(v: Cardinal; s1, s2, s3, s4, s5, s6, s7, s8, s9: Integer): Integer;

{ Returns the UCL Compression Library version. }
function ucl_version: Cardinal;
{ Returns a pointer to the UCL Compression Library version string. }
function ucl_version_string: PAnsiChar;
{ Returns a pointer to the UCL Compression Library version date. }
function ucl_version_date: PAnsiChar;

{ Calculates the worst-case data expansion for non-compressible data. }
function ucl_output_block_size(const input_block_size: Cardinal): Cardinal;

{ ---------------------------------------------------------------------------- }
{ B
{ ---------------------------------------------------------------------------- }

{ Compresses a block of data. }
function ucl_nrv2b_99_compress(
  const in_: Pointer;
  in_len: Cardinal;
  out_: Pointer;
  var out_len: Cardinal;
  cb: ucl_progress_callback_p;
  Level: Integer;
  const conf: ucl_compress_config_p;
  Result: PCardinal): Integer;

{ ---------- }

{ @abstract(The 'standard' decompressor. Pretty fast - use this whenever possible.)
  This decompressor expects valid compressed data. If the compressed data gets
  corrupted somehow (e.g. transmission via an erroneous channel, disk errors,
  ...) it will probably crash your application because absolutely no additional
  checks are done. }
function ucl_nrv2b_decompress_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

{ @abstract(The 'safe' decompressor. Somewhat slower.)
  This decompressor will catch all compressed data violations and return an
  error code in this case - it will never crash. }
function ucl_nrv2b_decompress_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_decompress_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

{ @abstract(Same as @link(ucl_nrv2b_decompress_8) - written in assembler.) }
function ucl_nrv2b_decompress_asm_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ @abstract(Same as @link(ucl_nrv2b_decompress_safe_8) - written in assembler.) }
function ucl_nrv2b_decompress_asm_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ @abstract(Similar to @link(ucl_nrv2b_decompress_asm_8) - but even faster.)
  For reasons of speed this decompressor can write 1 to 3 bytes past the end of
  the decompressed (output) block. [ technical note: because data is transferred
  in 32-bit units ]
  <P>Use this when you are decompressing from one memory block to another
  memory block - just provide output space for 3 extra bytes. You shouldn't use
  it if e.g. you are directly decompressing to video memory (because the extra
  bytes will be visible on screen). }
function ucl_nrv2b_decompress_asm_fast_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ This is the safe version of @link(ucl_nrv2b_decompress_asm_fast_8).}
function ucl_nrv2b_decompress_asm_fast_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_fast_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2b_decompress_asm_small_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_small_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2b_decompress_asm_small_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ Tests an overlapping in-place decompression within a buffer:
  <UL>
  <LI>try a virtual decompression from src[src_off] -> src[0]
  <LI>no data is actually written
  <LI>only the bytes at src[src_off .. src_off+src_len] will get accessed
  </UL> }
function ucl_nrv2b_test_overlap_8(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_test_overlap_le16(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2b_test_overlap_le32(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }
{ D
{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_99_compress(
  const in_: Pointer;
  in_len: Cardinal;
  out_: Pointer;
  var out_len: Cardinal;
  cb: ucl_progress_callback_p;
  Level: Integer;
  const conf: ucl_compress_config_p;
  Result: PCardinal): Integer;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_decompress_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_asm_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_asm_fast_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_asm_fast_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_fast_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_asm_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_decompress_asm_small_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_small_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2d_decompress_asm_small_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2d_test_overlap_8(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_test_overlap_le16(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2d_test_overlap_le32(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }
{ E
{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_99_compress(
  const in_: Pointer;
  in_len: Cardinal;
  out_: Pointer;
  var out_len: Cardinal;
  cb: ucl_progress_callback_p;
  Level: Integer;
  const conf: ucl_compress_config_p;
  Result: PCardinal): Integer;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_decompress_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_asm_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_asm_fast_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_asm_fast_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_fast_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_asm_safe_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_safe_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_safe_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_decompress_asm_small_8(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_small_le16(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

function ucl_nrv2e_decompress_asm_small_le32(
  const Src: Pointer;
  src_len: Cardinal;
  dst: Pointer;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer; cdecl;

{ ---------------------------------------------------------------------------- }

{ }
function ucl_nrv2e_test_overlap_8(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_test_overlap_le16(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

function ucl_nrv2e_test_overlap_le32(
  const Src: Pointer;
  src_off: Cardinal;
  src_len: Cardinal;
  var dst_len: Cardinal;
  wrkmem: Pointer): Integer;

{ ---------------------------------------------------------------------------- }

implementation

{ ---------------------------------------------------------------------------- }
{ Delphi-styled C helper functions.
{ ---------------------------------------------------------------------------- }

{$IFDEF HAVE_DICHELPERS}
uses
  DICHelpers;
{$ELSE}

{ ---------------------------------------------------------------------------- }

function _malloc(const Size: Cardinal): Pointer; cdecl;
begin
  GetMem(Result, Size);
end;

{ ---------------------------------------------------------------------------- }

procedure _free(const p: Pointer); cdecl;
begin
  FreeMem(p);
end;

{ ---------------------------------------------------------------------------- }

function _memcpy(Dest: Pointer; const Src: Pointer; n: Cardinal): Pointer; cdecl;
begin
  Result := Dest;
  Move(Src^, Result^, n);
end;

{ ---------------------------------------------------------------------------- }

function _memset(const Source: Pointer; const Value: Integer; const Count: Cardinal): Pointer; cdecl;
begin
  Result := Source;
  FillChar(Result^, Count, Value);
end;
{$ENDIF HAVE_DICHELPERS}

{ ---------------------------------------------------------------------------- }

function ucl_init: Integer;
begin
  Result := __ucl_init2(
    UCL_VERSION_CONST,
    SizeOf(SmallInt),
    SizeOf(Integer),
    SizeOf(Integer),
    SizeOf(Cardinal),
    SizeOf(Cardinal),
    -1,
    SizeOf(PAnsiChar),
    SizeOf(Pointer),
    4); // sizeof(ucl_compress_t) = 4
end;

{ ---------------------------------------------------------------------------- }

function ucl_output_block_size(const input_block_size: Cardinal): Cardinal;
begin
  Result := input_block_size + input_block_size div 8 + 256;
end;

{ ---------------------------------------------------------------------------- }

{ Order of linked objects is important! }

{$L UCL_init.obj}
{$L UCL_ptr.obj}
{$L UCL_util.obj}

{ ---------------------------------------------------------------------------- }
{ B
{ ---------------------------------------------------------------------------- }

{$L n2b_99.obj}
{$L n2b_d.obj}
{$L n2b_ds.obj}
{$L n2b_to.obj}

{$L n2b_d_f1.obj}
{$L n2b_d_f2.obj}
{$L n2b_d_f3.obj}
{$L n2b_d_f4.obj}
{$L n2b_d_f5.obj}
{$L n2b_d_f6.obj}

{$L n2b_d_n1.obj}
{$L n2b_d_n2.obj}
{$L n2b_d_n3.obj}
{$L n2b_d_n4.obj}
{$L n2b_d_n5.obj}
{$L n2b_d_n6.obj}

{$L n2b_d_s1.obj}
{$L n2b_d_s2.obj}
{$L n2b_d_s3.obj}
{$L n2b_d_s4.obj}
{$L n2b_d_s5.obj}
{$L n2b_d_s6.obj}

{ ---------------------------------------------------------------------------- }
{ D
{ ---------------------------------------------------------------------------- }

{$L n2d_99.obj}
{$L n2d_d.obj}
{$L n2d_ds.obj}
{$L n2d_to.obj}

{$L n2d_d_f1.obj}
{$L n2d_d_f2.obj}
{$L n2d_d_f3.obj}
{$L n2d_d_f4.obj}
{$L n2d_d_f5.obj}
{$L n2d_d_f6.obj}

{$L n2d_d_n1.obj}
{$L n2d_d_n2.obj}
{$L n2d_d_n3.obj}
{$L n2d_d_n4.obj}
{$L n2d_d_n5.obj}
{$L n2d_d_n6.obj}

{$L n2d_d_s1.obj}
{$L n2d_d_s2.obj}
{$L n2d_d_s3.obj}
{$L n2d_d_s4.obj}
{$L n2d_d_s5.obj}
{$L n2d_d_s6.obj}

{ ---------------------------------------------------------------------------- }
{ E
{ ---------------------------------------------------------------------------- }

{$L n2e_99.obj}
{$L n2e_d.obj}
{$L n2e_ds.obj}
{$L n2e_to.obj}

{$L n2e_d_f1.obj}
{$L n2e_d_f2.obj}
{$L n2e_d_f3.obj}
{$L n2e_d_f4.obj}
{$L n2e_d_f5.obj}
{$L n2e_d_f6.obj}

{$L n2e_d_n1.obj}
{$L n2e_d_n2.obj}
{$L n2e_d_n3.obj}
{$L n2e_d_n4.obj}
{$L n2e_d_n5.obj}
{$L n2e_d_n6.obj}

{$L n2e_d_s1.obj}
{$L n2e_d_s2.obj}
{$L n2e_d_s3.obj}
{$L n2e_d_s4.obj}
{$L n2e_d_s5.obj}
{$L n2e_d_s6.obj}

{ ---------------------------------------------------------------------------- }

{$L alloc.obj}

{ ---------------------------------------------------------------------------- }

function __ucl_init2; external;

function ucl_version; external;
function ucl_version_string; external;
function ucl_version_date; external;

{ ---------------------------------------------------------------------------- }
{ B
{ ---------------------------------------------------------------------------- }

function ucl_nrv2b_99_compress; external;

function ucl_nrv2b_decompress_8; external;
function ucl_nrv2b_decompress_le16; external;
function ucl_nrv2b_decompress_le32; external;

function ucl_nrv2b_decompress_safe_8; external;
function ucl_nrv2b_decompress_safe_le16; external;
function ucl_nrv2b_decompress_safe_le32; external;

function ucl_nrv2b_decompress_asm_8; external;
function ucl_nrv2b_decompress_asm_le16; external;
function ucl_nrv2b_decompress_asm_le32; external;

function ucl_nrv2b_decompress_asm_fast_8; external;
function ucl_nrv2b_decompress_asm_fast_le16; external;
function ucl_nrv2b_decompress_asm_fast_le32; external;

function ucl_nrv2b_decompress_asm_fast_safe_8; external;
function ucl_nrv2b_decompress_asm_fast_safe_le16; external;
function ucl_nrv2b_decompress_asm_fast_safe_le32; external;

function ucl_nrv2b_decompress_asm_safe_8; external;
function ucl_nrv2b_decompress_asm_safe_le16; external;
function ucl_nrv2b_decompress_asm_safe_le32; external;

function ucl_nrv2b_decompress_asm_small_8; external;
function ucl_nrv2b_decompress_asm_small_le16; external;
function ucl_nrv2b_decompress_asm_small_le32; external;

function ucl_nrv2b_test_overlap_8; external;
function ucl_nrv2b_test_overlap_le16; external;
function ucl_nrv2b_test_overlap_le32; external;

{ ---------------------------------------------------------------------------- }
{ D
{ ---------------------------------------------------------------------------- }

function ucl_nrv2d_99_compress; external;

function ucl_nrv2d_decompress_8; external;
function ucl_nrv2d_decompress_le16; external;
function ucl_nrv2d_decompress_le32; external;

function ucl_nrv2d_decompress_safe_8; external;
function ucl_nrv2d_decompress_safe_le16; external;
function ucl_nrv2d_decompress_safe_le32; external;

function ucl_nrv2d_decompress_asm_8; external;
function ucl_nrv2d_decompress_asm_le16; external;
function ucl_nrv2d_decompress_asm_le32; external;

function ucl_nrv2d_decompress_asm_fast_8; external;
function ucl_nrv2d_decompress_asm_fast_le16; external;
function ucl_nrv2d_decompress_asm_fast_le32; external;

function ucl_nrv2d_decompress_asm_fast_safe_8; external;
function ucl_nrv2d_decompress_asm_fast_safe_le16; external;
function ucl_nrv2d_decompress_asm_fast_safe_le32; external;

function ucl_nrv2d_decompress_asm_safe_8; external;
function ucl_nrv2d_decompress_asm_safe_le16; external;
function ucl_nrv2d_decompress_asm_safe_le32; external;

function ucl_nrv2d_decompress_asm_small_8; external;
function ucl_nrv2d_decompress_asm_small_le16; external;
function ucl_nrv2d_decompress_asm_small_le32; external;

function ucl_nrv2d_test_overlap_8; external;
function ucl_nrv2d_test_overlap_le16; external;
function ucl_nrv2d_test_overlap_le32; external;

{ ---------------------------------------------------------------------------- }
{ E
{ ---------------------------------------------------------------------------- }

function ucl_nrv2e_99_compress; external;

function ucl_nrv2e_decompress_8; external;
function ucl_nrv2e_decompress_le16; external;
function ucl_nrv2e_decompress_le32; external;

function ucl_nrv2e_decompress_safe_8; external;
function ucl_nrv2e_decompress_safe_le16; external;
function ucl_nrv2e_decompress_safe_le32; external;

function ucl_nrv2e_decompress_asm_8; external;
function ucl_nrv2e_decompress_asm_le16; external;
function ucl_nrv2e_decompress_asm_le32; external;

function ucl_nrv2e_decompress_asm_fast_8; external;
function ucl_nrv2e_decompress_asm_fast_le16; external;
function ucl_nrv2e_decompress_asm_fast_le32; external;

function ucl_nrv2e_decompress_asm_fast_safe_8; external;
function ucl_nrv2e_decompress_asm_fast_safe_le16; external;
function ucl_nrv2e_decompress_asm_fast_safe_le32; external;

function ucl_nrv2e_decompress_asm_safe_8; external;
function ucl_nrv2e_decompress_asm_safe_le16; external;
function ucl_nrv2e_decompress_asm_safe_le32; external;

function ucl_nrv2e_decompress_asm_small_8; external;
function ucl_nrv2e_decompress_asm_small_le16; external;
function ucl_nrv2e_decompress_asm_small_le32; external;

function ucl_nrv2e_test_overlap_8; external;
function ucl_nrv2e_test_overlap_le16; external;
function ucl_nrv2e_test_overlap_le32; external;

end.

