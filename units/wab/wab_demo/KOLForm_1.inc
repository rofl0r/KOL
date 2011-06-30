{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 199, 175 ).SetSize( 604, 447 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.LB.TabOrder = 0
    Result.LB := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caLeft ).SetSize( 303, 0 );
    Result.LB.Color := clWindow;
    Result.LB.Font.FontHeight := 20;
    Result.LB.Font.FontName := 'Arial';
      Result.LB.OnClick := Result.LVChange;
      Result.LB.OnSelChange := Result.LVChange;
    Result.LB.CurIndex := 0;
    // Result.ME.TabOrder = 1
    Result.ME := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caClient );
    Result.ME.Color := clWindow;
    Result.ME.Font.FontHeight := 20;
    Result.ME.Font.FontName := 'Arial';
    Result.ME.CurIndex := 0;
    Result.KFFormCreate( Result );

end;


