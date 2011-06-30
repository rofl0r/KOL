{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Second Form' ).SetPosition( 480, 311 ).SetSize( 239, 227 );
  Result.Form.Add2AutoFree( Result );

    Result.WG1 := NewWidGet( Result.Form );
    Result.WG1.Glyph      := 'u';
    Result.WG1.Font.Color := clRed;
  Result.Form.Add2AutoFree( Result.WG1 );

    Result.WG2 := NewWidGet( Result.Form );
    Result.WG2.Glyph      := 't';
    Result.WG2.Font.Color := clBlue;
  Result.Form.Add2AutoFree( Result.WG2 );

    Result.WG3 := NewWidGet( Result.Form );
    Result.WG3.Glyph      := 'v';
    {$R Form2_WG3.res}
    Result.WG3.Image.LoadFromResourceName(hInstance, 'WG3_BITMAP');
  Result.Form.Add2AutoFree( Result.WG3 );

end;

