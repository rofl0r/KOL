{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 192, 101 ).SetClientSize( 427, 273 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := 8;
    Result.Form.Border := 0;

    Result.HintRA2 := NewHintRA; {RA}
    Result.HintRA2.HintText:='Строка1'+#13#10+'Строка2'+#13#10+'Строка3'+#13#10+'Строка4'; {RA}
  Result.Form.Add2AutoFree( Result.HintRA2 );

    Result.HintRA3 := NewHintRA; {RA}
    Result.HintRA3.HintText:='Цветной'+#13#10+'Hint'; {RA}
    Result.HintRA3.Color := clYellow; {RA}
    Result.HintRA3.BkColor := clBlue; {RA}
  Result.Form.Add2AutoFree( Result.HintRA3 );

    Result.HintRA6 := NewHintRA; {RA}
    Result.HintRA6.HintText:='Hello!!!'; {RA}
  Result.Form.Add2AutoFree( Result.HintRA6 );

    Result.HintRA7 := NewHintRA; {RA}
    Result.HintRA7.HintText:='Hint'+#13#10+'for Form'; {RA}
    Result.HintRA7.Color := clYellow; {RA}
    Result.HintRA7.BkColor := clBlack; {RA}
  Result.Form.Add2AutoFree( Result.HintRA7 );

    Result.HintRA8 := NewHintRA; {RA}
    Result.HintRA8.HintText:='DoNotHide'; {RA}
    Result.HintRA8.HideHintOnDelay := False; {RA}
  Result.Form.Add2AutoFree( Result.HintRA8 );

    Result.HintRA5 := NewHintRA; {RA}
    Result.HintRA5.HintText:='yt'; {RA}
  Result.Form.Add2AutoFree( Result.HintRA5 );
      Result.HintRA5.OnBeforeShowHint := Result.HintRA5BeforeShowHint;

    Result.HintRA9 := NewHintRA; {RA}
    Result.HintRA9.HintText:='HINT'+#13#10+'FOR'+#13#10+'KOL_MCK'; {RA}
    Result.HintRA9.BkColor := clSilver; {RA}
    Result.HintRA9.HideHintOnDelay := False; {RA}
  Result.Form.Add2AutoFree( Result.HintRA9 );

    Result.HintRA1 := NewHintRA; {RA}
    Result.HintRA1.HintText:='All Standart'; {RA}
  Result.Form.Add2AutoFree( Result.HintRA1 );

    Result.HintRA4 := NewHintRA; {RA}
    Result.HintRA4.HintText:='MoveHint:=True'; {RA}
    Result.HintRA4.Color := clAqua; {RA}
    Result.HintRA4.BkColor := clBlack; {RA}
    Result.HintRA4.MoveHint := True; {RA}
  Result.Form.Add2AutoFree( Result.HintRA4 );

    Result.HintRA10 := NewHintRA; {RA}
    Result.HintRA10.HintText:='Panel1'; {RA}
  Result.Form.Add2AutoFree( Result.HintRA10 );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Текст Hint''a:' ).SetPosition( 226, 24 ).AutoSize( TRUE );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Здесь стандартный Hint' ).SetPosition( 26, 6 ).AutoSize( TRUE );
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Многострочный Hint' ).SetPosition( 34, 42 ).AutoSize( TRUE );
    // Result.Button3.TabOrder = 2
    Result.Button3 := NewButton( Result.Form, 'Цвета Hint''а изменены' ).SetPosition( 24, 74 ).AutoSize( TRUE );
    // Result.Button4.TabOrder = 3
    Result.Button4 := NewButton( Result.Form, 'Подвижный Hint' ).SetPosition( 30, 110 ).AutoSize( TRUE );
    // Result.EditBox1.TabOrder = 4
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 298, 18 ).SetSize( 113, 0 );
    Result.EditBox1.Color := clWindow;
    Result.EditBox1.Text := 'Некоторый текст';
    // Result.Button6.TabOrder = 6
    Result.Button6 := NewButton( Result.Form, 'При нажатии на кнопку уменьшется Delay показа Hint''a в 2 раза' ).SetPosition( 34, 158 ).AutoSize( TRUE );
    // Result.Button7.TabOrder = 7
    Result.Button7 := NewButton( Result.Form, 'Здесь Hint не исчезает по истечению Delay' ).SetPosition( 10, 194 ).AutoSize( TRUE );
    // Result.Button8.TabOrder = 8
    Result.Button8 := NewButton( Result.Form, 'Мигающий Hint' ).SetPosition( 28, 230 ).AutoSize( TRUE );
    // Result.Panel1.TabOrder = 9
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetPosition( 236, 50 ).SetSize( 159, 73 );
    Result.Panel1.Border := 2;
    // Result.Button5.TabOrder = 5
      Result.Button5 := NewButton( Result.Panel1, 'Текст задается' ).SetPosition( 30, 19 ).AutoSize( TRUE );
    Result.HintRA2.KOLControl := Result.Button2; {RA}
    Result.HintRA3.KOLControl := Result.Button3; {RA}
      Result.Button6.OnClick := Result.Button6Click;
    Result.HintRA6.KOLControl := Result.Button6; {RA}
    Result.HintRA8.KOLControl := Result.Button7; {RA}
    Result.HintRA5.KOLControl := Result.Button5; {RA}
    Result.HintRA9.KOLControl := Result.Button8; {RA}
    Result.HintRA1.KOLControl := Result.Button1; {RA}
    Result.HintRA4.KOLControl := Result.Button4; {RA}
    Result.HintRA10.KOLControl := Result.Panel1; {RA}
    Result.KOLForm1FormCreate( Result );

end;

