{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'MainForm' ).SetPosition( 245, 162 ).SetSize( 450, 414 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.IconLoad( hInstance, 'MAINICON' );
    Result.Form.Font.FontHeight := -10;

    Result.Timer1 := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;

    Result.MHXP1 := NewMHXP( 'Organization.Division.Name' );
      {$R XP.RES}
  Result.Form.Add2AutoFree( Result.MHXP1 );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Form2.Show' ).SetPosition( 168, 8 ).SetSize( 137, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Panel3.TabOrder = 1
    Result.Panel3 := NewPanel( Result.Form, esLowered ).SetPosition( 8, 64 ).SetSize( 425, 313 );
      Result.Panel3.OnPaint := Result.Panel3Paint;
    // Result.Panel2.TabOrder = 3
    Result.Panel2 := NewPanel( Result.Form, esLowered ).SetPosition( 8, 8 ).SetSize( 145, 49 );
      Result.Panel2.OnClick := Result.Panel2Click;
    Result.Timer1.Enabled := True;
    Result.KOLForm1FormCreate( Result );

end;


