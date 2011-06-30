{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 434, 309 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    // Result.ListBox1.TabOrder = 0
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caLeft ).SetSize( 177, 0 );
      Result.ListBox1.OnSelChange := Result.ListBox1SelChange;
    Result.ListBox1.CurIndex := 0;
    // Result.PaintBox1.TabOrder = 1
    Result.PaintBox1 := NewPaintBox( Result.Form ).SetAlign ( caClient );
      Result.PaintBox1.OnMouseDblClk := Result.PaintBox1MouseDblClk;
      Result.PaintBox1.OnPaint := Result.PaintBox1Paint;
    Result.KOLForm1FormCreate( Result );

end;

