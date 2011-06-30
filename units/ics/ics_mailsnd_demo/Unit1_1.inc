{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 175, 111 ).SetSize( 544, 375 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.AllInOneButton.TabOrder = 0
    Result.AllInOneButton := NewButton( Result.Form, 'AllInOneButton' ).SetPosition( 368, 176 );
    // Result.Button2.TabOrder = 0
    Result.Button2 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 56 );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 32 );
    // Result.Button4.TabOrder = 0
    Result.Button4 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 104 );
    // Result.Button5.TabOrder = 0
    Result.Button5 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 128 );
    // Result.Button6.TabOrder = 0
    Result.Button6 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 152 );
    // Result.Button3.TabOrder = 0
    Result.Button3 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 80 );
    // Result.Button8.TabOrder = 0
    Result.Button8 := NewButton( Result.Form, 'Button1' ).SetPosition( 368, 32 );
    // Result.Button9.TabOrder = 0
    Result.Button9 := NewButton( Result.Form, 'Button1' ).SetPosition( 368, 56 );
    // Result.QuitButton.TabOrder = 0
    Result.QuitButton := NewButton( Result.Form, 'Quit' ).SetPosition( 368, 80 );
    // Result.AbortButton.TabOrder = 0
    Result.AbortButton := NewButton( Result.Form, 'Abort' ).SetPosition( 368, 104 );
    // Result.ClearDisplayButton.TabOrder = 0
    Result.ClearDisplayButton := NewButton( Result.Form, 'ClearDisplay' ).SetPosition( 368, 128 );
    // Result.Button7.TabOrder = 0
    Result.Button7 := NewButton( Result.Form, 'Button1' ).SetPosition( 296, 176 );
    // Result.DisplayMemo.TabOrder = 1
    Result.DisplayMemo := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 280, 240 ).SetSize( 0, 81 );
    Result.DisplayMemo.Color := clWindow;
    Result.DisplayMemo.Text := 'Memo1'+#13+#10;
    // Result.Memo2.TabOrder = 1
    Result.Memo2 := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 72, 224 ).SetSize( 0, 81 );
    Result.Memo2.Color := clWindow;
    Result.Memo2.Text := 'Memo1'+#13+#10;
    // Result.MsgMemo.TabOrder = 1
    Result.MsgMemo := NewEditBox( Result.Form, [ eoMultiline ] ).SetPosition( 8, 136 ).SetSize( 0, 81 );
    Result.MsgMemo.Color := clWindow;
    Result.MsgMemo.Text := 'Memo1'+#13+#10;
    // Result.EditBox10.TabOrder = 2
    Result.EditBox10 := NewEditBox( Result.Form, [  ] ).SetPosition( 136, 112 );
    Result.EditBox10.Color := clWindow;
    Result.EditBox10.Font.FontHeight := -12;
    Result.EditBox10.Text := 'EditBox1';
    // Result.FromEdit.TabOrder = 2
    Result.FromEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 24, 40 );
    Result.FromEdit.Color := clWindow;
    Result.FromEdit.Font.FontHeight := -12;
    Result.FromEdit.Text := 'Gendalf_the_gr@mail.ru';
    // Result.CcEdit.TabOrder = 2
    Result.CcEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 24, 64 );
    Result.CcEdit.Color := clWindow;
    Result.CcEdit.Font.FontHeight := -12;
    // Result.SubjectEdit.TabOrder = 2
    Result.SubjectEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 24, 88 );
    Result.SubjectEdit.Color := clWindow;
    Result.SubjectEdit.Font.FontHeight := -12;
    Result.SubjectEdit.Text := 'This is the message subject';
    // Result.EditBox5.TabOrder = 2
    Result.EditBox5 := NewEditBox( Result.Form, [  ] ).SetPosition( 24, 112 );
    Result.EditBox5.Color := clWindow;
    Result.EditBox5.Font.FontHeight := -12;
    Result.EditBox5.Text := 'EditBox1';
    // Result.HostEdit.TabOrder = 2
    Result.HostEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 24, 16 );
    Result.HostEdit.Color := clWindow;
    Result.HostEdit.Font.FontHeight := -12;
    Result.HostEdit.Text := 'smtp.mail.ru';
    // Result.ToEdit.TabOrder = 2
    Result.ToEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 136, 40 );
    Result.ToEdit.Color := clWindow;
    Result.ToEdit.Font.FontHeight := -12;
    Result.ToEdit.Text := 'Gandalf@kol.mastak.ru';
    // Result.BccEdit.TabOrder = 2
    Result.BccEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 136, 64 );
    Result.BccEdit.Color := clWindow;
    Result.BccEdit.Font.FontHeight := -12;
    // Result.SignOnEdit.TabOrder = 2
    Result.SignOnEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 136, 88 );
    Result.SignOnEdit.Color := clWindow;
    Result.SignOnEdit.Font.FontHeight := -12;
    Result.SignOnEdit.Text := 'Me';
    // Result.PortEdit.TabOrder = 2
    Result.PortEdit := NewEditBox( Result.Form, [  ] ).SetPosition( 136, 16 );
    Result.PortEdit.Color := clWindow;
    Result.PortEdit.Font.FontHeight := -12;
    Result.PortEdit.Text := 'smtp';
      Result.AllInOneButton.OnClick := Result.AllInOneButtonClick;
      Result.QuitButton.OnClick := Result.QuitButtonClick;
      Result.AbortButton.OnClick := Result.AbortButtonClick;
      Result.ClearDisplayButton.OnClick := Result.ClearDisplayButtonClick;
    Result.KOLForm1FormCreate( Result );

end;

