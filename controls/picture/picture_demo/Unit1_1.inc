{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Autorun' ).SetPosition( 224, 148 ).SetSize( 201, 260 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.HasBorder := False;
    Result.Form.Ctl3D := False;
    Result.Form.Color := clWindow;
    Result.Form.Border := 0;
    // Result.SPLPicture1.TabOrder = 0
{$R Form1_SPLPicture1.RES}
    Result.SPLPicture1 := PSPLPicture( NewSPLPicture( Result.Form, esNone ).SetAlign ( caClient ) );
    Result.SPLPicture1.Border := 2;
      Result.SPLPicture1.OnMessage := Result.SPLPicture1Message;
      Result.SPLPicture1.OnMouseMove := Result.SPLPicture1MouseMove;
    // Result.Label4.TabOrder = -1
      Result.Label4 := NewLabel( Result.SPLPicture1, '' ).SetPosition( 181, 4 ).SetSize( 13, 13 );
      Result.Label4.Transparent := True;
      Result.Label4.OnMouseMove := Result.Label4MouseMove;
      Result.Label4.OnMouseUp := Result.Label4MouseUp;
    // Result.Label2.TabOrder = -1
      Result.Label2 := NewLabel( Result.SPLPicture1, '' ).SetPosition( 38, 198 ).SetSize( 122, 17 );
      Result.Label2.Cursor := LoadCursor( 0, IDC_HAND );
      Result.Label2.Transparent := True;
      Result.Label2.OnMouseMove := Result.Label2MouseMove;
      Result.Label2.OnMouseUp := Result.Label2MouseUp;
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.SPLPicture1, '' ).SetPosition( 49, 176 ).SetSize( 103, 19 );
      Result.Label1.Cursor := LoadCursor( 0, IDC_HAND );
      Result.Label1.Transparent := True;
      Result.Label1.OnMouseMove := Result.Label1MouseMove;
      Result.Label1.OnMouseUp := Result.Label1MouseUp;
    // Result.Label3.TabOrder = -1
      Result.Label3 := NewLabel( Result.SPLPicture1, '' ).SetPosition( 20, 28 ).SetSize( 151, 77 );
      Result.Label3.Cursor := LoadCursor( 0, IDC_HAND );
      Result.Label3.Transparent := True;
      Result.Label3.OnMouseMove := Result.Label3MouseMove;
      Result.Label3.OnMouseUp := Result.Label3MouseUp;
    // Result.Label5.TabOrder = -1
      Result.Label5 := NewLabel( Result.SPLPicture1, 'Label5' ).SetPosition( 4, 3 ).SetSize( 177, 12 );
    Result.Label5.Font.FontHeight := 11;
    Result.Label5.Font.FontName := 'Small Fonts';
    Result.Label5.TextAlign := taCenter;
      Result.Label5.Transparent := True;
      Result.Label5.OnMessage := Result.SPLPicture1Message;
      Result.Label5.OnMouseMove := Result.SPLPicture1MouseMove;
    // Result.SPLPicture2.TabOrder = 0
{$R Form1_SPLPicture2.RES}
      Result.SPLPicture2 := PSPLPicture( NewSPLPicture( Result.SPLPicture1, esNone ).SetPosition( 49, 176 ).SetSize( 103, 19 ) );
      Result.SPLPicture2.Visible := False;
    // Result.SPLPicture3.TabOrder = 1
{$R Form1_SPLPicture3.RES}
      Result.SPLPicture3 := PSPLPicture( NewSPLPicture( Result.SPLPicture1, esNone ).SetPosition( 38, 198 ).SetSize( 122, 17 ) );
      Result.SPLPicture3.Visible := False;
    // Result.SPLPicture4.TabOrder = 2
{$R Form1_SPLPicture4.RES}
      Result.SPLPicture4 := PSPLPicture( NewSPLPicture( Result.SPLPicture1, esNone ).SetPosition( 20, 28 ).SetSize( 151, 77 ) );
      Result.SPLPicture4.Visible := False;
    // Result.SPLPicture5.TabOrder = 3
{$R Form1_SPLPicture5.RES}
      Result.SPLPicture5 := PSPLPicture( NewSPLPicture( Result.SPLPicture1, esNone ).SetPosition( 181, 4 ).SetSize( 13, 13 ) );
      Result.SPLPicture5.Visible := False;
    Result.SPLPicture2.Bitmap.LoadFromResourceName( hInstance, 'FORM1_SPLPICTURE2BMP' );
    Result.SPLPicture1.Bitmap.LoadFromResourceName( hInstance, 'FORM1_SPLPICTURE1BMP' );
    Result.SPLPicture3.Bitmap.LoadFromResourceName( hInstance, 'FORM1_SPLPICTURE3BMP' );
    Result.SPLPicture4.Bitmap.LoadFromResourceName( hInstance, 'FORM1_SPLPICTURE4BMP' );
    Result.SPLPicture5.Bitmap.LoadFromResourceName( hInstance, 'FORM1_SPLPICTURE5BMP' );
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;


