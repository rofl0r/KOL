{ KOL MCK } // Do not remove this line!

procedure NewMain( var Result: PMain; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Main' ).SetPosition( 216, 114 ).SetSize( 363, 238 );
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Close' ).SetPosition( 272, 168 ).SetSize( 73, 25 );
    Result.Button1.Font.FontHeight := -10;
      Result.Button1.OnClick := Result.Button1Click;

end;

