{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 496, 107 ).SetSize( 241, 239 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
      Result.Form.OnClose := Result.KOLForm1Close;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'ModalResult := 1;' ).SetPosition( 22, 48 ).SetSize( 193, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 0
    Result.Button2 := NewButton( Result.Form, 'ModalResult := 2;' ).SetPosition( 22, 96 ).SetSize( 193, 0 );
      Result.Button2.OnClick := Result.Button2Click;

end;

