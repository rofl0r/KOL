{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Control KOL_Services' ).SetPosition( 212, 107 ).SetSize( 542, 203 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
      Result.Form.OnMessage := Result.fmControlKOLServiceMessage;

    Result.Timer1 := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;
    // Result.Label4.TabOrder = -1
    Result.Label4 := NewLabel( Result.Form, 'Service B:' ).SetPosition( 10, 90 ).SetSize( 79, 27 );
    Result.Label4.Color := clBtnFace;
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, '' ).SetPosition( 104, 90 ).SetSize( 375, 27 );
    Result.Label3.Color := clBtnFace;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, '' ).SetPosition( 104, 10 ).SetSize( 375, 27 );
    Result.Label1.Color := clBtnFace;
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Service A:' ).SetPosition( 10, 10 ).SetSize( 79, 27 );
    Result.Label2.Color := clBtnFace;
    // Result.btnInstall.TabOrder = 0
    Result.btnInstall := NewButton( Result.Form, 'Install' ).SetPosition( 7, 49 ).SetSize( 79, 27 );
      Result.btnInstall.OnClick := Result.btnInstallClick;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Install' ).SetPosition( 7, 129 ).SetSize( 79, 27 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.btnStart.TabOrder = 1
    Result.btnStart := NewButton( Result.Form, 'Start' ).SetPosition( 95, 49 ).SetSize( 79, 27 );
      Result.btnStart.OnClick := Result.btnStartClick;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Start' ).SetPosition( 95, 129 ).SetSize( 79, 27 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Button3.TabOrder = 2
    Result.Button3 := NewButton( Result.Form, 'Stop' ).SetPosition( 182, 129 ).SetSize( 79, 27 );
      Result.Button3.OnClick := Result.Button3Click;
    // Result.btnStop.TabOrder = 2
    Result.btnStop := NewButton( Result.Form, 'Stop' ).SetPosition( 182, 49 ).SetSize( 79, 27 );
      Result.btnStop.OnClick := Result.btnStopClick;
    // Result.Button4.TabOrder = 3
    Result.Button4 := NewButton( Result.Form, 'Pause' ).SetPosition( 271, 129 ).SetSize( 79, 27 );
      Result.Button4.OnClick := Result.Button4Click;
    // Result.btnPause.TabOrder = 3
    Result.btnPause := NewButton( Result.Form, 'Pause' ).SetPosition( 271, 49 ).SetSize( 79, 27 );
      Result.btnPause.OnClick := Result.btnPauseClick;
    // Result.Button5.TabOrder = 4
    Result.Button5 := NewButton( Result.Form, 'Resume' ).SetPosition( 358, 129 ).SetSize( 79, 27 );
      Result.Button5.OnClick := Result.Button5Click;
    // Result.btnResume.TabOrder = 4
    Result.btnResume := NewButton( Result.Form, 'Resume' ).SetPosition( 358, 49 ).SetSize( 79, 27 );
      Result.btnResume.OnClick := Result.btnResumeClick;
    // Result.Button6.TabOrder = 5
    Result.Button6 := NewButton( Result.Form, 'Remove' ).SetPosition( 446, 129 ).SetSize( 78, 27 );
      Result.Button6.OnClick := Result.Button6Click;
    // Result.btnRemove.TabOrder = 5
    Result.btnRemove := NewButton( Result.Form, 'Remove' ).SetPosition( 446, 49 ).SetSize( 78, 27 );
      Result.btnRemove.OnClick := Result.btnRemoveClick;
    Result.Timer1.Enabled := True;
    Result.fmControlKOLServiceFormCreate( Result );

end;

