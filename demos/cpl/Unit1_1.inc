{ KOL MCK } // Do not remove this line!

procedure NewMain( var Result: PMain; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'CplSample' ).SetPosition( 147, 107 ).SetSize( 421, 276 );
  Result.Form.Add2AutoFree( Result );
    // Result.BitBtn1.TabOrder = 1
    Result.BitBtn1 := NewBitBtn( Result.Form, 'Close', [  ], glyphLeft, 0, 0 ).SetPosition( 352, 224 ).AutoSize( TRUE );
    Result.BitBtn1.Font.FontHeight := 8;
    Result.BitBtn1.OnClick := Result.BitBtn1Click;
    Result.Form.CenterOnParent.CanResize := False;

end;

