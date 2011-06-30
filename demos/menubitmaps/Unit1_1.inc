{ KOL MCK } // Do not remove this line!
const mi1Faces = 0;
const mi1Kind = 1;
const mi1Eyes = 2;
const mi1Hands = 3;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 229, 248 ).SetSize( 320, 208 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ 'Faces', '('
      , 'Kind', ')', 'Eyes', 'Hands', '' ], nil );
    Result.MainMenu1.ItemBitmap[ 1 ] := LoadBmp( hInstance, 'FORM1_MI1KIND_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mi1Kind_BMP.res}
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Resize menu bitmap' ).SetPosition( 16, 16 ).SetSize( 201, 0 );
      Result.Button1.OnClick := Result.Button1Click;

end;


