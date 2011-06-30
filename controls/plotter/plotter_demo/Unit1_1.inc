{ KOL MCK } // Do not remove this line!
const N1 = 0;
const N2 = 1;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.CreateParented( Applet );
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 285, 232 ).SetSize( 696, 449 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.PM := NewMenu( Result.Form, 0, [ 'Zoom In'
      , 'Zoom Out', '' ], nil );
    Result.PM.AssignEvents( 0, [ Result.PMN1Menu ] );
    Result.PM.AssignEvents( 1, [ Result.PMN2Menu ] );

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form1';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );
    // Result.P1.TabOrder = 0
    Result.P1 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient );
    // Result.PL.TabOrder = 0
      Result.PL := NewPlotter( Result.P1 ).SetAlign ( caClient );
    Result.PL.Color := clGreen;
      Result.PL.Formula      := 'sin(0.6*x)/(1.7+cos(x^2))';
      Result.PL.minY         := -4;
      Result.PL.maxY         := 4;
      Result.PL.Step         := 0.005;
      Result.PL.Pen.Color    := clWhite;
      Result.PL.Pen.PenWidth := 0;
      Result.PL.SetAutoPopupMenu(Result.PM);
    // Result.P2.TabOrder = 1
    Result.P2 := NewPanel( Result.Form, esRaised ).SetAlign ( caBottom ).SetSize( 0, 54 );
    Result.P2.TextAlign := taCenter;
    Result.P2.VerticalAlign := vaCenter;
    Result.P2.Border := 10;
    Result.P2.Caption := 'Caption';
    // Result.L1.TabOrder = -1
      Result.L1 := NewLabel( Result.P2, 'f(x)=' ).SetAlign ( caLeft ).AutoSize( TRUE );
    Result.L1.VerticalAlign := vaCenter;
    // Result.EB.TabOrder = 0
      Result.EB := NewEditBox( Result.P2, [  ] ).SetAlign ( caClient );
    Result.EB.Color := clWindow;
      Result.EB.Text := 'sin(0.6*x)/(1.7+cos(x^2))';
      Result.EB.OnLeave := Result.EBLeave;
      Result.EB.OnKeyDown := Result.EBKeyDown;
      Result.PL.OnMouseDown := Result.PLMouseDown;
      Result.PL.OnMouseMove := Result.PLMouseMove;
      Result.PL.OnMouseUp := Result.PLMouseUp;
      Result.PL.OnDestroy := Result.PLDestroy;

end;


