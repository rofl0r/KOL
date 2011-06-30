{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Test UnZIP' ).SetPosition( 207, 113 ).SetClientSize( 512, 366 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.Font.FontHeight := -11;
    Result.Form.Border := 0;

    Result.OpenDlg := NewOpenSaveDialog( 'Select a ZIP-file', '', [ OSFileMustExist, OSHideReadonly, OSPathMustExist ] );
      Result.OpenDlg.Filter := 'ZIP-files|*.zip';
      Result.OpenDlg.DefExtension := 'zip';
  Result.Form.Add2AutoFree( Result.OpenDlg );

    Result.DirDlg := NewOpenDirDialog( 'Select destination folder', [  ] );
  Result.Form.Add2AutoFree( Result.DirDlg );
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, '' ).SetPosition( 10, 300 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'ZIP-file' ).SetPosition( 11, 15 ).AutoSize( TRUE );
    // Result.Label4.TabOrder = -1
    Result.Label4 := NewLabel( Result.Form, 'File specification' ).SetPosition( 12, 69 ).AutoSize( TRUE );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Folder to extract' ).SetPosition( 11, 42 ).AutoSize( TRUE );
    // Result.Edit1.TabOrder = 0
    Result.Edit1 := NewEditBox( Result.Form, [  ] ).SetPosition( 63, 12 ).SetSize( 370, 21 );
    Result.Edit1.Color := clWindow;
    Result.Edit1.Text := 'D:\test.zip';
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Select' ).SetPosition( 444, 12 ).SetSize( 60, 21 );
    // Result.Edit2.TabOrder = 2
    Result.Edit2 := NewEditBox( Result.Form, [  ] ).SetPosition( 103, 39 ).SetSize( 330, 21 );
    Result.Edit2.Color := clWindow;
    Result.Edit2.Text := 'D:\0';
    // Result.Button2.TabOrder = 3
    Result.Button2 := NewButton( Result.Form, 'Select' ).SetPosition( 444, 39 ).SetSize( 60, 21 );
    // Result.Edit3.TabOrder = 4
    Result.Edit3 := NewEditBox( Result.Form, [  ] ).SetPosition( 104, 66 ).SetSize( 0, 21 );
    Result.Edit3.Color := clWindow;
    Result.Edit3.Text := '*.*';
    // Result.Button3.TabOrder = 5
    Result.Button3 := NewButton( Result.Form, 'Open' ).SetPosition( 215, 66 ).SetSize( 44, 0 );
    // Result.Button4.TabOrder = 6
    Result.Button4 := NewButton( Result.Form, 'View' ).SetPosition( 265, 66 ).SetSize( 44, 0 );
    // Result.Button5.TabOrder = 7
    Result.Button5 := NewButton( Result.Form, 'Extract' ).SetPosition( 315, 66 ).SetSize( 44, 0 );
    // Result.Button6.TabOrder = 8
    Result.Button6 := NewButton( Result.Form, 'Close' ).SetPosition( 364, 66 ).SetSize( 44, 0 );
    // Result.ListBox1.TabOrder = 9
    Result.ListBox1 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetPosition( 10, 96 ).SetSize( 270, 0 );
    Result.ListBox1.Color := clWindow;
    Result.ListBox1.CurIndex := 0;
    // Result.ListBox2.TabOrder = 10
    Result.ListBox2 := NewListBox( Result.Form, [ loNoIntegralHeight ] ).SetPosition( 283, 96 ).SetSize( 220, 0 );
    Result.ListBox2.Color := clWindow;
    Result.ListBox2.CurIndex := 0;
    // Result.Bar2.TabOrder = 11
    Result.Bar2 := NewProgressBarEx( Result.Form, [ pboSmooth ] ).SetPosition( 10, 341 ).SetSize( 490, 19 );
    // Result.Bar1.TabOrder = 12
    Result.Bar1 := NewProgressBarEx( Result.Form, [ pboSmooth ] ).SetPosition( 10, 317 ).SetSize( 490, 19 );
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button4.OnClick := Result.Button4Click;
      Result.Button5.OnClick := Result.Button5Click;
      Result.Button6.OnClick := Result.Button6Click;
      Result.OpenDlg.WndOwner := Result.Form.GetWindowHandle;
      Result.DirDlg.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Icon := THandle(-1);

end;

