(*
 *  File:     $RCSfile: Shared.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: Shared.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
 *  Author:   $Author: fobmagog $
 *  Homepage: http://delphimpeg.sourceforge.net
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
unit KolShared;

interface

const
  OBUFFERSIZE = 2 * 1152;  // max. 2 * 1152 samples per frame
  MAX_CHANNELS = 2;         // max. number of channels


type
  PSingleArray = ^TSingleArray;
  TSingleArray = array[0..1024] of single;
  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of byte;

  TChannels = (Both, Left, Right, Downmix);

implementation

end.
