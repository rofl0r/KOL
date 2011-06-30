{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 192, 124 ).SetClientSize( 475, 281 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Border := 6;
    // Result.RichEdit1.TabOrder = 0
    Result.RichEdit1 := NewRichEdit( Result.Form, [ eoMultiline ] ).SetAlign ( caClient );
    Result.RichEdit1.Color := clWindow;
    // Result.Panel1.TabOrder = 3
    Result.Panel1 := NewPanel( Result.Form, esLowered ).SetAlign ( caBottom ).SetSize( 0, 38 );
    Result.Panel1.Border := 2;
    // Result.Test1.TabOrder = 1
      Result.Test1 := NewButton( Result.Panel1, 'Test1' ).SetPosition( 7, 7 ).SetSize( 137, 0 );
    // Result.Button1.TabOrder = 2
      Result.Button1 := NewButton( Result.Panel1, 'Test2' ).SetPosition( 151, 7 ).SetSize( 137, 0 );
      Result.Test1.OnClick := Result.Test1Click;
      Result.Button1.OnClick := Result.Button1Click;
    Result.Form.CenterOnParent;

end;

