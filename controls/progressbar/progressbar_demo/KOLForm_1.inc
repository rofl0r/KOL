{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 194, 175 ).SetSize( 351, 132 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontStyle := [ fsUnderline ];
    Result.Form.Font.FontHeight := 30;
    Result.Form.Font.FontCharset := 0;

    Result.TT := NewTimer( 100 );
  Result.Form.Add2AutoFree( Result.TT );
      Result.TT.OnTimer := Result.TTTimer;
    // Result.PB.TabOrder = 0
    Result.PB := NewColorProgressBar( Result.Form ).SetAlign ( caBottom ).SetSize( 0, 30 );
    Result.PB.Font.Color := clInfoBk;
    Result.PB.Font.FontStyle := [ fsBold, fsItalic ];
    Result.PB.Font.FontHeight := 18;
    Result.PB.Font.FontName := 'Arial';
    Result.PB.Caption  := 'Your text can be here';
    Result.PB.Position := 60;
    Result.PB.Border   := 5;
    Result.PB.BColor   := clBtnFace;
    // Result.P2.TabOrder = 1
    Result.P2 := NewColorProgressBar( Result.Form ).SetAlign ( caBottom ).SetSize( 0, 30 );
    Result.P2.Font.FontStyle := [ fsBold, fsItalic ];
    Result.P2.Font.FontHeight := 18;
    Result.P2.Font.FontName := 'Arial';
    Result.P2.BColor   := clBtnFace;
    Result.TT.Enabled := True;

end;


