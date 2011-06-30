{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Demo' ).SetPosition( 192, 133 ).SetSize( 415, 323 ).Tabulate;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Date/time:???' ).SetPosition( 128, 24 ).SetSize( 161, 17 );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Checked' ).SetPosition( 16, 72 ).SetSize( 129, 25 );
    // Result.DatePicker1.TabOrder = 2
    Result.DatePicker1 := NewDatePicker( Result.Form,[ piCheckBox,piLongDate] ).SetPosition( 160, 72 ).SetSize( 153, 22 );
    Result.DatePicker1.Tag := 123;
      Result.DatePicker1.OnEraseBkgnd := Result.DatePicker1EraseBkgnd;
    Result.DatePicker1.Format := '';
    // Result.Button3.TabOrder = 3
    Result.Button3 := NewButton( Result.Form, 'Change font of calendar' ).SetPosition( 16, 168 ).SetSize( 177, 0 );
      Result.Button3.OnClick := Result.Button3Click;
    // Result.Button1.TabOrder = 4
    Result.Button1 := NewButton( Result.Form, 'Test if Checked' ).SetPosition( 16, 104 ).SetSize( 121, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 5
    Result.Button2 := NewButton( Result.Form, 'ChangeColors' ).SetPosition( 16, 136 ).SetSize( 121, 25 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Button4.TabOrder = 6
    Result.Button4 := NewButton( Result.Form, 'Change format' ).SetPosition( 16, 232 ).SetSize( 121, 0 );
      Result.Button4.OnClick := Result.Button4Click;
    // Result.Button5.TabOrder = 7
    Result.Button5 := NewButton( Result.Form, 'Change font' ).SetPosition( 16, 200 ).SetSize( 121, 0 );
      Result.Button5.OnClick := Result.Button5Click;
    Result.KOLForm1FormCreate( Result );

end;


