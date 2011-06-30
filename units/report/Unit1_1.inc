{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 223, 106 ).SetSize( 527, 271 );
  Result.Form.Add2AutoFree( Result );
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetPosition( 8, 8 ).SetSize( 505, 233 );
    Result.Panel1.Color := clBtnFace;
    // Result.Button3.TabOrder = 0
      Result.Button3 := NewButton( Result.Panel1, 'Test3, Most Complex' ).SetPosition( 13, 53 ).SetSize( 193, 0 );
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button3.OnMouseDown := Result.Button3MouseDown;
    // Result.Button2.TabOrder = 0
      Result.Button2 := NewButton( Result.Panel1, 'Test2' ).SetPosition( 109, 13 ).SetSize( 89, 0 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Panel1, 'Test1' ).SetPosition( 13, 13 ).SetSize( 89, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.BandBig.TabOrder = 1
      Result.BandBig := NewBand( Result.Panel1, [frLeft,frTop,frRight,frBottom] ).SetPosition( 101, 81 ).SetSize( 397, 141 );
    Result.BandBig.Color := clWhite;
    Result.BandBig.Font.Color := clBlack;
    Result.BandBig.Font.FontStyle := [ fsBold ];
    Result.BandBig.Font.FontHeight := 60;
    Result.BandBig.Font.FontName := 'Arial';
    Result.BandBig.TextAlign := taCenter;
    Result.BandBig.VerticalAlign := vaCenter;
      Result.BandBig.Border := 1;
      Result.BandBig.Caption := 'Big Band';

end;


