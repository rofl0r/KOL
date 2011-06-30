{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 200, 135 ).SetSize( 208, 227 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnPaint := Result.KOLForm1Paint;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    Result.KOLForm1FormCreate( Result );

end;

