{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Prepare directory to update' ).SetPosition( 220, 142 ).SetClientSize( 360, 467 ).TabulateEx;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
      Result.Form.OnMessage := Result.KOLForm1Message;
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnShow := Result.KOLForm1Show;

    Result.OpenDirDialog1 := NewOpenDirDialog( '', [  ] );
      Result.OpenDirDialog1.CenterOnScreen := TRUE;
  Result.Form.Add2AutoFree( Result.OpenDirDialog1 );

    Result.SaveDialog1 := NewOpenSaveDialog( 'Select file to store difference info', '', [ OSHideReadonly, OSOverwritePrompt, OSPathMustExist ] );
      Result.SaveDialog1.Filter := 'Update data files (*.upd)|*.upd';
      Result.SaveDialog1.OpenDialog := FALSE;
      Result.SaveDialog1.DefExtension := 'upd';
  Result.Form.Add2AutoFree( Result.SaveDialog1 );
    // Result.Label5.TabOrder = -1
    Result.Label5 := NewLabel( Result.Form, 'Exclude filters ('';'' separated masks):' ).SetPosition( 8, 232 ).AutoSize( TRUE );
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, 'File name to generate:' ).SetPosition( 8, 120 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Old version of directory:' ).SetPosition( 8, 8 ).AutoSize( TRUE );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'New version of directory:' ).SetPosition( 8, 64 ).AutoSize( TRUE );
    // Result.Label4.TabOrder = -1
    Result.Label4 := NewLabel( Result.Form, 'Include filters ('';'' separated masks):' ).SetPosition( 8, 176 ).AutoSize( TRUE );
    // Result.Label6.TabOrder = -1
    Result.Label6 := NewLabel( Result.Form, 'Versions hint for Updater 3.1' ).SetPosition( 8, 288 ).AutoSize( TRUE );
    // Result.ComboBox1.TabOrder = 0
    Result.ComboBox1 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 8, 32 ).SetSize( 265, 0 );
    Result.ComboBox1.Color := clWindow;
    Result.ComboBox1.CurIndex := 0;
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Browse' ).SetPosition( 280, 32 ).SetSize( 73, 0 );
    // Result.ComboBox2.TabOrder = 2
    Result.ComboBox2 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 8, 88 ).SetSize( 265, 0 );
    Result.ComboBox2.Color := clWindow;
    Result.ComboBox2.CurIndex := 0;
    // Result.Button2.TabOrder = 3
    Result.Button2 := NewButton( Result.Form, 'Browse' ).SetPosition( 279, 88 ).SetSize( 73, 0 );
    // Result.ComboBox3.TabOrder = 4
    Result.ComboBox3 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 8, 144 ).SetSize( 265, 0 );
    Result.ComboBox3.Color := clWindow;
    Result.ComboBox3.CurIndex := 0;
    // Result.Button3.TabOrder = 5
    Result.Button3 := NewButton( Result.Form, 'Browse' ).SetPosition( 279, 144 ).SetSize( 73, 0 );
    // Result.ComboBox4.TabOrder = 6
    Result.ComboBox4 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 8, 200 ).SetSize( 345, 0 );
    Result.ComboBox4.Color := clWindow;
    Result.ComboBox4.CurIndex := 0;
    // Result.ComboBox5.TabOrder = 7
    Result.ComboBox5 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 7, 256 ).SetSize( 345, 0 );
    Result.ComboBox5.Color := clWindow;
    Result.ComboBox5.CurIndex := 0;
    // Result.CheckBox1.TabOrder = 8
    Result.CheckBox1 := NewCheckBox( Result.Form, 'Include subdirectories' ).SetPosition( 8, 344 ).AutoSize( TRUE );
    // Result.btnStart.TabOrder = 9
    Result.btnStart := NewButton( Result.Form, 'Start' ).SetPosition( 280, 344 ).SetSize( 73, 0 );
    Result.btnStart.Enabled := False;
    // Result.GroupBox1.TabOrder = 10
    Result.GroupBox1 := NewGroupBox( Result.Form, '' ).SetPosition( 8, 376 ).SetSize( 345, 81 );
    Result.GroupBox1.TabStop := FALSE;
    // Result.lbFilenames.TabOrder = -1
      Result.lbFilenames := NewLabel( Result.GroupBox1, ' ' ).SetPosition( 8, 24 ).AutoSize( TRUE );
      Result.lbFilenames.DoubleBuffered := True;
    // Result.lbPercents.TabOrder = -1
      Result.lbPercents := NewLabel( Result.GroupBox1, ' ' ).SetPosition( 8, 48 ).SetSize( 45, 0 );
      Result.lbPercents.DoubleBuffered := True;
    // Result.Gauge.TabOrder = 0
      Result.Gauge := NewProgressBar( Result.GroupBox1 ).SetPosition( 56, 48 ).SetSize( 281, 0 );
      Result.Gauge.Visible := False;
      Result.Gauge.DoubleBuffered := True;
    // Result.BitBtn1.TabOrder = 11
    Result.BitBtn1 := NewBitBtn( Result.Form, 'About', [  ], glyphLeft, 0, 0 ).SetPosition( 280, 4 ).SetSize( 73, 0 ).LikeSpeedButton;
    Result.BitBtn1.TextShiftX := 1;
    Result.BitBtn1.TextShiftY := 1;
    // Result.EditBox1.TabOrder = 12
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 8, 312 ).SetSize( 265, 0 );
    Result.EditBox1.Color := clWindow;
    // Result.Button4.TabOrder = 13
    Result.Button4 := NewButton( Result.Form, '<' ).SetPosition( 280, 312 ).SetSize( 33, 0 );
    // Result.Button5.TabOrder = 13
    Result.Button5 := NewButton( Result.Form, '>' ).SetPosition( 320, 312 ).SetSize( 33, 0 );
      Result.ComboBox1.OnLeave := Result.ComboBox1Leave;
      Result.ComboBox1.OnChange := Result.ComboBox1Change;
      Result.ComboBox1.OnDropFiles := Result.ComboBox1DropFiles;
      Result.Button1.OnClick := Result.Button1Click;
      Result.ComboBox2.OnLeave := Result.ComboBox1Leave;
      Result.ComboBox2.OnChange := Result.ComboBox1Change;
      Result.ComboBox2.OnDropFiles := Result.ComboBox1DropFiles;
      Result.Button2.OnClick := Result.Button2Click;
      Result.ComboBox3.OnLeave := Result.ComboBox1Leave;
      Result.ComboBox3.OnChange := Result.ComboBox1Change;
      Result.ComboBox3.OnDropFiles := Result.ComboBox3DropFiles;
      Result.Button3.OnClick := Result.Button3Click;
      Result.ComboBox4.OnLeave := Result.ComboBox1Leave;
      Result.ComboBox5.OnLeave := Result.ComboBox1Leave;
      Result.btnStart.OnClick := Result.btnStartClick;
      Result.BitBtn1.OnClick := Result.BitBtn1Click;
      Result.EditBox1.OnLeave := Result.EditBox1Leave;
      Result.Button4.OnClick := Result.Button4Click;
      Result.Button4.OnLeave := Result.EditBox1Leave;
      Result.Button5.OnClick := Result.Button5Click;
      Result.Button5.OnLeave := Result.EditBox1Leave;
      Result.OpenDirDialog1.WndOwner := Result.Form.GetWindowHandle;
      Result.SaveDialog1.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CenterOnParent.CanResize := False;
    Result.KOLForm1FormCreate( Result );
    Result.Form.Icon := THandle(-1);

end;

