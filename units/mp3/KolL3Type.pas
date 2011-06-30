(*
 *  File:     $RCSfile: L3Type.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: L3Type.pas,v 1.1.1.1 2002/04/21 12:57:21 fobmagog Exp $
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
unit KolL3Type;

interface

type
  PGrInfo = ^TGrInfo;
  TGrInfo = record
    part2_3_length: cardinal;
    big_values: cardinal;
    global_gain: cardinal;
    scalefac_compress: cardinal;
    window_switching_flag: cardinal;
    block_type: cardinal;
    mixed_block_flag: cardinal;
    table_select: array[0..2] of cardinal;
    subblock_gain: array[0..2] of cardinal;
    region0_count: cardinal;
    region1_count: cardinal;
    preflag: cardinal;
    scalefac_scale: cardinal;
    count1table_select: cardinal;
  end;

  PIIISideInfo = ^TIIISideInfo;
  TIIISideInfo = record
    main_data_begin: integer;
    private_bits: cardinal;
    ch: array[0..1] of record
      scfsi: array[0..3] of cardinal;
      gr: array[0..1] of TGrInfo;
    end;
  end;

  PIIIScaleFac = ^TIIIScaleFac;
  TIIIScaleFac = array[0..1] of record
    l: array[0..22] of integer;
    s: array[0..2, 0..12] of integer;  // [window][cb]
  end;

implementation

end.
