{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 228, 377 ).SetSize( 441, 291 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetPosition( 8, 8 );

end;

