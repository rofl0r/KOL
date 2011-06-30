{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'DDE client' ).SetPosition( 382, 133 ).SetSize( 175, 71 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.ddeconv := NewDDEClientConv( Result.Form );
    Result.ddeconv.ConnectMode := ddeAutomatic;
    Result.ddeconv.DdeService  := 'KOLap';
    Result.ddeconv.DdeTopic    := 'test_topic';
    Result.ddeconv.FormatChars := True;
    Result.ddeconv.ServiceApplication := 'KOLap';
  Result.Form.Add2AutoFree( Result.ddeconv );

    Result.ddeitem := NewDDEClientItem( Result.Form );
    Result.ddeitem.DdeConv := Result.ddeconv;
    Result.ddeitem.DdeItem := 'test_item';
  Result.Form.Add2AutoFree( Result.ddeitem );
      Result.ddeitem.OnChange := Result.OnChange;
    // Result.L1.TabOrder = -1
    Result.L1 := NewLabel( Result.Form, 'Label1' ).SetPosition( 8, 8 ).SetSize( 153, 0 );
    Result.L1.TextAlign := taCenter;
    Result.ddeconv.OpenLink;

end;


