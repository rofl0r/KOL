{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 195, 133 ).SetSize( 703, 559 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.KH := NewKOLHttpControl;
    Result.KH.Url       := '127.0.0.1';
  Result.Form.Add2AutoFree( Result.KH );
      Result.KH.OnClose := Result.KHClose;
    // Result.ME.TabOrder = 0
    Result.ME := NewEditBox( Result.Form, [ eoMultiline ] ).SetAlign ( caClient );
    Result.ME.Color := clWindow;
    Result.ME.Text := 'Memo1'+#13+#10;
    // Result.HD.TabOrder = 1
    Result.HD := NewEditBox( Result.Form, [ eoMultiline ] ).SetAlign ( caTop );
    Result.HD.Color := clWindow;
    Result.HD.Text := 'Memo1'+#13+#10;
    Result.KFFormCreate( Result );

end;


