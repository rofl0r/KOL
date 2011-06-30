program Empty0;

uses KOL;

var F: PControl;

begin
  F := NewForm( nil, '' );
  Applet := F;
  Run( Applet );
end.
