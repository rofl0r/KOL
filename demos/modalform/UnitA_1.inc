{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 248, 120 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, '' ).SetPosition( 32, 56 ).AutoSize( TRUE );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Create and show Form2' ).SetPosition( 32, 19 ).SetSize( 176, 0 );
      Result.Button1.OnClick := Result.Button1Click;

end;


