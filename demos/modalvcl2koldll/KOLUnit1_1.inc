{ KOL MCK } // Do not remove this line!

procedure NewKOLForm1( var Result: PKOLForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm1' ).SetPosition( 254, 243 ).SetSize( 255, 251 );
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Close' ).SetPosition( 64, 80 ).SetSize( 121, 0 );
      Result.Button1.OnClick := Result.Button1Click;

end;


