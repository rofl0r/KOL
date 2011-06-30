{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm2.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 245, 272 ).SetClientSize( 206, 152 );
  Result.Form.Add2AutoFree( Result );
   {$IFDEF USE_NAMES}
    Result.Form.Name := 'Form2';
   {$ENDIF}
    Result.Form.Visible := False;
      Result.Form.OnClose := Result.KOLForm2Close;
      Result.Form.OnDestroy := Result.KOLForm2Destroy;
    // Result.CheckBox1.TabOrder = 0
    Result.CheckBox1 := NewCheckBox( Result.Form, 'Just Hide, not Close' ).SetPosition( 16, 16 ).SetSize( 177, 0 );
   {$IFDEF USE_NAMES}
    Result.CheckBox1.Name := 'CheckBox1';
   {$ENDIF}

end;

