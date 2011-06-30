{ KOL MCK } // Do not remove this line!

procedure NewSvForm( var Result: PSvForm; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, '' ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.DoubleBuffered := True;
      Result.Form.Font.FontHeight := 16;
      Result.Form.Font.FontName := 'Arial';
      Result.Form.OnResize := Result.KFResize;

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'SvForm';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );
    // Result.P1.TabOrder = 0
    Result.P1 := NewPanel( Result.Form, esRaised ).SetAlign ( caLeft ).SetSize( 150, 0 );
    // Result.LB1.TabOrder = 0
      Result.LB1 := NewListBox( Result.P1, [ loNoIntegralHeight ] ).SetAlign ( caClient );
      Result.LB1.OnClick := Result.LB1Click;
      Result.LB1.OnKeyDown := Result.LB1KeyDown;
      Result.LB1.OnSelChange := Result.LB1Click;
      Result.LB1.CurIndex := 0;
    // Result.LBG.TabOrder = 1
      Result.LBG := NewListBox( Result.P1, [ loNoIntegralHeight ] ).SetAlign ( caBottom ).SetSize( 0, 299 );
      Result.LBG.OnEnter := Result.LBGEnter;
      Result.LBG.CurIndex := 0;
    // Result.SP.TabOrder = 2
      Result.SP := NewSplitter( Result.P1, 0, 0 ).SetPosition( -3, 246 ).SetSize( 329, 0 );
    // Result.P2.TabOrder = 1
    Result.P2 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient );
    // Result.LB2.TabOrder = 0
      Result.LB2 := NewListBox( Result.P2, [ loNoIntegralHeight ] ).SetAlign ( caLeft ).SetSize( 201, 0 );
      Result.LB2.OnEnter := Result.LB2Enter;
      Result.LB2.CurIndex := 0;
    // Result.LB3.TabOrder = 1
      Result.LB3 := NewListBox( Result.P2, [ loNoIntegralHeight ] ).SetAlign ( caClient );
      Result.LB3.CurIndex := 0;
    // Result.B2.TabOrder = 2
    Result.B2 := NewButton( Result.Form, '<----------' ).SetAlign ( caBottom );
      Result.B2.OnClick := Result.B2Click;
    // Result.B1.TabOrder = 3
    Result.B1 := NewButton( Result.Form, '---------->' ).SetAlign ( caBottom );
      Result.B1.OnClick := Result.B1Click;
    Result.Form.CenterOnParent;
    Result.FormCreate( Result );

end;


