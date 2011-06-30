{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 399, 276 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.TrayIcon1 := NewTrayIcon( Applet, LoadIcon( hInstance, 'ZFORM1_TRAYICON1' ) );
    Result.TrayIcon1.Tooltip := 'Right mouse click to close DemoTrayOnly';
      {$R Form1_TrayIcon1.RES}
  Result.Form.Add2AutoFree( Result.TrayIcon1 );
      Result.TrayIcon1.OnMouse := Result.TrayIcon1Mouse;

    Result.PopupMenu1 := NewMenu( Result.Form, 0, [ 
      'Minimize me', 'Close me', '' ], nil );
    Result.PopupMenu1.AssignEvents( 0, [ Result.PopupMenu1N2Menu ] );
    Result.PopupMenu1.AssignEvents( 1, [ Result.PopupMenu1N1Menu ] );
    Result.TrayIcon1.Active := TRUE;

end;

