{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Test Flash player' ).SetPosition( 192, 114 ).SetClientSize( 490, 246 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := -11;
    Result.Form.Border := 0;

    Result.OpenDlg := NewOpenSaveDialog( 'Select Flash-movie...', '', [  ] );
      Result.OpenDlg.Filter := 'Flash-movie|*.swf|All files|*.*';
      Result.OpenDlg.DefExtension := 'swf';
  Result.Form.Add2AutoFree( Result.OpenDlg );
    // Result.Flash1.TabOrder = 0
    Result.Flash1 := NewKOLFlash(Result.Form); 
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Load Flash' ).SetPosition( 362, 211 ).SetSize( 120, 24 );
    // Result.Button2.TabOrder = 2
    Result.Button2 := NewButton( Result.Form, 'Play' ).SetPosition( 132, 211 ).SetSize( 0, 24 );
    Result.Button2.Enabled := False;
    // Result.Button3.TabOrder = 3
    Result.Button3 := NewButton( Result.Form, 'Pause' ).SetPosition( 206, 211 ).SetSize( 0, 24 );
    Result.Button3.Enabled := False;
    // Result.Button4.TabOrder = 3
    Result.Button4 := NewButton( Result.Form, 'Stop' ).SetPosition( 280, 211 ).SetSize( 0, 24 );
    Result.Button4.Enabled := False;
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button4.OnClick := Result.Button4Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.OpenDlg.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );

end;

