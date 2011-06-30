{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Demo ForLPT' ).SetPosition( 195, 105 ).SetClientSize( 420, 273 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.Font.FontHeight := 8;
    Result.Form.Border := 0;

    Result.Timer1 := NewMMTimer( 1000 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'ClearLPT' ).SetPosition( 4, 4 );
    // Result.GroupBox1.TabOrder = 1
    Result.GroupBox1 := NewGroupBox( Result.Form, 'Мониторинг состояния входа LPT-порта (период=1 секунда)' ).SetPosition( 82, 6 ).SetSize( 335, 67 );
    Result.GroupBox1.TabStop := FALSE;
    Result.GroupBox1.Border := 2;
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.GroupBox1, 'ноги:' ).SetPosition( 8, 16 ).AutoSize( TRUE );
    // Result.EditBox1.TabOrder = 0
      Result.EditBox1 := NewEditBox( Result.GroupBox1, [ eoReadonly ] ).SetPosition( 40, 14 ).SetSize( 31, 19 );
    Result.EditBox1.Color := clWindow;
      Result.EditBox1.Text := '4321';
    // Result.EditBox2.TabOrder = 1
      Result.EditBox2 := NewEditBox( Result.GroupBox1, [  ] ).SetPosition( 40, 36 ).SetSize( 31, 0 );
    Result.EditBox2.Color := clWindow;
    // Result.GroupBox3.TabOrder = 2
    Result.GroupBox3 := NewGroupBox( Result.Form, 'Установка отдельных битов выхода порта' ).SetPosition( 2, 100 ).SetSize( 237, 107 );
    Result.GroupBox3.TabStop := FALSE;
    Result.GroupBox3.Border := 2;
    // Result.CheckBox5.TabOrder = 0
      Result.CheckBox5 := NewCheckBox( Result.GroupBox3, 'нога 5' ).SetPosition( 150, 16 );
      Result.CheckBox5.Tag := 5;
    // Result.CheckBox1.TabOrder = 0
      Result.CheckBox1 := NewCheckBox( Result.GroupBox3, 'нога 1' ).SetPosition( 6, 16 );
      Result.CheckBox1.Tag := 1;
    // Result.CheckBox6.TabOrder = 1
      Result.CheckBox6 := NewCheckBox( Result.GroupBox3, 'нога 6' ).SetPosition( 150, 36 );
      Result.CheckBox6.Tag := 6;
    // Result.CheckBox2.TabOrder = 1
      Result.CheckBox2 := NewCheckBox( Result.GroupBox3, 'нога 2' ).SetPosition( 6, 36 );
      Result.CheckBox2.Tag := 2;
    // Result.CheckBox7.TabOrder = 2
      Result.CheckBox7 := NewCheckBox( Result.GroupBox3, 'нога 7' ).SetPosition( 150, 56 );
      Result.CheckBox7.Tag := 7;
    // Result.CheckBox3.TabOrder = 2
      Result.CheckBox3 := NewCheckBox( Result.GroupBox3, 'нога 3' ).SetPosition( 6, 56 );
      Result.CheckBox3.Tag := 3;
    // Result.CheckBox4.TabOrder = 3
      Result.CheckBox4 := NewCheckBox( Result.GroupBox3, 'нога 4' ).SetPosition( 6, 76 );
      Result.CheckBox4.Tag := 4;
    // Result.CheckBox8.TabOrder = 3
      Result.CheckBox8 := NewCheckBox( Result.GroupBox3, 'нога 8' ).SetPosition( 150, 76 );
      Result.CheckBox8.Tag := 8;
    // Result.GroupBox2.TabOrder = 3
    Result.GroupBox2 := NewGroupBox( Result.Form, 'Значение ноги по запросу' ).SetPosition( 240, 76 ).SetSize( 177, 131 );
    Result.GroupBox2.TabStop := FALSE;
    Result.GroupBox2.Border := 2;
    // Result.Button3.TabOrder = 0
      Result.Button3 := NewButton( Result.GroupBox2, 'нога 1' ).SetPosition( 8, 16 ).SetSize( 51, 0 );
    // Result.Button4.TabOrder = 1
      Result.Button4 := NewButton( Result.GroupBox2, 'нога 2' ).SetPosition( 8, 44 ).SetSize( 51, 0 );
    // Result.Button5.TabOrder = 2
      Result.Button5 := NewButton( Result.GroupBox2, 'нога 3' ).SetPosition( 8, 72 ).SetSize( 51, 0 );
    // Result.Button6.TabOrder = 3
      Result.Button6 := NewButton( Result.GroupBox2, 'нога 4' ).SetPosition( 8, 100 ).SetSize( 51, 0 );
    // Result.EditBox3.TabOrder = 4
      Result.EditBox3 := NewEditBox( Result.GroupBox2, [  ] ).SetPosition( 76, 16 ).SetSize( 30, 0 );
    Result.EditBox3.Color := clWindow;
      Result.EditBox3.Text := 'none';
    // Result.EditBox4.TabOrder = 5
      Result.EditBox4 := NewEditBox( Result.GroupBox2, [  ] ).SetPosition( 76, 44 ).SetSize( 30, 0 );
    Result.EditBox4.Color := clWindow;
      Result.EditBox4.Text := 'none';
    // Result.EditBox5.TabOrder = 6
      Result.EditBox5 := NewEditBox( Result.GroupBox2, [  ] ).SetPosition( 76, 72 ).SetSize( 30, 23 );
    Result.EditBox5.Color := clWindow;
      Result.EditBox5.Text := 'none';
    // Result.EditBox6.TabOrder = 7
      Result.EditBox6 := NewEditBox( Result.GroupBox2, [  ] ).SetPosition( 76, 100 ).SetSize( 30, 21 );
    Result.EditBox6.Color := clWindow;
      Result.EditBox6.Text := 'none';
    // Result.GroupBox4.TabOrder = 4
    Result.GroupBox4 := NewGroupBox( Result.Form, 'Занести в порт байт' ).SetPosition( 2, 210 ).SetSize( 415, 63 );
    Result.GroupBox4.TabStop := FALSE;
    Result.GroupBox4.Border := 2;
    // Result.Label2.TabOrder = -1
      Result.Label2 := NewLabel( Result.GroupBox4, 'Байт:' ).SetPosition( 12, 30 ).AutoSize( TRUE );
    // Result.Button2.TabOrder = 0
      Result.Button2 := NewButton( Result.GroupBox4, 'Записать' ).SetPosition( 84, 24 );
    // Result.EditBox7.TabOrder = 1
      Result.EditBox7 := NewEditBox( Result.GroupBox4, [ eoNumber ] ).SetPosition( 42, 24 ).SetSize( 35, 0 );
    Result.EditBox7.Color := clWindow;
      Result.EditBox7.Text := '255';
      Result.Button2.OnClick := Result.Button2Click;
      Result.CheckBox5.OnClick := Result.CheckBox1Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button1.OnClick := Result.Button1Click;
      Result.CheckBox1.OnClick := Result.CheckBox1Click;
      Result.CheckBox2.OnClick := Result.CheckBox1Click;
      Result.Button4.OnClick := Result.Button4Click;
      Result.CheckBox6.OnClick := Result.CheckBox1Click;
      Result.CheckBox7.OnClick := Result.CheckBox1Click;
      Result.Button5.OnClick := Result.Button5Click;
      Result.CheckBox3.OnClick := Result.CheckBox1Click;
      Result.CheckBox4.OnClick := Result.CheckBox1Click;
      Result.CheckBox8.OnClick := Result.CheckBox1Click;
      Result.Button6.OnClick := Result.Button6Click;
    Result.Timer1.Enabled := True;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );
    Result.Form.Icon := THandle(-1);

end;

