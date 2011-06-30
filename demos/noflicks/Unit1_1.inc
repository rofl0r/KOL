{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 292, 211 );
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Test with flick' ).SetPosition( 16, 16 ).SetSize( 249, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 0
    Result.Button2 := NewButton( Result.Form, 'Test with no flick' ).SetPosition( 16, 56 ).SetSize( 249, 0 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetPosition( 16, 96 ).SetSize( 249, 28 );

end;

