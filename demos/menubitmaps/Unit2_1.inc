{ KOL MCK } // Do not remove this line!
const miFaces = 0;
const miKind = 1;
const miMore = 2;
const miFoots = 3;
const N1 = 4;
const N2 = 5;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 253, 125 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ 'Faces', '('
      , 'Kind', 'More', ')', 'Foots', '(', '111', '222', ')'
      , '' ], nil );
    Result.MainMenu1.Items[ 1 ].OwnerDraw := TRUE;
      Result.MainMenu1.OnMeasureItem := Result.MainMenu1MeasureItem;
      Result.MainMenu1.OnDrawItem := Result.MainMenu1DrawItem;
    Result.KOLForm1FormCreate( Result );

end;


