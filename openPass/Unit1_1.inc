{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Открой Пароль V' ).SetPosition( 192, 107 ).SetSize( 269, 108 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.IconLoad( hInstance, 'ZFORM1_MHABOUTDIALOG1' );

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ '&Справка'
      , '(', '&О программе...', ')', '' ], nil );
    Result.MainMenu1.AssignEvents( 1, [ Result.KOLForm1N2Menu ] );

    Result.Timer1 := NewTimer( 1 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;


    Result.MHAboutDialog1:=NewMHAboutDialog();
    Result.MHAboutDialog1.Title:='О программе "Открой Пароль"';
    Result.MHAboutDialog1.CopyRight:='CopyRight 1984-2002 MacroHard Corp.';
    Result.MHAboutDialog1.Text:='Открой Пароль';
    Result.MHAboutDialog1.Icon:=LoadIcon(hInstance,'ZFORM1_MHABOUTDIALOG1');
      {$R Form1_MHAboutDialog1.RES}
    Result.MHAboutDialog1.IconType:=itApplication;
  Result.Form.Add2AutoFree( Result.MHAboutDialog1 );

    Result.MHXP1 := NewMHXP( 'MacroHard Corp. OpenPass' );
      {$R XP.RES}
  Result.Form.Add2AutoFree( Result.MHXP1 );
    // Result.CopyRightL.TabOrder = -1
    Result.CopyRightL := NewLabel( Result.Form, 'CopyRight 1984-2001 MacroHard Corp.' ).SetPosition( 74, 41 ).SetSize( 193, 13 );
    Result.CopyRightL.Font.Color := clBlue;
    Result.CopyRightL.Font.FontHeight := -11;
    // Result.PassEd.TabOrder = 0
    Result.PassEd := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 10, 10 ).SetSize( 241, 21 );
    Result.PassEd.Color := clWindow;
    Result.PassEd.Font.FontHeight := -11;
    Result.Timer1.Enabled := True;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );

end;

