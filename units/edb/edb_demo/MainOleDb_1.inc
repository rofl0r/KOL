{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 272, 112 ).SetSize( 383, 267 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnClose := Result.KOLForm1Close;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Load' ).SetPosition( 22, 8 ).SetSize( 0, 26 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.lvData.TabOrder = 1
    Result.lvData := NewListView( Result.Form, lvsDetail, [ lvoEditLabel, lvoRowSelect ], nil, nil, nil ).SetPosition( 22, 40 ).SetSize( 331, 185 );
      Result.lvData.OnKeyDown := Result.lvDataKeyDown;
      Result.lvData.OnEndEditLVItem := Result.lvDataEndEditLVItem;
    // Result.Button2.TabOrder = 2
    Result.Button2 := NewButton( Result.Form, 'Save' ).SetPosition( 98, 8 ).SetSize( 0, 25 );
    Result.Button2.Enabled := False;
      Result.Button2.OnClick := Result.Button2Click;
    Result.KOLForm1FormCreate( Result );

end;

