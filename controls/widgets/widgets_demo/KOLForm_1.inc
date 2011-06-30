{ KOL MCK } // Do not remove this line!
const N1 = 0;
const N4 = 1;
const N5 = 2;
const N6 = 3;
const N2 = 4;
const N7 = 5;
const N8 = 6;
const N9 = 7;
const N3 = 8;
const N10 = 9;
const N11 = 10;
const N12 = 11;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 382, 203 ).SetSize( 292, 212 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.DoubleBuffered := True;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
    Result.Form.SimpleStatusText := 'abcdefghigklmnopqrstuvwxyz';
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.wg1 := NewWidGet( Result.Form );
    Result.wg1.OffsetLeft := -1;
    Result.wg1.OffsetTop  := -1;
    {$R Form1_wg1.res}
    Result.wg1.Image.LoadFromResourceName(hInstance, 'wg1_BITMAP');
    Result.wg1.Glyph      := 'm';
  Result.Form.Add2AutoFree( Result.wg1 );

    Result.wg2 := NewWidGet( Result.Form );
    Result.wg2.Font.Color := clRed;
    Result.wg2.Glyph      := 'g';
  Result.Form.Add2AutoFree( Result.wg2 );

    Result.wg3 := NewWidGet( Result.Form );
    Result.wg3.Glyph      := 'u';
  Result.Form.Add2AutoFree( Result.wg3 );

    Result.PMn := NewMenu( Result.Form, 0, [ '1', '(', '1', '2'
      , '3', ')', '2', '(', '4', '5', '6', ')', '3', '(', '7'
      , '8', '9', ')', '' ], nil );
    Result.wg3.PopupMenu := Result.PMn;
    Result.Form.MinimizeNormalAnimated;

end;


