{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetClientSize( 205, 138 );
  Result.Form.Add2AutoFree( Result );
   {$IFDEF USE_NAMES}
    Result.Form.Name := 'Form1';
   {$ENDIF}
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Form2.Show' ).SetPosition( 32, 64 ).SetSize( 137, 0 );
   {$IFDEF USE_NAMES}
    Result.Button1.Name := 'Button1';
   {$ENDIF}
      Result.Button1.OnClick := Result.Button1Click;

end;

