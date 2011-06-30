{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 192, 114 ).SetClientSize( 262, 85 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Border := 0;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.Timer1 := NewTimer( 50 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;
    // Result.RarProgressBar1.TabOrder = 0
    Result.RarProgressBar1 := NewTRarProgressBar( Result.Form ).SetPosition( 29, 33 ).SetSize( 204, 18 );
    Result.RarProgressBar1.Position1 := 0;
    Result.RarProgressBar1.Position2 := 0;
    Result.RarProgressBar1.Min := 0;
    Result.RarProgressBar1.Max := 100;
    Result.RarProgressBar1.Double := True;
    Result.RarProgressBar1.LightColor1 := clWhite;
    Result.RarProgressBar1.LightColor2 := $C0FFFF;
    Result.RarProgressBar1.DarkColor := $606060;
    Result.RarProgressBar1.FrameColor1 := $EEE8E8;
    Result.RarProgressBar1.FrameColor2 := $B4D4E4;
    Result.RarProgressBar1.FillColor1 := $DCD6D6;
    Result.RarProgressBar1.FillColor2 := $A0C0D0;
    Result.RarProgressBar1.BackFrameColor1 := $9494B4;
    Result.RarProgressBar1.BackFrameColor2 := $80809E;
    Result.RarProgressBar1.BackFillColor := $6E6E94;
    Result.RarProgressBar1.ShadowColor := $464040;
    Result.Form.CenterOnParent.CanResize := False;

end;

