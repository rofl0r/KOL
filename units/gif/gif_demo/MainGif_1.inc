{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 265, 233 ).SetSize( 442, 433 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.IconLoad( hInstance, 'MAINICON' );
    Result.Form.Font.FontCharset := 0;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.Timer1 := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;

    Result.OpenDirDialog1 := NewOpenDirDialog( '', [  ] );
  Result.Form.Add2AutoFree( Result.OpenDirDialog1 );
    // Result.PaintBox1.TabOrder = 0
    Result.PaintBox1 := NewPaintBox( Result.Form ).SetAlign ( caClient );
      Result.PaintBox1.OnPaint := Result.PaintBox1Paint;
    // Result.Panel1.TabOrder = 1
    Result.Panel1 := NewPanel( Result.Form, esNone ).SetAlign ( caTop ).SetSize( 0, 33 );
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.Panel1, '' ).SetPosition( 224, 6 ).SetSize( 83, 0 );
    Result.Label1.Font.Color := clRed;
    Result.Label1.Font.FontStyle := [ fsBold ];
    // Result.Label2.TabOrder = -1
      Result.Label2 := NewLabel( Result.Panel1, '' ).SetPosition( 320, 6 ).SetSize( 103, 0 );
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Panel1, 'Browse' ).SetPosition( 8, 6 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.BitBtn1.TabOrder = 1
      Result.BitBtn1 := NewBitBtn( Result.Panel1, '>', [  ], glyphLeft, 0, 0 ).SetPosition( 80, 6 ).SetSize( 27, 0 );
      Result.BitBtn1.OnClick := Result.Button2Click;
      Result.BitBtn1.TextShiftX := 1;
      Result.BitBtn1.TextShiftY := 1;
    // Result.CheckBox1.TabOrder = 2
      Result.CheckBox1 := NewCheckBox( Result.Panel1, 'Animate' ).SetPosition( 120, 6 ).SetSize( 89, 0 );
    Result.CheckBox1.TabStop := FALSE;
      Result.CheckBox1.OnClick := Result.CheckBox1Click;
      Result.CheckBox1.Checked := TRUE;
    // Result.ListBox1.TabOrder = 2
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caLeft );
      Result.ListBox1.OnSelChange := Result.ListBox1SelChange;
    Result.ListBox1.CurIndex := 0;
    // Result.Splitter1.TabOrder = 3
    Result.Splitter1 := NewSplitter( Result.Form, 0, 0 ).SetAlign ( caLeft );
      Result.OpenDirDialog1.WndOwner := Result.Form.GetWindowHandle;
    Result.KOLForm1FormCreate( Result );

end;


