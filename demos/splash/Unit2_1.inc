{ KOL MCK } // Do not remove this line!

procedure NewfmSplash( var Result: PfmSplash; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'fmSplash' ).SetPosition( 335, 236 ).SetSize( 342, 215 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.HasBorder := False;
    Result.Form.Color := clTeal ;
    Result.Form.Border := 0;
    // Result.LabelEffect1.TabOrder = -1
    Result.LabelEffect1 := NewLabelEffect( Result.Form, 'Splash form sample', 2 ).SetPosition( 60, 92 ).AutoSize( TRUE );
    Result.LabelEffect1.Ctl3D := False;
    Result.LabelEffect1.Font.Color := clWhite;
    Result.LabelEffect1.Font.FontStyle := [ fsBold ];
    Result.LabelEffect1.Font.FontHeight := 30;
    Result.LabelEffect1.TextAlign := taLeft;
    Result.LabelEffect1.VerticalAlign := vaTop;
    Result.LabelEffect1.Color2 := clBlack;

end;


