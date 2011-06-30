{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PMainForm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Panel Demo' ).SetPosition( 228, 102 ).SetClientSize( 414, 463 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'BevelWidth' ).SetPosition( 48, 429 );
    Result.Label1.Font.FontHeight := 10;
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'BorderWidth' ).SetPosition( 48, 402 );
    Result.Label2.Font.FontHeight := 10;
    // Result.MHUpDown2.TabOrder = 1
    Result.MHUpDown2 := PMHUpDown( NewMHUpDown( Result.Form, udVertical, False, False, False, False, False,True,udRight ));
    Result.MHUpDown2.Max:=100;
    Result.MHUpDown2.Min:=0;
    // Result.mdvPanel.TabOrder = 2
    Result.mdvPanel := PmdvPanel( NewmdvPanel( Result.Form, bvRaised, bvLowered, 4, bsNone, 3 ).SetPosition( 46, 22 ).SetSize( 315, 295 ));
    Result.mdvPanel.TextAlign := taCenter;
    Result.mdvPanel.VerticalAlign := vaCenter;
    Result.mdvPanel.Border := 11;
    Result.mdvPanel.Transparent := True;
    Result.mdvPanel.Caption := 'mdvPanel';
    // Result.MHUpDown1.TabOrder = 3
    Result.MHUpDown1 := PMHUpDown( NewMHUpDown( Result.Form, udVertical, False, False, False, False, False,True,udRight ));
    Result.MHUpDown1.Max:=100;
    Result.MHUpDown1.Min:=0;
    // Result.BorderStyle.TabOrder = 4
    Result.BorderStyle := NewGroupBox( Result.Form, 'BorderStyle' ).SetPosition( 48, 328 ).SetSize( 113, 65 );
    Result.BorderStyle.TabStop := FALSE;
    Result.BorderStyle.Font.FontHeight := 10;
    // Result.rbsNone.TabOrder = 0
      Result.rbsNone := NewRadioBox( Result.BorderStyle, 'bsNone' ).SetPosition( 8, 16 );
      Result.rbsNone.SetRadioChecked;
    // Result.rbsSingle.TabOrder = 0
      Result.rbsSingle := NewRadioBox( Result.BorderStyle, 'bsSingle' ).SetPosition( 8, 40 );
      Result.rbsSingle.Tag := 1;
    // Result.eBorderWidth.TabOrder = 5
    Result.eBorderWidth := NewEditBox( Result.Form, [  ] ).SetPosition( 112, 400 ).SetSize( 34, 0 );
    Result.eBorderWidth.Color := clWindow;
    Result.eBorderWidth.Font.FontHeight := 10;
    Result.eBorderWidth.Text := '3';
    // Result.eBevelWidth.TabOrder = 6
    Result.eBevelWidth := NewEditBox( Result.Form, [  ] ).SetPosition( 112, 427 ).SetSize( 34, 0 );
    Result.eBevelWidth.Color := clWindow;
    Result.eBevelWidth.Font.FontHeight := 10;
    Result.eBevelWidth.Text := '4';
    // Result.GroupBox1.TabOrder = 7
    Result.GroupBox1 := NewGroupBox( Result.Form, 'BevelInner' ).SetPosition( 272, 328 ).SetSize( 89, 121 );
    Result.GroupBox1.TabStop := FALSE;
    Result.GroupBox1.Font.FontHeight := 10;
    // Result.ibvRaised.TabOrder = 0
      Result.ibvRaised := NewRadioBox( Result.GroupBox1, 'bvRaised' ).SetPosition( 8, 64 );
      Result.ibvRaised.Tag := 2;
    // Result.ibvLowered.TabOrder = 0
      Result.ibvLowered := NewRadioBox( Result.GroupBox1, 'bvLowered' ).SetPosition( 8, 40 );
      Result.ibvLowered.Tag := 1;
      Result.ibvLowered.SetRadioChecked;
    // Result.ibvNone.TabOrder = 0
      Result.ibvNone := NewRadioBox( Result.GroupBox1, 'bvNone' ).SetPosition( 8, 16 );
    // Result.ibvSpace.TabOrder = 0
      Result.ibvSpace := NewRadioBox( Result.GroupBox1, 'bvSpace' ).SetPosition( 8, 88 );
      Result.ibvSpace.Tag := 3;
    // Result.BevelOuter.TabOrder = 8
    Result.BevelOuter := NewGroupBox( Result.Form, 'BevelOuter' ).SetPosition( 176, 328 ).SetSize( 89, 121 );
    Result.BevelOuter.TabStop := FALSE;
    Result.BevelOuter.Font.FontHeight := 10;
    // Result.obvRaised.TabOrder = 0
      Result.obvRaised := NewRadioBox( Result.BevelOuter, 'bvRaised' ).SetPosition( 8, 64 );
      Result.obvRaised.Tag := 2;
      Result.obvRaised.SetRadioChecked;
    // Result.obvLowered.TabOrder = 0
      Result.obvLowered := NewRadioBox( Result.BevelOuter, 'bvLowered' ).SetPosition( 8, 40 );
      Result.obvLowered.Tag := 1;
    // Result.obvNone.TabOrder = 0
      Result.obvNone := NewRadioBox( Result.BevelOuter, 'bvNone' ).SetPosition( 8, 16 );
    // Result.obvSpace.TabOrder = 0
      Result.obvSpace := NewRadioBox( Result.BevelOuter, 'bvSpace' ).SetPosition( 8, 88 );
      Result.obvSpace.Tag := 3;
      Result.obvLowered.OnClick := Result.obvNoneClick;
      Result.obvSpace.OnClick := Result.obvNoneClick;
      Result.obvRaised.OnClick := Result.obvNoneClick;
      Result.rbsSingle.OnClick := Result.rbsNoneClick;
      Result.ibvLowered.OnClick := Result.ibvNoneClick;
      Result.ibvSpace.OnClick := Result.ibvNoneClick;
      Result.ibvRaised.OnClick := Result.ibvNoneClick;
      Result.ibvNone.OnClick := Result.ibvNoneClick;
      Result.obvNone.OnClick := Result.obvNoneClick;
      Result.rbsNone.OnClick := Result.rbsNoneClick;
    Result.MHUpDown2.Buddy:=Result.eBevelWidth.GetWindowHandle;
    Result.MHUpDown2.SetPosition( 146, 427 );
    Result.MHUpDown2.Height := 22;
    Result.eBevelWidth.Width := 34;
    Result.MHUpDown2.Width := 15;
    Result.MHUpDown1.Buddy:=Result.eBorderWidth.GetWindowHandle;
    Result.MHUpDown1.SetPosition( 146, 400 );
    Result.MHUpDown1.Height := 22;
    Result.eBorderWidth.Width := 34;
    Result.MHUpDown1.Width := 15;
      Result.eBorderWidth.OnChange := Result.eBorderWidthChange;
      Result.eBevelWidth.OnChange := Result.eBevelWidthChange;

end;

