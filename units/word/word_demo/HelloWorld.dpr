program HelloWorld;

uses
  KOL, KOLword;

//{$R *.RES}
var W: PWordDocument;

begin
  W := NewWordDocument;
  W.ObjName := 'Documents';
  W.ObjInvoke( 'Add', [], nil );
  W.ObjName := 'Selection';
  W.ObjInvoke( 'TypeText', [ sParam('Hello, Wor(L)d!') ], nil );
  W.Free;
end.
