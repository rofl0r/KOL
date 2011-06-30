{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Ping-It!' ).SetPosition( 126, 41 ).SetClientSize( 417, 150 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.btnPing.TabOrder = 0
    Result.btnPing := NewButton( Result.Form, 'Ping' ).SetPosition( 344, 8 );
    Result.btnPing.Font.FontHeight := 12;
    // Result.lstReplies.TabOrder = 1
    Result.lstReplies := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetPosition( 8, 32 ).SetSize( 401, 105 );
    Result.lstReplies.Font.FontHeight := 12;
    Result.lstReplies.CurIndex := 0;
    // Result.edtHost.TabOrder = 2
    Result.edtHost := NewEditBox( Result.Form, [  ] ).SetPosition( 8, 8 ).SetSize( 329, 0 );
    Result.edtHost.Font.FontHeight := 12;
    Result.edtHost.Text := '127.0.0.1';
      Result.btnPing.OnClick := Result.btnPingClick;
    Result.lstReplies.Color := clWindow;
    Result.edtHost.Color := clWindow;
    Result.KOLForm1FormCreate( Result );

end;

