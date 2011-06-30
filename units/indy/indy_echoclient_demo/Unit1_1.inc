{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Echo Test' ).SetPosition( 202, 184 ).SetSize( 302, 183 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.lablReceived.TabOrder = -1
    Result.lablReceived := NewLabel( Result.Form, 'Echo Time:' ).SetPosition( 24, 80 ).AutoSize( TRUE );
    Result.lablReceived.Font.FontHeight := 12;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Echo Server:' ).SetPosition( 24, 28 ).AutoSize( TRUE );
    Result.Label1.Font.FontHeight := 12;
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Send Text:' ).SetPosition( 24, 56 ).AutoSize( TRUE );
    Result.Label2.Font.FontHeight := 12;
    // Result.lablTime.TabOrder = -1
    Result.lablTime := NewLabel( Result.Form, 'Received Text: ' ).SetPosition( 24, 104 ).AutoSize( TRUE );
    Result.lablTime.Font.FontHeight := 12;
    // Result.btnConnect.TabOrder = 0
    Result.btnConnect := NewButton( Result.Form, 'Connect' ).SetPosition( 224, 24 );
    Result.btnConnect.Font.FontHeight := 12;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Send' ).SetPosition( 224, 56 );
    Result.Button2.Font.FontHeight := 12;
    // Result.btnDisconnect.TabOrder = 2
    Result.btnDisconnect := NewButton( Result.Form, 'Disconnect' ).SetPosition( 224, 120 );
    Result.btnDisconnect.Font.FontHeight := 12;
    // Result.edtEchoServer.TabOrder = 3
    Result.edtEchoServer := NewEditBox( Result.Form, [  ] ).SetPosition( 104, 24 );
    Result.edtEchoServer.Color := clWindow;
    Result.edtEchoServer.Font.FontHeight := 12;
    Result.edtEchoServer.Text := '127.0.0.1';
    // Result.edtSendText.TabOrder = 4
    Result.edtSendText := NewEditBox( Result.Form, [  ] ).SetPosition( 104, 52 );
    Result.edtSendText.Color := clWindow;
    Result.edtSendText.Font.FontHeight := 12;
    Result.edtSendText.Text := 'KOLIndy';
      Result.btnConnect.OnClick := Result.btnConnectClick;
      Result.Button2.OnClick := Result.Button2Click;
      Result.btnDisconnect.OnClick := Result.btnDisconnectClick;
      Result.edtEchoServer.OnChange := Result.edtEchoServerChange;
    Result.KOLForm1FormCreate( Result );

end;

