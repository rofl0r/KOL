{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Create connection' ).SetPosition( 384, 341 ).SetSize( 280, 162 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.Font.FontHeight := 8;
    Result.Form.Font.FontPitch := fpVariable;
      Result.Form.OnClose := Result.ConnClose;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Port:' ).SetPosition( 56, 72 ).SetSize( 33, 0 );
    Result.Label1.TextAlign := taRight;
    Result.Label1.VerticalAlign := vaCenter;
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Host:' ).SetPosition( 56, 16 ).SetSize( 33, 0 );
    Result.Label2.TextAlign := taRight;
    Result.Label2.VerticalAlign := vaCenter;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Create' ).SetPosition( 56, 104 ).SetSize( 75, 25 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Cancel' ).SetPosition( 144, 104 ).SetSize( 75, 25 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.EditBox2.TabOrder = 2
    Result.EditBox2 := NewEditBox( Result.Form, [  ] ).SetPosition( 96, 16 ).SetSize( 113, 0 );
    Result.EditBox2.Color := clWindow;
    Result.EditBox2.Text := '127.0.0.1';
    // Result.EditBox1.TabOrder = 2
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 96, 72 ).SetSize( 113, 0 );
    Result.EditBox1.Color := clWindow;
    Result.EditBox1.Text := '1234';
    Result.ConnFormCreate( Result );

end;

