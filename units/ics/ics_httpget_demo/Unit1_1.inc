{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Demo' ).SetPosition( 192, 114 ).SetSize( 544, 375 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.InfoLabel.TabOrder = -1
    Result.InfoLabel := NewLabel( Result.Form, 'Label1' ).SetPosition( 210, 50 ).AutoSize( TRUE );
    Result.InfoLabel.Font.FontHeight := -12;
    // Result.URLEdit.TabOrder = 0
    Result.URLEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 48, 40 );
    Result.URLEdit.Color := clWindow;
    Result.URLEdit.Font.FontHeight := -12;
    Result.URLEdit.Text := 'http://kol.mastak.ru/';
    // Result.FileNameEdit.TabOrder = 1
    Result.FileNameEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 48, 72 );
    Result.FileNameEdit.Color := clWindow;
    Result.FileNameEdit.Font.FontHeight := -12;
    Result.FileNameEdit.Text := 'test.htm';
    // Result.ProxyHostEdit.TabOrder = 2
    Result.ProxyHostEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 48, 104 );
    Result.ProxyHostEdit.Color := clWindow;
    Result.ProxyHostEdit.Font.FontHeight := -12;
    // Result.ProxyPortEdit.TabOrder = 3
    Result.ProxyPortEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 48, 136 );
    Result.ProxyPortEdit.Color := clWindow;
    Result.ProxyPortEdit.Font.FontHeight := -12;
    Result.ProxyPortEdit.Text := '80';
    // Result.GetButton.TabOrder = 4
    Result.GetButton := NewButton( Result.Form, 'Button1' ).SetPosition( 48, 168 );
    Result.GetButton.Font.FontHeight := -12;
    // Result.AbortButton.TabOrder = 5
    Result.AbortButton := NewButton( Result.Form, 'Button2' ).SetPosition( 48, 200 );
    Result.AbortButton.Font.FontHeight := -12;
      Result.GetButton.OnClick := Result.GetButtonClick;
      Result.AbortButton.OnClick := Result.AbortButtonClick;
    Result.KOLForm1FormCreate( Result );

end;

