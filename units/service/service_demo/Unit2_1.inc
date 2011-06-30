{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm2.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 388, 488 ).SetClientSize( 178, 125 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontCharset := 0;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Label1' ).SetPosition( 16, 56 ).SetSize( 137, 0 );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, '' ).SetPosition( 16, 96 ).SetSize( 137, 0 );
    Result.KOLForm1FormCreate( Result );

end;

