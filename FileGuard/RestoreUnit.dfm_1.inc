{ KOL MCK } // Do not remove this line!

procedure NewfmRestore( var Result: PfmRestore; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PfmRestore.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Restore file(s) of version just before a date:' ).SetPosition( 206, 610 ).SetClientSize( 360, 99 ).Tabulate;
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
      Result.Form.OnClose := Result.KOLForm1Close;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Restore versions before:' ).SetPosition( 8, 42 ).AutoSize( TRUE );
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esLowered ).SetPosition( 8, 8 ).SetSize( 345, 25 );
    Result.Panel1.VerticalAlign := vaCenter;
    Result.Panel1.Caption := 'Total files selected to restore:';
    // Result.lFilesCount.TabOrder = -1
      Result.lFilesCount := NewLabel( Result.Panel1, '   ' ).SetAlign ( caRight ).AutoSize( TRUE );
    // Result.eDate.TabOrder = 1
    Result.eDate := NewDateTimePicker( Result.Form, [] ).SetPosition( 152, 40 ).SetSize( 97, 0 );
    Result.eDate.Color := clWindow;
    Result.eDate.DateTimePickerColors[ dtpcBackground ] := clWindow;
    // Result.eTime.TabOrder = 2
    Result.eTime := NewDateTimePicker( Result.Form, [dtpoTime,dtpoUpDown] ).SetPosition( 256, 40 ).SetSize( 97, 0 );
    Result.eTime.Color := clWindow;
    Result.eTime.DateTimePickerColors[ dtpcBackground ] := clWindow;
    // Result.Button1.TabOrder = 3
    Result.Button1 := NewButton( Result.Form, 'Restore' ).SetPosition( 152, 72 ).SetSize( 97, 0 );
    // Result.Button2.TabOrder = 4
    Result.Button2 := NewButton( Result.Form, 'Cancel' ).SetPosition( 256, 72 ).SetSize( 96, 0 );
    // Result.cSubdirsRecursively.TabOrder = 5
    Result.cSubdirsRecursively := NewCheckBox( Result.Form, 'Subdirs Recursively' ).SetPosition( 8, 72 ).AutoSize( TRUE );
    Result.cSubdirsRecursively.Visible := False;
    Result.cSubdirsRecursively.Checked := TRUE;
      Result.Button1.OnClick := Result.Button1Click;
    Result.Button1.DefaultBtn := TRUE;
      Result.Button2.OnClick := Result.Button2Click;
    Result.Button2.CancelBtn := TRUE;
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Icon := THandle(-1);

end;

