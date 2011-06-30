{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 195, 133 ).SetSize( 404, 253 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.MM := NewMapMem( Result.Form );
    Result.MM.MapName     := 'Test-MAP';
    Result.MM.OpenMapWhen := omManual;
    Result.MM.MapStrings.Add('');
    Result.MM.MapStrings.Add('');
    Result.MM.MapStrings.Add('To check memory mapping ');
    Result.MM.MapStrings.Add('');
    Result.MM.MapStrings.Add('start another instance of this program');
    Result.MM.MapStrings.Add('');
    Result.MM.MapStrings.Add('and edit this text.');
    Result.MM.MapStrings.Add('');
    Result.MM.OpenMap;
    if Result.MM.ExistsAlready then Result.MM.ReadMap
    else Result.MM.WriteMap;
  Result.Form.Add2AutoFree( Result.MM );
      Result.MM.OnAppListChange := Result.MMAppListChange;
      Result.MM.OnUpdate := Result.MMUpdate;
    // Result.ME.TabOrder = 0
    Result.ME := NewEditBox( Result.Form, [ eoMultiline ] ).SetAlign ( caClient );
      Result.ME.OnChange := Result.MEChange;
    Result.ME.Text := ''+#13+#10;
    Result.KOLFormFormCreate( Result );

end;


