{ KOL MCK } // Do not remove this line!

procedure NewOptionsForm( var Result: POptionsForm; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'OptionsForm' ).SetPosition( 369, 311 ).SetSize( 497, 306 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
      Result.Form.OnClose := Result.KOLForm2Close;
      Result.Form.OnDestroy := Result.KOLForm2Destroy;
    // Result.CheckBox1.TabOrder = 0
    Result.CheckBox1 := NewCheckBox( Result.Form, 'Just Hide, not Close' ).SetPosition( 16, 32 ).SetSize( 177, 0 );

end;

