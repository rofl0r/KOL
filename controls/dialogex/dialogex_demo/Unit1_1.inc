{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 243, 106 ).SetSize( 783, 540 );
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Button1' ).SetPosition( 72, 72 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Button2' ).SetPosition( 72, 112 );
      Result.Button2.OnClick := Result.Button2Click;

end;

