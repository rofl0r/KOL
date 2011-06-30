{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewCPLApplet;
  Result.Add2AutoFree(Result.Form);
{$R cplApplet_0.res}
Result.Form.AddIcon('cplApplet_0','Applet 0','This is TKOLApplet 0','testhlp.hlp',0,0);
{$R cplApplet_1.res}
Result.Form.AddIcon('cplApplet_1','Applet 1','This is TKOLApplet 1','test.hlp',0,1);
  Result.Form.OnStart := Result.KOLCPLApplet1Start;
  Result.Form.OnExecute := Result.KOLCPLApplet1Execute;
  Result.Form.OnSelect := Result.KOLCPLApplet1Select;
  Result.Form.OnStop    := Result.KOLCPLApplet1Stop;
  Result.Form.OnInit    := Result.KOLCPLApplet1Init;

end;

