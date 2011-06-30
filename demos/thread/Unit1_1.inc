{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 463, 269 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnClose := Result.KOLForm1Close;

    Result.Thread1 := NewThread;
    Result.Thread1.OnExecute := Result.Thread1Execute;
    Result.Thread1.OnSuspend := Result.Thread1Suspend;
    Result.Thread1.OnResume := Result.Thread1Resume;
    Result.Thread1.OnDestroy := Result.Thread1Destroy;
  Result.Form.Add2AutoFree( Result.Thread1 );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Resume Thread' ).SetPosition( 16, 8 ).SetSize( 201, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Suspend Thread' ).SetPosition( 16, 40 ).SetSize( 201, 0 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Button3.TabOrder = 2
    Result.Button3 := NewButton( Result.Form, 'Terminate all NOW!' ).SetPosition( 16, 88 ).SetSize( 201, 0 );
      Result.Button3.OnClick := Result.Button3Click;
    // Result.Memo1.TabOrder = 3
    Result.Memo1 := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll ] ).SetPosition( 240, 8 );
    Result.Memo1.Color := clWindow;
    Result.Memo1.Text := 'While thread is executing you can do something else. E.g., edit this text.'+#13+#10;
    Result.Form.CanResize := False;

end;

