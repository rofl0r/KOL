//////////////////////////////////////////////////
//						//
//						//
//		TKOLFlash v1.0			//
//						//
//	Author: Dimaxx (dimaxx@atnet.ru)	//
//						//
//						//
//////////////////////////////////////////////////
unit KOLFlash;

interface

uses KOL, Flash_TLB;

type
  TKOLFlash = PShockwaveFlash;
  PKOLFlash = PShockwaveFlash;

function NewKOLFlash(AOwner: PControl): PKOLFlash;

implementation

function NewKOLFlash;
begin
  New(Result,CreateParented(AOwner));
end;

end.

