{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Test AES encrypt/decrypt' ).SetPosition( 192, 110 ).SetClientSize( 510, 146 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.Font.FontHeight := -11;
    Result.Form.Border := 0;

    Result.OpenDlg := NewOpenSaveDialog( '', '', [ OSFileMustExist, OSHideReadonly, OSPathMustExist ] );
  Result.Form.Add2AutoFree( Result.OpenDlg );
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, 'Encryption time' ).SetPosition( 12, 80 ).AutoSize( TRUE );
    // Result.Label6.TabOrder = -1
    Result.Label6 := NewLabel( Result.Form, '0 ms' ).SetPosition( 263, 80 ).AutoSize( TRUE );
    // Result.Label5.TabOrder = -1
    Result.Label5 := NewLabel( Result.Form, 'Decryption time' ).SetPosition( 180, 80 ).AutoSize( TRUE );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Password' ).SetPosition( 12, 45 ).AutoSize( TRUE );
    // Result.Label4.TabOrder = -1
    Result.Label4 := NewLabel( Result.Form, '0 ms' ).SetPosition( 95, 80 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Source file' ).SetPosition( 12, 16 ).AutoSize( TRUE );
    // Result.Edit1.TabOrder = 0
    Result.Edit1 := NewEditBox( Result.Form, [  ] ).SetPosition( 70, 13 ).SetSize( 335, 0 );
    Result.Edit1.Color := clWindow;
    // Result.Edit2.TabOrder = 0
    Result.Edit2 := NewEditBox( Result.Form, [  ] ).SetPosition( 70, 42 ).SetSize( 280, 0 );
    Result.Edit2.Color := clWindow;
    Result.Edit2.Text := 'Sample password';
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Browse...' ).SetPosition( 417, 13 );
    // Result.Button2.TabOrder = 2
    Result.Button2 := NewButton( Result.Form, 'Encrypt/Decrypt' ).SetPosition( 361, 42 ).SetSize( 120, 0 );
    // Result.Radio1.TabOrder = 3
    Result.Radio1 := NewRadioBox( Result.Form, '128 bit key' ).SetPosition( 12, 110 ).AutoSize( TRUE );
    Result.Radio1.SetRadioChecked;
    // Result.Radio2.TabOrder = 4
    Result.Radio2 := NewRadioBox( Result.Form, '192 bit key' ).SetPosition( 112, 110 ).AutoSize( TRUE );
    // Result.Radio3.TabOrder = 5
    Result.Radio3 := NewRadioBox( Result.Form, '256 bit key' ).SetPosition( 212, 110 ).AutoSize( TRUE );
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.OpenDlg.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CenterOnParent.CanResize := False;

end;

