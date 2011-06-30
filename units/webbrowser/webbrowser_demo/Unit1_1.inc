{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 192, 114 ).SetClientSize( 688, 446 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := -11;
    Result.Form.Border := 0;

    Result.OpenDlg := NewOpenSaveDialog( '', '', [  ] );
      Result.OpenDlg.Filter := 'HTML-files|*.htm;*.html;*.shtml|All files|*.*';
      Result.OpenDlg.DefExtension := 'htm';
  Result.Form.Add2AutoFree( Result.OpenDlg );
    // Result.HTML.TabOrder = 0
    Result.HTML := NewKOLWebBrowser(Result.Form); 
    Result.HTML.SetAlign( caClient); 
    Result.HTML.Offline := True;
    Result.HTML.Silent := True;
    Result.HTML.RegisterAsBrowser := True;
    Result.HTML.RegisterAsDropTarget := False;
    // Result.Panel1.TabOrder = 1
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 40 );
    // Result.Button1.TabOrder = 0
      Result.Button1 := NewButton( Result.Panel1, 'Open HTML-file' ).SetPosition( 7, 6 ).SetSize( 150, 0 );
    // Result.Button2.TabOrder = 1
      Result.Button2 := NewButton( Result.Panel1, '<<<' ).SetPosition( 171, 6 );
    // Result.Button3.TabOrder = 2
      Result.Button3 := NewButton( Result.Panel1, '>>>' ).SetPosition( 246, 6 );
    // Result.Button4.TabOrder = 3
      Result.Button4 := NewButton( Result.Panel1, 'Refresh' ).SetPosition( 322, 6 );
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button4.OnClick := Result.Button4Click;
      Result.OpenDlg.WndOwner := Result.Form.GetWindowHandle;

end;

