{ KOL MCK } // Do not remove this line!

procedure NewForm7( var Result: PForm7; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm7.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Task Editor' ).SetPosition( 516, 247 ).SetClientSize( 489, 457 ).Tabulate;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := 18;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
    Result.Form.Border := 4;
      Result.Form.OnClose := Result.KFClose;
      Result.Form.OnShow := Result.KFShow;
      Result.Form.OnHide := Result.KFHide;

    Result.OD := NewOpenDirDialog( '', [ odOnlySystemDirs, odStatusText ] );
  Result.Form.Add2AutoFree( Result.OD );

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form7';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );
    // Result.CB.TabOrder = 0
    Result.CB := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 16, 16 ).SetSize( 137, 0 );
    Result.CB.CurIndex := 0;
    // Result.BN.TabOrder = 1
    Result.BN := NewButton( Result.Form, 'New' ).SetPosition( 176, 16 ).SetSize( 137, 0 );
    // Result.BE.TabOrder = 2
    Result.BE := NewButton( Result.Form, 'Edit' ).SetPosition( 336, 16 ).SetSize( 137, 0 );
    // Result.BD.TabOrder = 3
    Result.BD := NewButton( Result.Form, 'Delete' ).SetPosition( 176, 56 ).SetSize( 137, 0 );
    // Result.BC.TabOrder = 4
    Result.BC := NewButton( Result.Form, 'Close' ).SetPosition( 336, 56 ).SetSize( 137, 0 );
    // Result.P1.TabOrder = 5
    Result.P1 := NewPanel( Result.Form, esRaised ).SetAlign ( caBottom ).SetSize( 0, 366 );
    // Result.UL.TabOrder = -1
      Result.UL := NewLabelEffect( Result.P1, 'Upload updates', 1 ).SetPosition( 9, 285 ).SetSize( 181, 20 );
      Result.UL.Ctl3D := False;
    Result.UL.TextAlign := taLeft;
    Result.UL.VerticalAlign := vaTop;
    // Result.WL.TabOrder = -1
      Result.WL := NewLabelEffect( Result.P1, 'Wait connection', 1 ).SetPosition( 13, 325 ).SetSize( 161, 0 );
      Result.WL.Ctl3D := False;
    Result.WL.TextAlign := taLeft;
    Result.WL.VerticalAlign := vaTop;
    // Result.LS.TabOrder = -1
      Result.LS := NewLabelEffect( Result.P1, 'Remote Site', 1 ).SetPosition( 9, 21 ).SetSize( 217, 20 );
      Result.LS.Ctl3D := False;
    Result.LS.TextAlign := taLeft;
    // Result.EX.TabOrder = -1
      Result.EX := NewLabelEffect( Result.P1, 'Exclude Masks (divided by '';'')', 1 ).SetPosition( 9, 245 ).SetSize( 217, 20 );
      Result.EX.Ctl3D := False;
    Result.EX.TextAlign := taLeft;
    Result.EX.VerticalAlign := vaTop;
    // Result.LU.TabOrder = -1
      Result.LU := NewLabelEffect( Result.P1, 'Remote Path (relative)', 1 ).SetPosition( 9, 61 ).SetSize( 457, 20 );
      Result.LU.Ctl3D := False;
    Result.LU.TextAlign := taLeft;
    // Result.AL.TabOrder = -1
      Result.AL := NewLabelEffect( Result.P1, 'Active', 1 ).SetPosition( 242, 325 ).SetSize( 181, 20 );
      Result.AL.Ctl3D := False;
    Result.AL.TextAlign := taLeft;
    Result.AL.VerticalAlign := vaTop;
    // Result.LM.TabOrder = -1
      Result.LM := NewLabelEffect( Result.P1, 'Include Masks (divided by '';'')', 1 ).SetPosition( 9, 205 ).SetSize( 217, 20 );
      Result.LM.Ctl3D := False;
    Result.LM.TextAlign := taLeft;
    // Result.DL.TabOrder = -1
      Result.DL := NewLabelEffect( Result.P1, 'Download updates', 1 ).SetPosition( 241, 285 ).SetSize( 188, 20 );
      Result.DL.Ctl3D := False;
    Result.DL.TextAlign := taLeft;
    Result.DL.VerticalAlign := vaTop;
    // Result.LP.TabOrder = -1
      Result.LP := NewLabelEffect( Result.P1, 'Local Path', 1 ).SetPosition( 9, 133 ).SetSize( 457, 20 );
      Result.LP.Ctl3D := False;
    Result.LP.TextAlign := taLeft;
    // Result.ES.TabOrder = 0
      Result.ES := NewComboBox( Result.P1, [ coNoIntegralHeight ] ).SetPosition( 241, 21 ).SetSize( 225, 0 );
      Result.ES.CurIndex := 0;
    // Result.EU.TabOrder = 1
      Result.EU := NewEditBox( Result.P1, [  ] ).SetPosition( 9, 93 ).SetSize( 457, 0 );
      Result.EU.TextAlign := taCenter;
    // Result.EP.TabOrder = 2
      Result.EP := NewEditBox( Result.P1, [  ] ).SetPosition( 9, 165 ).SetSize( 457, 0 );
      Result.EP.TextAlign := taCenter;
    // Result.EM.TabOrder = 3
      Result.EM := NewEditBox( Result.P1, [  ] ).SetPosition( 241, 205 ).SetSize( 225, 0 );
      Result.EM.Text := '*.*';
    // Result.EB.TabOrder = 4
      Result.EB := NewEditBox( Result.P1, [  ] ).SetPosition( 241, 245 ).SetSize( 225, 0 );
    // Result.JU.TabOrder = 5
      Result.JU := NewCheckBox( Result.P1, '' ).SetPosition( 197, 285 ).AutoSize( TRUE );
    Result.JU.TabStop := FALSE;
    // Result.JD.TabOrder = 6
      Result.JD := NewCheckBox( Result.P1, '' ).SetPosition( 437, 285 ).AutoSize( TRUE );
    Result.JD.TabStop := FALSE;
    // Result.AB.TabOrder = 7
      Result.AB := NewCheckBox( Result.P1, '' ).SetPosition( 437, 325 ).AutoSize( TRUE );
    Result.AB.TabStop := FALSE;
      Result.AB.Checked := TRUE;
    // Result.WC.TabOrder = 8
      Result.WC := NewCheckBox( Result.P1, '' ).SetPosition( 197, 325 ).AutoSize( TRUE );
      Result.WC.Checked := TRUE;
    // Result.EE.TabOrder = 6
    Result.EE := NewEditBox( Result.Form, [  ] ).SetPosition( 16, 56 ).SetSize( 137, 0 );
      Result.CB.OnChange := Result.CBChange;
      Result.BN.OnClick := Result.BNClick;
      Result.BE.OnClick := Result.BEClick;
      Result.EP.OnMouseDblClk := Result.LPMouseDblClk;
      Result.BD.OnClick := Result.BDClick;
      Result.BC.OnClick := Result.BCClick;
      Result.EE.OnChange := Result.EEChange;
      Result.OD.WndOwner := Result.Form.GetWindowHandle;
    Result.KFFormCreate( Result );

end;

