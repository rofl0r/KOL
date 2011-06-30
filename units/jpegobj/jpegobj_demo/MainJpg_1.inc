{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 371, 336 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    // Result.PaintBox1.TabOrder = 0
    Result.PaintBox1 := NewPaintBox( Result.Form ).SetAlign ( caClient );
      Result.PaintBox1.OnPaint := Result.PaintBox1Paint;
    // Result.ListBox1.TabOrder = 1
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caLeft );
      Result.ListBox1.OnSelChange := Result.ListBox1SelChange;
    Result.ListBox1.CurIndex := 0;
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 41 );
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.Panel1, '' ).SetPosition( 187, 5 ).SetSize( 123, 0 );
    Result.KOLForm1FormCreate( Result );

end;

