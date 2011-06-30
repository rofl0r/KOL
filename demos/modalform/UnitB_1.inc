{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 228, 226 ).SetSize( 248, 188 );
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'ModalResult := 1;' ).SetPosition( 32, 24 ).SetSize( 181, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 0
    Result.Button2 := NewButton( Result.Form, 'ModalResult := 2;' ).SetPosition( 32, 56 ).SetSize( 181, 0 );
      Result.Button2.OnClick := Result.Button2Click;

end;

