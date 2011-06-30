{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'ToolTip example' ).SetPosition( 253, 114 ).SetSize( 465, 194 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Button1' ).SetPosition( 24, 56 ).SetSize( 177, 33 );
    Result.Button1.IgnoreDefault := FALSE;
    // Result.EditBox1.TabOrder = 1
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 224, 56 ).SetSize( 185, 33 );
    Result.EditBox1.Color := clWindow;
    Result.EditBox1.Text := 'EditBox1';
    Result.KOLForm1FormCreate( Result );

end;


