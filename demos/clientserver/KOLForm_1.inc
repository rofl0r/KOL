{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Client-Server' ).SetPosition( 395, 242 ).SetSize( 347, 330 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.DoubleBuffered := True;
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontCharset := 0;
    Result.Form.StatusText[ 0 ] := 'Disconnected';
    Result.Form.StatusText[ 1 ] := '';
    Result.Form.StatusText[ 2 ] := '';
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.Timer1 := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.KOLTimer1Timer;

    Result.ServerSocket := NewAsyncSocket;
    Result.ServerSocket.PortNumber := 33333;
    Result.ServerSocket.IPAddress  := '0.0.0.0';
  Result.Form.Add2AutoFree( Result.ServerSocket );
      Result.ServerSocket.OnAccept := Result.ServerSocketAccept;
      Result.ServerSocket.OnListen := Result.ServerSocketListen;
      Result.ServerSocket.OnClose := Result.ServerSocketClose;
      Result.ServerSocket.OnError := Result.ServerSocketError;

    Result.ClientSocket := NewAsyncSocket;
    Result.ClientSocket.PortNumber := 33333;
    Result.ClientSocket.IPAddress  := '0.0.0.0';
  Result.Form.Add2AutoFree( Result.ClientSocket );
      Result.ClientSocket.OnConnect := Result.ClientSocketConnect;
      Result.ClientSocket.OnRead := Result.ClientSocketRead;
      Result.ClientSocket.OnClose := Result.ClientSocketClose;
      Result.ClientSocket.OnError := Result.ClientSocketError;
    // Result.EditBox1.TabOrder = 0
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 0, 232 ).SetSize( 265, 0 );
    Result.EditBox1.Color := clBtnFace;
    Result.EditBox1.Font.FontName := 'Fixedsys';
    Result.EditBox1.Enabled := False;
      Result.EditBox1.OnKeyUp := Result.EditBox1KeyUp;
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Send' ).SetPosition( 270, 232 );
    Result.Button1.Enabled := False;
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 2
    Result.Button2 := NewButton( Result.Form, 'Listen' ).SetPosition( 270, 256 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Panel1.TabOrder = 3
    Result.Panel1 := NewPanel( Result.Form, esNone ).SetPosition( -1, -1 ).SetSize( 341, 226 );
    Result.Panel1.Font.FontName := 'Fixedsys';
    // Result.RichEdit1.TabOrder = 0
      Result.RichEdit1 := NewRichEdit( Result.Panel1, [ eoMultiline, eoReadonly ] ).SetAlign ( caClient );
    Result.RichEdit1.TabStop := FALSE;
    Result.RichEdit1.Color := clWindow;
    // Result.Button3.TabOrder = 4
    Result.Button3 := NewButton( Result.Form, 'Connect' ).SetPosition( 270, 280 );
      Result.Button3.OnClick := Result.Button3Click;
    // Result.ListView1.TabOrder = 5
    Result.ListView1 := NewListView( Result.Form, lvsList, [  ], nil, nil, nil ).SetPosition( 168, 416 ).SetSize( 28, 29 );
    Result.ListView1.Color := clWindow;
    Result.ListView1.Visible := False;
    // Result.EditBox2.TabOrder = 6
    Result.EditBox2 := NewEditBox( Result.Form, [  ] ).SetPosition( 0, 264 ).SetSize( 105, 0 );
    Result.EditBox2.Color := clWindow;
    Result.EditBox2.Font.FontName := 'Fixedsys';
    Result.EditBox2.Text := '127.0.0.1';
    // Result.Button4.TabOrder = 7
    Result.Button4 := NewButton( Result.Form, 'GetIP' ).SetPosition( 112, 264 ).SetSize( 49, 0 );
      Result.Button4.OnClick := Result.Button4Click;
    Result.Timer1.Enabled := True;
    Result.Form.CenterOnParent.CanResize := False;
    Result.KOLForm1FormCreate( Result );

end;

