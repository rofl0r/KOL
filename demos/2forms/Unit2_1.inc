{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 245, 272 ).SetSize( 214, 179 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
      Result.Form.OnClose := Result.KOLForm2Close;
      Result.Form.OnDestroy := Result.KOLForm2Destroy;
    // Result.CheckBox1.TabOrder = 0
    Result.CheckBox1 := NewCheckBox( Result.Form, 'Just Hide, not Close' ).SetPosition( 16, 16 ).SetSize( 177, 0 );

end;

