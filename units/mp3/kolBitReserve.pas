(*
 *  File:     $RCSfile: BitReserve.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: BitReserve.pas,v 1.1.1.1 2002/04/21 12:57:16 fobmagog Exp $
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
unit kolBitReserve;

interface

uses
  Windows, kol;

const
  BUFSIZE = 4096;

type
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0..1024 * 1024 * 32] of cardinal;

  PBitreserve = ^Tbitreserve;
  TBitReserve = object(Tobj)
  private
    FOffset, FTotbit, FBufByteIdx: cardinal;
    FBuf: PCardinalArray;
    FBufBitIdx: cardinal;
    FPutMask: PCardinalArray;

  public
    property hsstell: cardinal read FTotBit;

    //    constructor Create;
    destructor Destroy; virtual;

    function hgetbits(n: cardinal): cardinal;
    function hget1bit: cardinal;
    procedure hputbuf(val: cardinal);

    procedure rewindNbits(n: cardinal);
    procedure rewindNbytes(n: cardinal);
  end;
function NewBitReserve: PBitreserve;

implementation

{ TBitReserve }

function NewBitReserve: PBitreserve;
var 
  ShiftedOne, i: cardinal;
begin
  New(Result, Create);
  with Result^ do
  begin
    ShiftedOne := 1;
    FOffset := 0;
    FTotbit := 0;
    FBufByteIdx := 0;
    FBuf := AllocMem(BUFSIZE * sizeof(cardinal));
    FBufBitIdx := 8;
    FPutMask := AllocMem(32 * sizeof(cardinal));

    FPutMask[0] := 0;
    for i := 1 to 31 do 
    begin
      FPutMask[i] := FPutMask[i - 1] + ShiftedOne;
      ShiftedOne := ShiftedOne shl 1;
    end;
  end;
end;

destructor TBitReserve.Destroy;
begin
  FreeMem(FPutMask);
  FreeMem(FBuf);

  inherited Destroy;
end;

// read 1 bit from the bit stream
function TBitReserve.hget1bit: cardinal;
var 
  val: cardinal;
begin
  inc(FTotbit);

  if (FBufBitIdx = 0) then 
  begin
    FBufBitIdx := 8;
    inc(FBufByteIdx);
  end;

  // BUFSIZE = 4096 = 2^12, so
  // buf_byte_idx%BUFSIZE == buf_byte_idx & 0xfff
  val := FBuf[FBufByteIdx and $fff] and FPutMask[FBufBitIdx];
  dec(FBufBitIdx);
  Result := val shr FBufBitIdx;
end;

// read N bits from the bit stream
function TBitReserve.hgetbits(n: cardinal): cardinal;
var 
  val: cardinal;
  j, k, tmp: cardinal;
begin
  inc(FTotbit, n);

  val := 0;
  j := N;

  while (j > 0) do 
  begin
    if (FBufBitIdx = 0) then 
    begin
      FBufBitIdx := 8;
      inc(FBufByteIdx);
    end;

    if (j < FBufBitIdx) then
      k := j
    else
      k := FBufBitIdx;

    // BUFSIZE = 4096 = 2^12, so
    // buf_byte_idx%BUFSIZE == buf_byte_idx & 0xfff
    tmp := FBuf[FBufByteIdx and $fff] and FPutMask[FBufBitIdx];
    dec(FBufBitIdx, k);
    tmp := tmp shr FBufBitIdx;
    dec(j, k);
    val := val or (tmp shl j);
  end;

  Result := val;
end;

// write 8 bits into the bit stream
procedure TBitReserve.hputbuf(val: cardinal);
begin
  FBuf[FOffset] := val;
  FOffset := (FOffset + 1) and $fff;
end;

procedure TBitReserve.rewindNbits(n: cardinal);
begin
  dec(FTotBit, n);
  inc(FBufBitIdx, n);

  while (FBufBitIdx >= 8) do 
  begin
    dec(FBufBitIdx, 8);
    dec(FBufByteIdx);
  end;
end;

procedure TBitReserve.rewindNbytes(n: cardinal);
begin
  dec(FTotBit, (N shl 3));
  dec(FBufByteIdx, N);
end;

end.
