{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 358, 278 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 53 );
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Panel1, 'Add Frame' ).SetPosition( 21, 13 ).SetSize( 129, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
      Result.Button2 := NewButton( Result.Panel1, 'Remove Frame' ).SetPosition( 165, 13 ).SetSize( 145, 0 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Panel2.TabOrder = 1
    Result.Panel2 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient );

end;

