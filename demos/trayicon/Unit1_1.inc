{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 399, 276 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.TrayIcon1 := NewTrayIcon( Applet, LoadIcon( hInstance, 'ZFORM1_TRAYICON1' ) );
      {$R Form1_TrayIcon1.RES}
  Result.Form.Add2AutoFree( Result.TrayIcon1 );
    Result.TrayIcon1.Active := TRUE;

end;

