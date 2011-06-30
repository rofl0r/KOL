{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewMDIChild( AParent, 'Form2' ).SetSize( 333, 223 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Border := 10;
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient );
    Result.Panel1.Border := 2;

end;

