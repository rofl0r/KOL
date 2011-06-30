{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Configure connection' ).SetPosition( 244, 207 ).SetSize( 296, 177 ).PreventResizeFlicks;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.DoubleBuffered := True;
    Result.Form.HasCaption := False;
    Result.Form.Color := clSilver ;
      Result.Form.Font.FontStyle := [ fsBold ]; 
      Result.Form.Font.FontHeight := 20;
      Result.Form.Font.FontName := 'Arial';
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabelEffect( Result.Form, 'Address', 1 ).SetPosition( 8, 48 ).SetSize( 273, 0 );
    Result.Label2.Transparent := True;
    Result.Label2.Ctl3D := TRUE;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabelEffect( Result.Form, 'Port number', 1 ).SetPosition( 8, 24 ).SetSize( 137, 25 );
    Result.Label1.TextAlign := taCenter;
    Result.Label1.Ctl3D := TRUE;
    // Result.EditBox1.TabOrder = 0
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 152, 24 ).SetSize( 129, 24 );
    Result.EditBox1.Text := '23';
    // Result.EditBox2.TabOrder = 1
    Result.EditBox2 := NewEditBox( Result.Form, [  ] ).SetPosition( 8, 88 ).SetSize( 273, 24 );
    Result.EditBox2.Text := '127.0.0.1';
    // Result.Button1.TabOrder = 2
    Result.Button1 := NewButton( Result.Form, 'Connect' ).SetPosition( 8, 128 ).SetSize( 129, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button3.TabOrder = 4
    Result.Button3 := NewButton( Result.Form, 'Close' ).SetPosition( 152, 128 ).SetSize( 129, 0 );
      Result.Button3.OnClick := Result.Button3Click;
    Result.Form.CanResize := False;

end;

