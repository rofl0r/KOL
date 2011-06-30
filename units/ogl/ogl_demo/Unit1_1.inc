{ KOL MCK } // Do not remove this line!

procedure NewMain( var Result: PMain; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'OpenGL Sample' ).SetPosition( 303, 184 ).SetSize( 544, 375 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnPaint := Result.KOLForm1Paint;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    Result.KOLForm1FormCreate( Result );

end;

