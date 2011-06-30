{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 249, 286 );
  Result.Form.Add2AutoFree( Result );
    // Result.ListView1.TabOrder = 0
    Result.ListView1 := NewListView( Result.Form, lvsIcon, [  ], nil, nil, nil ).SetPosition( 20, 64 );
      Result.ListView1.OnMessage := Result.ListView1Message;
    Result.ListView1.LVBkColor := clBtnFace;
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Button1' ).SetPosition( 138, 16 );
      Result.Button1.OnClick := Result.Button1Click;
    Result.KOLForm1FormCreate( Result );

end;

