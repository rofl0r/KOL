{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Telnet Daemon' ).SetPosition( 319, 104 ).SetSize( 511, 476 );
  Result.Form.Add2AutoFree( Result );
      Result.Form.Font.FontHeight := 16;
      Result.Form.Font.FontName := 'Arial';
      Result.Form.OnShow := Result.KOLFormShow;
      Result.Form.OnDestroy := Result.KOLFormDestroy;

    Result.Idle := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Idle );
      Result.Idle.OnTimer := Result.IdleTimer;

    Result.m_ServerSocket := NewAsyncSocket;
    Result.m_ServerSocket.PortNumber := 23;
    Result.m_ServerSocket.IPAddress  := '0.0.0.0';
  Result.Form.Add2AutoFree( Result.m_ServerSocket );
      Result.m_ServerSocket.OnAccept := Result.OnAccept;
      Result.m_ServerSocket.OnListen := Result.OnListen;
      Result.m_ServerSocket.OnClose := Result.OnClose;
      Result.m_ServerSocket.OnError := Result.OnError;
    // Result.RE2.TabOrder = 0
    Result.RE2 := NewRichEdit( Result.Form, [ eoMultiline ] ).SetAlign ( caClient );
    // Result.LV.TabOrder = 0
    Result.LV := NewListView( Result.Form, lvsDetail, [  ], nil, nil, nil ).SetAlign ( caBottom ).SetSize( 0, 198 );
    // Result.RE1.TabOrder = 0
    Result.RE1 := NewRichEdit( Result.Form, [ eoMultiline ] ).SetAlign ( caLeft ).SetSize( 257, 0 );
    Result.LV.LVCount := 2;
    Result.Idle.Enabled := True;
    Result.KOLFormFormCreate( Result );

end;

