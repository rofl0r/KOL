(*
 *  File:     $RCSfile: SubBand.pas,v $
 *  Revision: $Revision: 1.1.1.1 $
 *  Version : $Id: SubBand.pas,v 1.1.1.1 2002/04/21 12:57:22 fobmagog Exp $
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
unit KolSubBand;

interface

uses
  Windows, kol, kolBitStream, kolHeader, kolCRC, kolSynthFilter, kolShared;

type
  PSubband = ^TSubband;
  TSubBand = object(Tobj)
  public
    procedure ReadAllocation(Stream: PBitStream; Header: PHeader; CRC: PCRC16); virtual;
    procedure ReadScaleFactor(Stream: PBitStream; Header: PHeader); virtual;
    function ReadSampleData(Stream: PBitStream): boolean; virtual;
    function PutNextSample(Channels: TChannels;
      Filter1, Filter2: PSynthesisFilter): boolean; virtual;
  end;

implementation

{ TSubBand }

function TSubBand.PutNextSample(Channels: TChannels; Filter1,
  Filter2: PSynthesisFilter): boolean;
begin
end;

procedure TSubBand.ReadAllocation(Stream: PBitStream; Header: PHeader;
  CRC: PCRC16);
begin
end;

function TSubBand.ReadSampleData(Stream: PBitStream): boolean;
begin
end;

procedure TSubBand.ReadScaleFactor(Stream: PBitStream; Header: PHeader);
begin
end;

end.
