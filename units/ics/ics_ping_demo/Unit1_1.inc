{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'PingDemo' ).SetPosition( 192, 114 ).SetSize( 335, 217 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Host' ).SetPosition( 24, 24 );
    Result.Label1.Font.FontHeight := -12;
    // Result.HostEdit.TabOrder = 0
    Result.HostEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 88, 24 );
    Result.HostEdit.Color := clWindow;
    Result.HostEdit.Font.FontHeight := -12;
    Result.HostEdit.Text := 'localhost';
    // Result.DisplayMemo.TabOrder = 1
    Result.DisplayMemo := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 16, 48 ).SetSize( 305, 129 );
    Result.DisplayMemo.Color := clWindow;
    Result.DisplayMemo.Font.FontHeight := -12;
    // Result.PingButton.TabOrder = 2
    Result.PingButton := NewButton( Result.Form, 'Ping' ).SetPosition( 192, 24 );
    Result.PingButton.Font.FontHeight := -12;
    // Result.CancelButton.TabOrder = 3
    Result.CancelButton := NewButton( Result.Form, 'Cancel' ).SetPosition( 256, 24 );
    Result.CancelButton.Font.FontHeight := -12;
      Result.PingButton.OnClick := Result.PingButtonClick;
      Result.CancelButton.OnClick := Result.CancelButtonClick;
    Result.KOLForm1FormCreate( Result );

end;

