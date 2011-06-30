//////////////////////////////////////////////////////////////////
//								//
//								//
//			TKOLCDWriter v1.0			//
//								//
//	ActiveX: Vision Factory	(www.vision-factory.com)	//
//	Converted: Dimaxx (dimaxx@atnet.ru)			//
//								//
//								//
//////////////////////////////////////////////////////////////////
unit KOLCDWriter;

interface

uses Kol, CDWriter_TLB;

type
  TKOLCDWriter = PCDWriter;
  PKOLCDWriter = PCDWriter;

function NewCDWriter(AOwner: PControl): PCDWriter;

implementation

function NewCDWriter(AOwner: PControl): PCDWriter;
begin
  New(Result,CreateParented(AOwner));
end;

end.

