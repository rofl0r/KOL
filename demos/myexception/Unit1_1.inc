{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 222, 177 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Test raise exception' ).SetPosition( 24, 24 ).SetSize( 161, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Test zerodivide' ).SetPosition( 24, 56 ).SetSize( 161, 0 );
      Result.Button2.OnClick := Result.Button2Click;

end;

