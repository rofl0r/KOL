{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 201, 122 ).SetClientSize( 402, 200 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Label1' ).SetPosition( 8, 16 );
    Result.Label1.Font.FontHeight := -12;
    // Result.btLookup.TabOrder = 0
    Result.btLookup := NewButton( Result.Form, 'Button1' ).SetPosition( 176, 8 );
    Result.btLookup.Font.FontHeight := -12;
    // Result.edDomain.TabOrder = 1
    Result.edDomain := NewEditBox( Result.Form, [  ] ).SetPosition( 72, 8 );
    Result.edDomain.Color := clWindow;
    Result.edDomain.Font.FontHeight := -12;
    Result.edDomain.Text := 'INTERNIC.NET';
    // Result.meResults.TabOrder = 2
    Result.meResults := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 8, 40 ).SetSize( 385, 145 );
    Result.meResults.Color := clWindow;
    Result.meResults.Font.FontHeight := -12;
      Result.btLookup.OnClick := Result.btLookupClickClick;
      Result.edDomain.OnKeyDown := Result.edDomainKeyDown;
    Result.KOLForm1FormCreate( Result );

end;

