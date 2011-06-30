{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PMainForm.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'GliphLabel Demo' ).SetPosition( 322, 100 ).SetClientSize( 414, 463 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.Timer := NewTimer( 500 );
  Result.Form.Add2AutoFree( Result.Timer );
      Result.Timer.OnTimer := Result.TimerTimer;
    // Result.mdvGliphLabel_Time.TabOrder = 0
    {$R MainForm_mdvGliphLabel_Time.res}
    Result.mdvGliphLabel_Time := PmdvGliphLabel( NewmdvGliphLabel( Result.Form, '', '0123456789:-', True, $00000000, LoadBmp( hInstance, 'MDVGLIPHLABEL_TIME_BITMAP', Result ) ).SetPosition( 122, 31 ).SetSize( 181, 29 ));
    Result.mdvGliphLabel_Time.Color := clBlack;
    Result.mdvGliphLabel_Time.TextAlign := taCenter;
    Result.mdvGliphLabel_Time.VerticalAlign := vaCenter;
    Result.mdvGliphLabel_Time.DoubleBuffered := True;
    // Result.mdvGliphLabel_Date.TabOrder = 0
    Result.mdvGliphLabel_Date := PmdvGliphLabel( NewmdvGliphLabel( Result.Form, '', '0123456789:-', True, $00000000, 0 ).SetPosition( 122, 60 ).SetSize( 181, 29 ));
    Result.mdvGliphLabel_Date.Color := clBlack;
    Result.mdvGliphLabel_Date.TextAlign := taCenter;
    Result.mdvGliphLabel_Date.VerticalAlign := vaCenter;
    Result.mdvGliphLabel_Date.DoubleBuffered := True;
    // Result.cbTransparent.TabOrder = 1
    Result.cbTransparent := NewCheckBox( Result.Form, 'Transparent' ).SetPosition( 260, 324 ).SetSize( 101, 0 );
    Result.cbTransparent.Font.FontHeight := -11;
    // Result.mdvGliphLabel.TabOrder = 2
    Result.mdvGliphLabel := PmdvGliphLabel( NewmdvGliphLabel( Result.Form, '091272', '0123456789:-', True, $00000000, 0 ).SetPosition( 52, 160 ).SetSize( 309, 121 ));
    Result.mdvGliphLabel.Color := clNavy;
    // Result.EditBox.TabOrder = 2
    Result.EditBox := NewEditBox( Result.Form, [ eoNumber ] ).SetPosition( 52, 288 ).SetSize( 309, 0 );
    Result.EditBox.Color := clWindow;
    Result.EditBox.Text := '091272';
    // Result.cbTransparentLabel.TabOrder = 3
    Result.cbTransparentLabel := NewCheckBox( Result.Form, 'TransparentLabel' ).SetPosition( 260, 352 ).SetSize( 137, 0 );
    Result.cbTransparentLabel.Font.FontHeight := -11;
    Result.cbTransparentLabel.Checked := TRUE;
    // Result.TextAlign.TabOrder = 8
    Result.TextAlign := NewGroupBox( Result.Form, 'TextAlign' ).SetPosition( 52, 316 ).SetSize( 89, 97 );
    Result.TextAlign.TabStop := FALSE;
    Result.TextAlign.Font.FontHeight := 10;
    // Result.otaCenter.TabOrder = 0
      Result.otaCenter := NewRadioBox( Result.TextAlign, 'taCenter' ).SetPosition( 8, 40 ).SetSize( 74, 0 );
      Result.otaCenter.Tag := 2;
    // Result.otaRight.TabOrder = 1
      Result.otaRight := NewRadioBox( Result.TextAlign, 'taRight' ).SetPosition( 8, 64 ).SetSize( 71, 0 );
      Result.otaRight.Tag := 1;
    // Result.otaLeft.TabOrder = 2
      Result.otaLeft := NewRadioBox( Result.TextAlign, 'taLeft' ).SetPosition( 8, 16 );
      Result.otaLeft.SetRadioChecked;
    // Result.VerticalAlign.TabOrder = 8
    Result.VerticalAlign := NewGroupBox( Result.Form, 'VerticalAlign' ).SetPosition( 156, 316 ).SetSize( 89, 97 );
    Result.VerticalAlign.TabStop := FALSE;
    Result.VerticalAlign.Font.FontHeight := 10;
    // Result.ovaBottom.TabOrder = 0
      Result.ovaBottom := NewRadioBox( Result.VerticalAlign, 'vaBottom' ).SetPosition( 8, 64 ).SetSize( 78, 0 );
      Result.ovaBottom.Tag := 2;
    // Result.ovaCenter.TabOrder = 1
      Result.ovaCenter := NewRadioBox( Result.VerticalAlign, 'vaCenter' ).SetPosition( 8, 40 ).SetSize( 77, 0 );
      Result.ovaCenter.Tag := 1;
    // Result.ovaTop.TabOrder = 2
      Result.ovaTop := NewRadioBox( Result.VerticalAlign, 'vaTop' ).SetPosition( 8, 16 );
      Result.ovaTop.SetRadioChecked;
      Result.ovaBottom.OnClick := Result.ovaClick;
      Result.otaCenter.OnClick := Result.otaClick;
      Result.ovaCenter.OnClick := Result.ovaClick;
      Result.cbTransparent.OnClick := Result.cbTransparentClick;
      Result.otaRight.OnClick := Result.otaClick;
      Result.ovaTop.OnClick := Result.ovaClick;
      Result.otaLeft.OnClick := Result.otaClick;
      Result.EditBox.OnChange := Result.EditBoxChange;
      Result.cbTransparentLabel.OnClick := Result.cbTransparentLabelClick;
    Result.Timer.Enabled := True;
    Result.KOLFormFormCreate( Result );

end;

