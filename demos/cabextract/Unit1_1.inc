{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Demo cabinet file extraction' ).SetPosition( 246, 107 ).SetSize( 469, 179 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.OpenSaveDialog1 := NewOpenSaveDialog( 'Select Cabinet file to extract', '', [  ] );
      Result.OpenSaveDialog1.Filter := 'Cabinet files (*.cab)|*.cab';
      Result.OpenSaveDialog1.DefExtension := 'cab';
  Result.Form.Add2AutoFree( Result.OpenSaveDialog1 );

    Result.OpenDirDialog1 := NewOpenDirDialog( 'Select directory to unpack files', [  ] );
      Result.OpenDirDialog1.CenterOnScreen := TRUE;
  Result.Form.Add2AutoFree( Result.OpenDirDialog1 );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Destination' ).SetPosition( 16, 64 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Source' ).SetPosition( 16, 8 ).AutoSize( TRUE );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Browse' ).SetPosition( 352, 32 ).SetSize( 89, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Browse' ).SetPosition( 352, 88 ).SetSize( 89, 0 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Button3.TabOrder = 2
    Result.Button3 := NewButton( Result.Form, 'Extract' ).SetPosition( 16, 120 ).SetSize( 105, 0 );
    Result.Button3.Enabled := False;
      Result.Button3.OnClick := Result.Button3Click;
    // Result.Button4.TabOrder = 3
    Result.Button4 := NewButton( Result.Form, 'Open target folder' ).SetPosition( 136, 120 ).SetSize( 209, 0 );
    Result.Button4.Enabled := False;
      Result.Button4.OnClick := Result.Button4Click;
    // Result.EditBox1.TabOrder = 4
    Result.EditBox1 := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 16, 32 ).SetSize( 329, 0 );
    Result.EditBox1.TabStop := FALSE;
      Result.EditBox1.OnChange := Result.EditChange;
    // Result.EditBox2.TabOrder = 5
    Result.EditBox2 := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 16, 88 ).SetSize( 329, 0 );
    Result.EditBox2.TabStop := FALSE;
      Result.EditBox2.OnChange := Result.EditChange;
    Result.KOLForm1FormCreate( Result );

end;

