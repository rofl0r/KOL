{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 213, 165 );
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Form2.Show' ).SetPosition( 32, 64 ).SetSize( 137, 0 );
      Result.Button1.OnClick := Result.Button1Click;

end;

