{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 371, 300 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ 'Item1', '('
      , 'Create MDI child', ')', 'Item2', '(', 'Tile', 'Cascade'
      , ')', '' ], nil );
    Result.MainMenu1.AssignEvents( 1, [ Result.MainMenu1N5Menu ] );
    Result.MainMenu1.AssignEvents( 3, [ Result.MainMenu1N3Menu ] );
    Result.MainMenu1.AssignEvents( 4, [ Result.MainMenu1N4Menu ] );
    // Result.MDIClient1.TabOrder = 0
    Result.MDIClient1 := NewMDIClient( Result.Form, Result.MainMenu1.ItemHandle[ 4 ] ).SetAlign ( caClient );

end;


