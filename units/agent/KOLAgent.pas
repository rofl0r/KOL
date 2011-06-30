//////////////////////////////////////////////////
//						//
//						//
//		TKOLAgent v1.0			//
//						//
//	Author: Dimaxx (dimaxx@atnet.ru)	//
//						//
//						//
//////////////////////////////////////////////////
unit KOLAgent;

interface

uses KOL, Agent_TLB;

type
  TKOLAgent = Agent_TLB.PAgent;
  PKOLAgent = Agent_TLB.PAgent;

function NewKOLAgent(AOwner: PControl): PKOLAgent;

implementation

function NewKOLAgent;
begin
  New(Result,CreateParented(AOwner));
end;

end.
