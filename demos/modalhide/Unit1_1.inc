{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 268, 239 );
  Result.Form.Add2AutoFree( Result );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, '' ).SetPosition( 56, 96 ).AutoSize( TRUE );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Show Form2 modal' ).SetPosition( 54, 56 ).SetSize( 153, 0 );
      Result.Button1.OnClick := Result.Button1Click;

end;

