{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'DDE server' ).SetPosition( 195, 133 ).SetSize( 184, 73 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.Timer1 := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;

    Result.test_topic := NewDDEServerConv( Result.Form );
    Result.test_topic.Name := 'test_topic';
  Result.Form.Add2AutoFree( Result.test_topic );

    Result.test_item := NewDDEServerItem( Result.Form );
    Result.test_item.Name := 'test_item';
    Result.test_item.Conv := Result.test_topic;
  Result.Form.Add2AutoFree( Result.test_item );
    // Result.L1.TabOrder = -1
    Result.L1 := NewLabel( Result.Form, 'Label1' ).SetPosition( 8, 8 ).SetSize( 161, 0 );
    Result.L1.TextAlign := taCenter;
    Result.Timer1.Enabled := True;

end;


