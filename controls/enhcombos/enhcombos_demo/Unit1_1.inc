{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Demo' ).SetPosition( 192, 129 ).SetSize( 440, 338 ).Tabulate;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 57 );
    // Result.FontComboBox1.TabOrder = 0
      Result.FontComboBox1 := NewFontComboBox( Result.Panel1 ).SetPosition( 21, 13 ).SetSize( 153, 17 );
      Result.FontComboBox1.OnChange := Result.FontComboBox1Change;
    // Result.ColorComboBox1.TabOrder = 1
      Result.ColorComboBox1 := NewColorComboBox( Result.Panel1 ).SetPosition( 205, 13 ).SetSize( 130, 18 );
      Result.ColorComboBox1.OnChange := Result.ColorComboBox1Change;
    // Result.RichEdit1.TabOrder = 1
    Result.RichEdit1 := NewRichEdit( Result.Form, [ eoMultiline ] ).SetAlign ( caClient );
    Result.RichEdit1.Color := clWindow;
      Result.RichEdit1.OnSelChange := Result.RichEdit1SelChange;
    Result.KOLForm1FormCreate( Result );

end;


