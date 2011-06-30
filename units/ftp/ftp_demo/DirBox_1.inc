{ KOL MCK } // Do not remove this line!

procedure NewForm5( var Result: PForm5; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm5.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form5' ).SetPosition( 240, 235 ).SetClientSize( 400, 117).Tabulate;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.HasCaption := False;
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := 20;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
    Result.Form.Border := 10;
    // Result.P1.TabOrder = 0
    Result.P1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 55 );
    Result.P1.Color := clBtnFace;
    // Result.LE.TabOrder = -1
      Result.LE := NewLabelEffect( Result.P1, 'Create folder', 0 ).SetAlign ( caLeft ).SetSize( 170, 0 );
    Result.LE.Color := clBtnFace;
    Result.LE.TextAlign := taLeft;
    Result.LE.VerticalAlign := vaTop;
      Result.LE.Ctl3D := TRUE;
    // Result.EB.TabOrder = 0
      Result.EB := NewEditBox( Result.P1, [  ] ).SetAlign ( caClient );
    Result.EB.Color := clWindow;
    // Result.P2.TabOrder = 1
    Result.P2 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient );
    Result.P2.Color := clBtnFace;
    // Result.B1.TabOrder = 0
      Result.B1 := NewButton( Result.P2, 'OK' ).SetAlign ( caLeft ).SetSize( 170, 0 );
    // Result.B2.TabOrder = 1
      Result.B2 := NewButton( Result.P2, 'Cancel' ).SetAlign ( caClient );
      Result.B1.OnClick := Result.B1Click;
      Result.B2.OnClick := Result.B2Click;
    Result.Form.CanResize := False;

end;

