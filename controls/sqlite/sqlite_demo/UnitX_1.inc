{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOL SQLite support demo' ).SetPosition( 192, 107 ).SetClientSize( 515, 362 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);

    Result.SLData := NewSLDataSource('test.db', False);
    Result.SLData.BusyTimeout := 1000;
  Result.Form.Add2AutoFree( Result.SLData );
      Result.SLData.OnBusy := Result.SLDataBusy;

    Result.SLSession := NewSLSession('SLSession',Result.SLData);
    Result.SLSession.IfConflict := cfRollback;
  Result.Form.Add2AutoFree( Result.SLSession );

    Result.SLQuery := NewSLQuery( Result.SLSession );
  Result.Form.Add2AutoFree( Result.SLQuery );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, '' ).SetPosition( 9, 0 ).SetSize( 504, 17 );
    // Result.LVData.TabOrder = 0
    Result.LVData := NewListView( Result.Form, lvsDetail, [ lvoOwnerData ], nil, nil, nil ).SetPosition( 8, 24 ).SetSize( 497, 145 );
    Result.LVData.Color := clWindow;
    // Result.Button1.TabOrder = 1
    Result.Button1 := NewButton( Result.Form, 'Close' ).SetPosition( 432, 320 ).SetSize( 81, 33 );
    // Result.SQLMemo.TabOrder = 2
    Result.SQLMemo := NewEditBox( Result.Form, [ eoMultiline, eoWantReturn ] ).SetPosition( 8, 184 ).SetSize( 425, 129 );
    Result.SQLMemo.Color := clWindow;
    Result.SQLMemo.Text := 'select * from Simpsons;'+#13+#10;
    // Result.Button2.TabOrder = 3
    Result.Button2 := NewButton( Result.Form, 'Execute SQL' ).SetPosition( 8, 320 ).SetSize( 161, 33 );
      Result.LVData.OnLVData := Result.LVDataLVData;
      Result.LVData.OnColumnClick := Result.LVDataColumnClick;
      Result.Button1.OnClick := Result.Button1Click;
    Result.Button1.CancelBtn := TRUE;
      Result.Button2.OnClick := Result.Button2Click;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );
    Result.Form.Perform(WM_SETICON, 1, 0);

end;

