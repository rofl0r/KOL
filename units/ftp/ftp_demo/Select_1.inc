{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm2.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Select remote site' ).SetPosition( 254, 221 ).SetClientSize( 403, 273 ).Tabulate;
  Result.Form.Add2AutoFree( Result );
    Result.Form.SizeGrip := FALSE;
    Result.Form.Visible := False;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := 18;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
      Result.Form.OnClose := Result.KFClose;
      Result.Form.OnShow := Result.KFShow;
      Result.Form.OnHide := Result.KFHide;

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form2';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );
    // Result.P1.TabOrder = 0
    Result.P1 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient );
    Result.P1.DoubleBuffered := True;
    // Result.CB.TabOrder = 0
      Result.CB := NewComboBox( Result.P1, [ coReadOnly, coNoIntegralHeight, coSort ] ).SetPosition( 5, 13 ).SetSize( 137, 0 );
      Result.CB.DoubleBuffered := True;
      Result.CB.CurIndex := 0;
    // Result.EB.TabOrder = 1
      Result.EB := NewButton( Result.P1, 'Edit' ).SetPosition( 5, 54 ).SetSize( 137, 0 );
      Result.EB.DoubleBuffered := True;
    // Result.NB.TabOrder = 2
      Result.NB := NewButton( Result.P1, 'New entry' ).SetPosition( 5, 98 ).SetSize( 137, 0 );
      Result.NB.DoubleBuffered := True;
    // Result.DB.TabOrder = 3
      Result.DB := NewButton( Result.P1, 'Delete' ).SetPosition( 5, 142 ).SetSize( 137, 0 );
      Result.DB.DoubleBuffered := True;
    // Result.CO.TabOrder = 4
      Result.CO := NewButton( Result.P1, 'Connect' ).SetPosition( 5, 186 ).SetSize( 137, 0 );
      Result.CO.DoubleBuffered := True;
    // Result.XB.TabOrder = 5
      Result.XB := NewButton( Result.P1, 'Close' ).SetPosition( 5, 229 ).SetSize( 137, 0 );
      Result.XB.DoubleBuffered := True;
    // Result.P2.TabOrder = 6
      Result.P2 := NewPanel( Result.P1, esRaised ).SetPosition( 157, 5 ).SetSize( 233, 257 );
      Result.P2.DoubleBuffered := True;
    // Result.UL.TabOrder = -1
        Result.UL := NewLabelEffect( Result.P2, 'User', 1 ).SetPosition( 13, 85 ).SetSize( 201, 20 );
        Result.UL.Ctl3D := False;
    Result.UL.TextAlign := taLeft;
    Result.UL.VerticalAlign := vaTop;
        Result.UL.DoubleBuffered := True;
    // Result.NL.TabOrder = -1
        Result.NL := NewLabelEffect( Result.P2, 'Port', 1 ).SetPosition( 13, 189 ).SetSize( 97, 20 );
        Result.NL.Ctl3D := False;
    Result.NL.TextAlign := taLeft;
    Result.NL.VerticalAlign := vaTop;
        Result.NL.DoubleBuffered := True;
    // Result.PL.TabOrder = -1
        Result.PL := NewLabelEffect( Result.P2, 'Password', 1 ).SetPosition( 13, 133 ).SetSize( 201, 20 );
        Result.PL.Ctl3D := False;
    Result.PL.TextAlign := taLeft;
    Result.PL.VerticalAlign := vaTop;
        Result.PL.DoubleBuffered := True;
    // Result.ML.TabOrder = -1
        Result.ML := NewLabelEffect( Result.P2, 'Passive mode', 1 ).SetPosition( 13, 221 ).AutoSize( TRUE );
        Result.ML.Ctl3D := False;
    Result.ML.TextAlign := taLeft;
    Result.ML.VerticalAlign := vaTop;
    // Result.SL.TabOrder = -1
        Result.SL := NewLabelEffect( Result.P2, 'FTP site address', 1 ).SetPosition( 13, 37 ).SetSize( 201, 20 );
        Result.SL.Ctl3D := False;
    Result.SL.TextAlign := taLeft;
    Result.SL.VerticalAlign := vaTop;
        Result.SL.DoubleBuffered := True;
    // Result.EE.TabOrder = 0
        Result.EE := NewEditBox( Result.P2, [  ] ).SetPosition( 13, 5 ).SetSize( 201, 0 );
        Result.EE.Enabled := False;
    // Result.SE.TabOrder = 1
        Result.SE := NewEditBox( Result.P2, [  ] ).SetPosition( 13, 61 ).SetSize( 201, 0 );
        Result.SE.Enabled := False;
        Result.SE.DoubleBuffered := True;
    // Result.UE.TabOrder = 2
        Result.UE := NewEditBox( Result.P2, [  ] ).SetPosition( 13, 109 ).SetSize( 201, 0 );
        Result.UE.Enabled := False;
        Result.UE.DoubleBuffered := True;
    // Result.PE.TabOrder = 3
        Result.PE := NewEditBox( Result.P2, [  ] ).SetPosition( 13, 157 ).SetSize( 201, 0 );
        Result.PE.Enabled := False;
        Result.PE.DoubleBuffered := True;
    // Result.NE.TabOrder = 4
        Result.NE := NewEditBox( Result.P2, [  ] ).SetPosition( 117, 189 ).SetSize( 97, 0 );
        Result.NE.Enabled := False;
        Result.NE.DoubleBuffered := True;
        Result.NE.Text := '21';
    // Result.ME.TabOrder = 5
        Result.ME := NewCheckBox( Result.P2, '' ).SetPosition( 197, 221 ).SetSize( 20, 0 );
      Result.EE.OnChange := Result.EEChange;
      Result.CB.OnChange := Result.CBChange;
      Result.EB.OnClick := Result.EBClick;
      Result.NB.OnClick := Result.NBClick;
      Result.DB.OnClick := Result.DBClick;
      Result.CO.OnClick := Result.COClick;
      Result.XB.OnClick := Result.XBClick;
    Result.KFFormCreate( Result );

end;


