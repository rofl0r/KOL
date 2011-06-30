(*
 *  File:     $RCSfile: CRC.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: CRC.pas,v 1.1.1.1 2002/04/21 12:57:16 fobmagog Exp $
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
unit KOLCRC;

interface

uses Kol;

const
  POLYNOMIAL: word = $8005;

type
  PCrc16 = ^Tcrc16;
  TCRC16 = object(Tobj)
  private
    FCRC: word;

  public
    //constructor Create;
    procedure AddBits(BitString: cardinal; Length: cardinal);
    function Checksum: word;
  end;

function NewCrc16: PCrc16;

implementation

{ TCRC16 }

// feed a bitstring to the crc calculation (0 < length <= 32)
procedure TCRC16.AddBits(BitString, Length: cardinal);
var 
  BitMask: cardinal;
begin
  BitMask := 1 shl (Length - 1);
  repeat
    if ((FCRC and $8000 = 0) xor (BitString and BitMask = 0)) then 
    begin
      FCRC := FCRC shl 1;
      FCRC := FCRC xor POLYNOMIAL;
    end 
    else
      FCRC := FCRC shl 1;

    BitMask := BitMask shr 1;
  until (BitMask = 0);
end;

// return the calculated checksum and erase it for next calls to add_bits()
function TCRC16.Checksum: word;
begin
  Result := FCRC;
  FCRC := $FFFF;
end;

function newcrc16: pcrc16;
begin
  New(Result, Create);
  Result.FCRC := $FFFF;
end;

end.
