{ KOL MCK } // Do not remove this line!
const N5 = 0;
const N6 = 1;
const N7 = 2;
const N2 = 3;
const N9 = 4;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'TCP Client' ).SetPosition( 266, 240 ).SetSize( 312, 216 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := 8;
    Result.Form.Font.FontPitch := fpVariable;
    Result.Form.Border := 0;

    Result.Menu := NewMenu( Result.Form, 0, [ 'File', '('
      , 'Connect', 'Disconnect', '-', 'Send', '-', 'Exit', ')'
      , '' ], nil );
    Result.Menu.AssignEvents( 1, [ Result.MainN6Menu ] );
    Result.Menu.ItemEnabled[ 2 ] := False;
    Result.Menu.AssignEvents( 2, [ Result.MenuN7Menu ] );
    Result.Menu.ItemEnabled[ 3 ] := False;
    Result.Menu.AssignEvents( 3, [ Result.MenuN2Menu ] );
    Result.Menu.AssignEvents( 4, [ Result.MainN9Menu ] );

    Result.Client:=newtcpclient;
    Result.Client.port:=0;
    Result.Client.host:='';
  Result.Form.Add2AutoFree( Result.Client );
      Result.Client.OnConnect := Result.ClientConnect;
      Result.Client.OnDisconnect := Result.ClientDisconnect;
      Result.Client.OnError := Result.ClientError;
      Result.Client.OnReceive := Result.ClientReceive;
      Result.Client.OnStreamSend := Result.ClientStreamSend;

    Result.Upload := NewOpenSaveDialog( 'Open file to upload', '', [  ] );
      Result.Upload.Filter := 'All files (*.*)|*.*';
  Result.Form.Add2AutoFree( Result.Upload );
    // Result.EditBox1.TabOrder = 0
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetAlign ( caBottom );
    Result.EditBox1.Color := clWindow;
      Result.EditBox1.OnChar := Result.EditBox1Char;
    // Result.ListBox1.TabOrder = 1
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetAlign ( caClient );
    Result.ListBox1.Color := clWindow;
      Result.ListBox1.OnEnter := Result.ListBox1Enter;
    Result.ListBox1.CurIndex := 0;
    // Result.Progress.TabOrder = 2
    Result.Progress := NewProgressBarEx( Result.Form, [ pboSmooth ] ).SetAlign ( caBottom ).SetSize( 0, 13 );
    Result.Progress.Visible := False;
      Result.Upload.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.MinimizeNormalAnimated;

end;

