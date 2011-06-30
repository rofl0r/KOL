{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 242, 203 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Button1' ).SetPosition( 8, 16 );
    // Result.BitBtn1.TabOrder = 1
    Result.BitBtn1 := NewBitBtn( Result.Form, 'Example of word wrap BitBtn control', [  ], glyphLeft, 0, 0 ).SetPosition( 88, 16 ).SetSize( 105, 89 );
    Result.BitBtn1.TextShiftX := 1;
    Result.BitBtn1.TextShiftY := 1;
    Result.KOLForm1FormCreate( Result );

end;

