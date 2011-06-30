{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Demo' ).SetPosition( 192, 114 ).SetSize( 365, 145 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnShow := Result.KOLForm1Show;
    // Result.InfoLabel.TabOrder = -1
    Result.InfoLabel := NewLabel( Result.Form, '&Disconnect' ).SetPosition( 24, 32 ).AutoSize( TRUE );
    Result.InfoLabel.Font.FontHeight := -12;
    // Result.DisconnectButton.TabOrder = 0
    Result.DisconnectButton := NewButton( Result.Form, '&Disconnect' ).SetPosition( 24, 56 );
    Result.DisconnectButton.Font.FontHeight := -12;
      Result.DisconnectButton.OnClick := Result.DisconnectButtonClick;
    Result.KOLForm1FormCreate( Result );

end;


