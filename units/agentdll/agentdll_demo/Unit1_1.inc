{ KOL MCK } // Do not remove this line!

procedure NewfrmDemo( var Result: PfrmDemo; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Agent Demo' ).SetPosition( 192, 114 ).SetSize( 414, 324 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := -10;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'What to say ?' ).SetPosition( 16, 8 ).SetSize( 161, 17 );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Stop' ).SetPosition( 16, 240 ).SetSize( 89, 25 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.chkShow.TabOrder = 2
    Result.chkShow := NewCheckBox( Result.Form, 'Show character' ).SetPosition( 232, 56 ).SetSize( 137, 25 );
      Result.chkShow.OnClick := Result.chkShowClick;
    // Result.edText.TabOrder = 3
    Result.edText := NewEditBox( Result.Form, [  ] ).SetPosition( 16, 24 ).SetSize( 377, 25 );
    Result.edText.Color := clWindow;
    Result.edText.Text := 'Hello! Do you think that ''KOL'' is great ? Well, I think so .';
    // Result.Button3.TabOrder = 4
    Result.Button3 := NewButton( Result.Form, 'Speak/Think' ).SetPosition( 16, 144 ).SetSize( 89, 25 );
      Result.Button3.OnClick := Result.Button3Click;
    // Result.grSay.TabOrder = 5
    Result.grSay := NewGroupBox( Result.Form, 'How to say ?' ).SetPosition( 16, 56 ).SetSize( 137, 81 );
    Result.grSay.TabStop := FALSE;
    // Result.radSpeak.TabOrder = 0
      Result.radSpeak := NewRadioBox( Result.grSay, 'Speak' ).SetPosition( 16, 16 );
      Result.radSpeak.SetRadioChecked;
    // Result.radThink.TabOrder = 1
      Result.radThink := NewRadioBox( Result.grSay, 'Think' ).SetPosition( 16, 40 );
    // Result.edAnim.TabOrder = 6
    Result.edAnim := NewEditBox( Result.Form, [  ] ).SetPosition( 16, 176 ).SetSize( 265, 25 );
    Result.edAnim.Color := clWindow;
    // Result.Button4.TabOrder = 7
    Result.Button4 := NewButton( Result.Form, 'Play' ).SetPosition( 16, 208 ).SetSize( 89, 25 );
      Result.Button4.OnClick := Result.Button4Click;
    // Result.Button5.TabOrder = 8
    Result.Button5 := NewButton( Result.Form, 'Default character' ).SetPosition( 112, 208 ).SetSize( 145, 25 );
      Result.Button5.OnClick := Result.Button5Click;
    Result.KOLForm1FormCreate( Result );

end;

