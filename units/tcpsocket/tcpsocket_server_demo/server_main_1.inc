{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'TCP Server' ).SetPosition( 329, 242 ).SetSize( 351, 266 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := 8;
    Result.Form.Font.FontPitch := fpVariable;
    Result.Form.Border := 0;

    Result.Server:=newtcpserver;
    Result.Server.port:=1234;
  Result.Form.Add2AutoFree( Result.Server );
      Result.Server.OnAccept := Result.ServerAccept;
      Result.Server.OnError := Result.ServerError;
      Result.Server.OnClientError := Result.ServerClientError;
      Result.Server.OnClientDisconnect := Result.ServerClientDisconnect;
      Result.Server.OnClientReceive := Result.ServerClientReceive;
      Result.Server.OnClientStreamReceive := Result.ServerClientStreamReceive;
    // Result.EditBox1.TabOrder = 0
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetAlign ( caBottom );
    Result.EditBox1.Color := clWindow;
      Result.EditBox1.OnChar := Result.EditBox1Char;
    // Result.ListBox2.TabOrder = 1
    Result.ListBox2 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caClient );
    Result.ListBox2.Color := clWindow;
      Result.ListBox2.OnEnter := Result.ListBox2Enter;
    Result.ListBox2.CurIndex := 0;
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esNone ).SetAlign ( caRight );
    // Result.ListBox1.TabOrder = 0
      Result.ListBox1 := NewListBox( Result.Panel1, [ loNoIntegralHeight ] ).SetAlign ( caClient );
    Result.ListBox1.Color := clWindow;
      Result.ListBox1.OnEnter := Result.ListBox2Enter;
      Result.ListBox1.CurIndex := 0;
    // Result.Panel2.TabOrder = 1
      Result.Panel2 := NewPanel( Result.Panel1, esRaised ).SetAlign ( caTop ).SetSize( 0, 19 );
    Result.Panel2.TextAlign := taCenter;
    Result.Panel2.VerticalAlign := vaCenter;
      Result.Panel2.Caption := 'Connections:';
    // Result.Splitter1.TabOrder = 2
    Result.Splitter1 := NewSplitterEx( Result.Form, 0, 0, esNone ).SetAlign ( caRight );
    // Result.Progress.TabOrder = 3
    Result.Progress := NewProgressBarEx( Result.Form, [ pboSmooth ] ).SetAlign ( caBottom ).SetSize( 0, 13 );
    Result.Progress.Visible := False;
    Result.MainFormCreate( Result );

end;

