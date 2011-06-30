{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Test Winamp IO Plugin' ).SetPosition( 192, 114 ).SetClientSize( 332, 186 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.Font.FontHeight := -11;
    Result.Form.Border := 0;

    Result.OpenDlg1 := NewOpenSaveDialog( '', 'c:\program files\winamp\plugins', [  ] );
      Result.OpenDlg1.DefExtension := 'dll';
  Result.Form.Add2AutoFree( Result.OpenDlg1 );

    Result.OpenDlg2 := NewOpenSaveDialog( '', '.', [  ] );
  Result.Form.Add2AutoFree( Result.OpenDlg2 );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Open' ).SetPosition( 10, 14 ).SetSize( 80, 26 );
    Result.Button1.Enabled := False;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Play' ).SetPosition( 10, 46 ).SetSize( 80, 26 );
    Result.Button2.Enabled := False;
    // Result.Button3.TabOrder = 2
    Result.Button3 := NewButton( Result.Form, 'Stop' ).SetPosition( 10, 78 ).SetSize( 80, 26 );
    Result.Button3.Enabled := False;
    // Result.Button6.TabOrder = 3
    Result.Button6 := NewButton( Result.Form, 'Config Input' ).SetPosition( 242, 14 ).SetSize( 80, 26 );
    Result.Button6.Enabled := False;
    // Result.Button7.TabOrder = 4
    Result.Button7 := NewButton( Result.Form, 'Config Output' ).SetPosition( 242, 46 ).SetSize( 80, 26 );
    Result.Button7.Enabled := False;
    // Result.Button4.TabOrder = 5
    Result.Button4 := NewButton( Result.Form, 'Select Input Plugin' ).SetPosition( 96, 14 ).SetSize( 140, 26 );
    // Result.Button5.TabOrder = 6
    Result.Button5 := NewButton( Result.Form, 'Select Output Plugin' ).SetPosition( 96, 46 ).SetSize( 140, 26 );
    // Result.Button8.TabOrder = 7
    Result.Button8 := NewButton( Result.Form, 'Exit' ).SetPosition( 242, 78 ).SetSize( 80, 26 );
    // Result.TrackBar1.TabOrder = 8
    Result.TrackBar1 := PTrackbar( NewTrackBar( Result.Form, [trbFixedLength,trbNoBorder], Result.TrackBar1Scroll ).SetPosition( 96, 78 ).SetSize( 140, 26 ));
    Result.TrackBar1.TabStop := FALSE;
    Result.TrackBar1.RangeMax := 255;
    Result.TrackBar1.PageSize := 8;
    Result.TrackBar1.Position := 128;
    Result.TrackBar1.ThumbLen := 18;
    // Result.ListBox1.TabOrder = 9
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight, loNoSel ] ).SetPosition( 10, 111 ).SetSize( 311, 66 );
    Result.ListBox1.Color := clWindow;
    Result.ListBox1.CurIndex := 0;
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button6.OnClick := Result.Button6Click;
      Result.Button7.OnClick := Result.Button7Click;
      Result.Button4.OnClick := Result.Button4Click;
      Result.Button5.OnClick := Result.Button5Click;
      Result.Button8.OnClick := Result.Button8Click;
      Result.OpenDlg1.WndOwner := Result.Form.GetWindowHandle;
      Result.OpenDlg2.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CenterOnParent.CanResize := False;

end;

