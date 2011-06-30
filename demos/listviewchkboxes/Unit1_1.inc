{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 507, 362 ).SetSize( 268, 270 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontCharset := 0;

    Result.ImageList1 := NewImageList( Result.Form );
    Result.ImageList1.Colors := ilcColor4;
      Result.ImageList1.ImgWidth := 15;
      Result.ImageList1.ImgHeight := 15;
      {$R Form1_ImageList1.res}
    Result.ImageList1.AddMasked( LoadBitmap( hInstance, 'FORM1_IMAGELIST1' ), clMaroon );
  Result.Form.Add2AutoFree( Result.ImageList1 );

    Result.Timer1 := NewTimer( 100 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;
    // Result.ListView1.TabOrder = 0
    Result.ListView1 := NewListView( Result.Form, lvsDetail, [ lvoGridLines, lvoRowSelect ], Result.ImageList1, nil, nil ).SetPosition( 8, 8 ).SetSize( 241, 201 );
    Result.ListView1.Color := clWindow;
      Result.ListView1.OnMouseDown := Result.ListView1MouseDown;
      Result.ListView1.OnKeyDown := Result.ListView1KeyDown;
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esLowered ).SetPosition( 8, 216 ).SetSize( 241, 24 );
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Panel1, 'Demonstrate' ).SetPosition( 1, 0 ).SetSize( 238, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );

end;

