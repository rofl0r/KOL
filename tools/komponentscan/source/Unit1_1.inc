{ KOL MCK } // Do not remove this line!

procedure Newfrm_Scan( var Result: Pfrm_Scan; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Komponent Scan' ).SetPosition( 192, 107 ).SetSize( 181, 97 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.StayOnTop := True;
    Result.Form.IconLoad( hInstance, 'KOMPONEN.ICO' );

    Result.Timer1 := NewTimer( 50 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, 'Texto' ).SetPosition( -1, 50 ).SetSize( 45, 19 );
    Result.Label3.Font.FontWidth := 6;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Clase' ).SetPosition( 0, 4 ).SetSize( 45, 19 );
    Result.Label1.Font.FontWidth := 6;
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Handle' ).SetPosition( -1, 27 ).SetSize( 45, 19 );
    Result.Label2.Font.FontWidth := 6;
    // Result.Edit1.TabOrder = 0
    Result.Edit1 := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 46, 4 ).SetSize( 127, 18 );
    Result.Edit1.Color := clHighlightText;
    Result.Edit1.Font.FontWidth := 6;
    // Result.Edit2.TabOrder = 0
    Result.Edit2 := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 46, 27 ).SetSize( 127, 18 );
    Result.Edit2.Color := clHighlightText;
    Result.Edit2.Font.FontWidth := 6;
    // Result.Edit3.TabOrder = 0
    Result.Edit3 := NewEditBox( Result.Form, [ eoReadonly ] ).SetPosition( 46, 50 ).SetSize( 127, 18 );
    Result.Edit3.Color := clHighlightText;
    Result.Edit3.Font.FontWidth := 6;
    Result.Timer1.Enabled := True;

end;

