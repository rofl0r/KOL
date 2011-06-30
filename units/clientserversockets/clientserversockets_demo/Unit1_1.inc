{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 297, 105 ).SetSize( 287, 267 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Border := 0;

    Result.sckt := NewServerSocket;
  Result.Form.Add2AutoFree( Result.sckt );
      Result.sckt.OnAccept := Result.scktAccept;
      Result.sckt.OnGetThread := Result.scktGetThread;
      Result.sckt.OnClientConnect := Result.scktClientConnect;
      Result.sckt.OnClientDisconnect := Result.scktClientDisconnect;
      Result.sckt.OnClientWrite := Result.scktClientWrite;
      Result.sckt.OnClientError := Result.scktClientError;

    Result.clnt := NewClientSocket;
  Result.Form.Add2AutoFree( Result.clnt );
      Result.clnt.OnConnect := Result.clntConnect;
      Result.clnt.OnRead := Result.clntRead;
    // Result.Memo1.TabOrder = 0
    Result.Memo1 := NewEditBox( Result.Form, [ eoMultiline ] ).SetAlign ( caBottom ).SetSize( 0, 198 );
    Result.Memo1.Color := clWindow;
    Result.Memo1.Font.FontHeight := 10;
    Result.Memo1.Font.FontPitch := fpFixed;
    Result.Memo1.Text := 'Memo1'+#13+#10;
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Start Server' ).SetPosition( 4, 1 );
    Result.Button1.Font.FontHeight := 10;
    Result.Button1.Font.FontPitch := fpFixed;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Start Client' ).SetPosition( 84, 1 );
    Result.Button2.Font.FontHeight := 10;
    Result.Button2.Font.FontPitch := fpFixed;
    // Result.EditBox1.TabOrder = 2
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 0, 23 ).SetSize( 277, 18 );
    Result.EditBox1.Color := clWindow;
    Result.EditBox1.Font.FontHeight := 10;
    Result.EditBox1.Font.FontPitch := fpFixed;
    Result.EditBox1.Text := 'EditBox1';
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button1.OnClick := Result.Button1Click;
    Result.sckt.Active:=FALSE;
    Result.sckt.Port:=5000;
    Result.sckt.Service:='';
    Result.sckt.ServerType:=stThreadBlocking;
    Result.sckt.ThreadCacheSize:=0;
      Result.EditBox1.OnChar := Result.EditBox1Char;
    Result.clnt.Active:=FALSE;
    Result.clnt.Address:='';
    Result.clnt.Host:='';
    Result.clnt.Port:=0;
    Result.clnt.Service:='';
    Result.clnt.ClientType:=ctNonBlocking;
    Result.Form.CenterOnParent;

end;

