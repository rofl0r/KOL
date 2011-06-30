{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 256, 179 ).SetSize( 544, 375 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.QueryEdit.TabOrder = 0
    Result.QueryEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 40, 40 );
    Result.QueryEdit.Color := clWindow;
    Result.QueryEdit.Text := 'user@mimosa';
    // Result.QueryButton.TabOrder = 1
    Result.QueryButton := NewButton( Result.Form, 'Button1' ).SetPosition( 152, 40 );
    // Result.CancelButton.TabOrder = 2
    Result.CancelButton := NewButton( Result.Form, 'Button2' ).SetPosition( 224, 40 );
    // Result.DisplayMemo.TabOrder = 3
    Result.DisplayMemo := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 16, 64 );
    Result.DisplayMemo.Color := clWindow;
    Result.DisplayMemo.Text := 'Memo1'+#13+#10;
      Result.QueryButton.OnClick := Result.QueryButtonClick;
      Result.CancelButton.OnClick := Result.CancelButtonClick;
    Result.KOLForm1FormCreate( Result );

end;

