{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Demo' ).SetPosition( 192, 107 ).SetSize( 444, 310 );
  Result.Form.Add2AutoFree( Result );

    Result.PageSetupDialog1 := NewPageSetupDialog(Result.Form,[ psdMargins,psdOrientation,psdSamplePage,psdPaperControl,psdPrinterControl,psdHundredthsOfMillimeters,psdUseMargins,psdUseMinMargins]);
  Result.Form.Add2AutoFree( Result.PageSetupDialog1 );
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esLowered ).SetAlign ( caTop ).SetSize( 0, 55 );
    // Result.BitBtn1.TabOrder = 0
      Result.BitBtn1 := NewBitBtn( Result.Panel1, 'Print', [  ], glyphLeft, 0, 0 ).SetPosition( 15, 15 ).AutoSize( TRUE );
      Result.BitBtn1.OnClick := Result.BitBtn1Click;
      Result.BitBtn1.Flat := TRUE;
      Result.BitBtn1.TextShiftX := 1;
      Result.BitBtn1.TextShiftY := 1;
    // Result.Panel2.TabOrder = 1
    Result.Panel2 := NewPanel( Result.Form, esLowered ).SetAlign ( caClient );
    // Result.RichEdit1.TabOrder = 0
      Result.RichEdit1 := NewRichEdit( Result.Panel2, [ eoMultiline, eoNoHScroll, eoWantReturn ] ).SetAlign ( caClient );
    Result.RichEdit1.Color := clWindow;
      Result.RichEdit1.MaxTextSize := 2147483647;
    Result.KOLForm1FormCreate( Result );

end;

