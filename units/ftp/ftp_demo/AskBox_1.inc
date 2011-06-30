{ KOL MCK } // Do not remove this line!

procedure NewForm4( var Result: PForm4; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm4.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form4' ).SetPosition( 217, 220 ).SetClientSize( 532, 57).Tabulate;
  Result.Form.Add2AutoFree( Result );
    Result.Form.SizeGrip := FALSE;
    Result.Form.Visible := False;
    Result.Form.DoubleBuffered := True;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.AlphaBlend := 250;
    Result.Form.HasCaption := False;
    Result.Form.Color := clTeal;
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := 18;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
    DeleteMenu( GetSystemMenu( Result.Form.GetWindowHandle, False ), SC_CLOSE, MF_BYCOMMAND );
      Result.Form.OnResize := Result.KFResize;
    // Result.B1.TabOrder = 0
    Result.B1 := NewButton( Result.Form, 'Overwrite' ).SetPosition( 16, 48 ).SetSize( 100, 0 ).LikeSpeedButton;
    Result.B1.DoubleBuffered := True;
    // Result.B2.TabOrder = 1
    Result.B2 := NewButton( Result.Form, 'Append' ).SetPosition( 216, 48 ).SetSize( 100, 0 ).LikeSpeedButton;
    Result.B2.DoubleBuffered := True;
    // Result.B3.TabOrder = 2
    Result.B3 := NewButton( Result.Form, 'Cancel' ).SetPosition( 414, 48 ).SetSize( 100, 0 ).LikeSpeedButton;
    Result.B3.DoubleBuffered := True;
    // Result.LE.TabOrder = 3
    Result.LE := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 16, 8 ).SetSize( 497, 26 );
    Result.LE.TabStop := FALSE;
    Result.LE.Font.Color := clWindow;
    Result.LE.Text := 'EditBox1';
      Result.B1.OnClick := Result.B1Click;
      Result.B2.OnClick := Result.B2Click;
      Result.B3.OnClick := Result.B3Click;
    Result.Form.CanResize := False;

end;

