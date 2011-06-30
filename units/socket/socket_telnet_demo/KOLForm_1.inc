{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Simple telnet' ).SetPosition( 195, 133 ).SetSize( 578, 417 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Transparent := True;
    Result.Form.SimpleStatusText := 'Disconnected';

    Result.MM := NewMenu( Result.Form, 0, [ 'File', '('
      , 'Connect	Alt+O', 'Disconnect	Alt+H', '-', 'Quit	Alt+X'
      , ')', '' ], nil );
    Result.MM.AssignEvents( 1, [ Result.MMN2Menu ] );
    Result.MM.ItemAccelerator[ 1 ] := MakeAccelerator( FVIRTKEY or FALT, $4F );
    Result.MM.ItemEnabled[ 2 ] := False;
    Result.MM.AssignEvents( 2, [ Result.MMN5Menu ] );
    Result.MM.ItemAccelerator[ 2 ] := MakeAccelerator( FVIRTKEY or FALT, $48 );
    Result.MM.AssignEvents( 3, [ Result.MMN4Menu ] );
    Result.MM.ItemAccelerator[ 3 ] := MakeAccelerator( FVIRTKEY or FALT, $58 );

    Result.CS := NewAsyncSocket;
    Result.CS.PortNumber := 23;
    Result.CS.IPAddress  := '127.0.0.1';
  Result.Form.Add2AutoFree( Result.CS );
      Result.CS.OnDestroy := Result.CSDestroy;
      Result.CS.OnConnect := Result.onConnect;
      Result.CS.OnRead := Result.onRead;
      Result.CS.OnClose := Result.onDisconnect;
      Result.CS.OnError := Result.onError;

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form1';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );
    // Result.Term.TabOrder = 0
    Result.Term := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll ] ).SetAlign ( caClient );
      Result.Term.Font.FontHeight := 16;
      Result.Term.Font.FontName := 'Courier New';
      Result.Term.OnChar := Result.TermChar;

end;

