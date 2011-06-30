{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 123, 4 ).SetClientSize( 505, 412 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := 8;
    Result.Form.Border := 0;

    Result.OpenDialog1 := NewOpenSaveDialog( '', '', [  ] );
  Result.Form.Add2AutoFree( Result.OpenDialog1 );
    // Result.GroupBox1.TabOrder = 0
    Result.GroupBox1 := NewGroupBox( Result.Form, 'Any2Ten' ).SetAlign ( caTop ).SetSize( 0, 83 );
    Result.GroupBox1.TabStop := FALSE;
    Result.GroupBox1.Border := 2;
    // Result.Label2.TabOrder = -1
      Result.Label2 := NewLabel( Result.GroupBox1, 'Система счисления:' ).SetPosition( 16, 38 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.GroupBox1, 'Число:' ).SetPosition( 16, 16 ).AutoSize( TRUE );
    // Result.Label3.TabOrder = -1
      Result.Label3 := NewLabel( Result.GroupBox1, 'Число в 10-й системе счисления:' ).SetPosition( 208, 16 ).AutoSize( TRUE );
    // Result.EditBoxN1.TabOrder = 0
      Result.EditBoxN1 := NewEditBox( Result.GroupBox1, [  ] ).SetPosition( 52, 12 ).SetSize( 115, 0 );
    Result.EditBoxN1.Color := clWindow;
      Result.EditBoxN1.Text := 'FF';
    // Result.Button1.TabOrder = 1
      Result.Button1 := NewButton( Result.GroupBox1, 'Перевести в 10-ю    >' ).SetPosition( 18, 60 ).SetSize( 155, 17 );
    // Result.EditBoxS1.TabOrder = 2
      Result.EditBoxS1 := NewEditBox( Result.GroupBox1, [ eoNumber ] ).SetPosition( 126, 34 ).SetSize( 41, 0 );
    Result.EditBoxS1.Color := clWindow;
      Result.EditBoxS1.Text := '16';
    // Result.EditBoxO1.TabOrder = 3
      Result.EditBoxO1 := NewEditBox( Result.GroupBox1, [  ] ).SetPosition( 218, 40 ).SetSize( 139, 0 );
    Result.EditBoxO1.Color := clWindow;
      Result.EditBoxO1.Text := 'пусто';
    // Result.GroupBox2.TabOrder = 1
    Result.GroupBox2 := NewGroupBox( Result.Form, 'Ten2Any' ).SetAlign ( caTop ).SetSize( 0, 94 );
    Result.GroupBox2.TabStop := FALSE;
    Result.GroupBox2.Border := 2;
    // Result.Label5.TabOrder = -1
      Result.Label5 := NewLabel( Result.GroupBox2, 'Система счисления:' ).SetPosition( 16, 42 ).AutoSize( TRUE );
    // Result.Label4.TabOrder = -1
      Result.Label4 := NewLabel( Result.GroupBox2, 'Число в 10-й системе счисления:' ).SetPosition( 10, 18 ).AutoSize( TRUE );
    // Result.Label6.TabOrder = -1
      Result.Label6 := NewLabel( Result.GroupBox2, 'Число в заданной системе счисления:' ).SetPosition( 6, 68 ).AutoSize( TRUE );
    // Result.EditBoxN2.TabOrder = 0
      Result.EditBoxN2 := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 184, 14 ).SetSize( 179, 0 );
    Result.EditBoxN2.Color := clWindow;
      Result.EditBoxN2.Text := '12345';
    // Result.Button2.TabOrder = 1
      Result.Button2 := NewButton( Result.GroupBox2, 'Перевести в заданную систему счисления' ).SetPosition( 174, 42 ).SetSize( 243, 17 );
    // Result.EditBoxS2.TabOrder = 2
      Result.EditBoxS2 := NewEditBox( Result.GroupBox2, [ eoNumber ] ).SetPosition( 126, 38 ).SetSize( 41, 0 );
    Result.EditBoxS2.Color := clWindow;
      Result.EditBoxS2.Text := '16';
    // Result.EditBoxO2.TabOrder = 3
      Result.EditBoxO2 := NewEditBox( Result.GroupBox2, [  ] ).SetPosition( 204, 64 ).SetSize( 205, 0 );
    Result.EditBoxO2.Color := clWindow;
      Result.EditBoxO2.Text := 'пусто';
    // Result.GroupBox3.TabOrder = 2
    Result.GroupBox3 := NewGroupBox( Result.Form, 'Ten2Two' ).SetAlign ( caTop ).SetSize( 0, 98 );
    Result.GroupBox3.TabStop := FALSE;
    Result.GroupBox3.Border := 2;
    // Result.Label8.TabOrder = -1
      Result.Label8 := NewLabel( Result.GroupBox3, 'Количество бит' ).SetPosition( 16, 42 ).AutoSize( TRUE );
    // Result.Label7.TabOrder = -1
      Result.Label7 := NewLabel( Result.GroupBox3, 'Число в 10-й системе счисления:' ).SetPosition( 10, 18 ).AutoSize( TRUE );
    // Result.Label9.TabOrder = -1
      Result.Label9 := NewLabel( Result.GroupBox3, 'Число в двоичной системе счисления:' ).SetPosition( 4, 70 ).AutoSize( TRUE );
    // Result.EditBoxN3.TabOrder = 0
      Result.EditBoxN3 := NewEditBox( Result.GroupBox3, [ eoNumber ] ).SetPosition( 184, 14 ).SetSize( 179, 0 );
    Result.EditBoxN3.Color := clWindow;
      Result.EditBoxN3.Text := '128';
    // Result.Button3.TabOrder = 1
      Result.Button3 := NewButton( Result.GroupBox3, 'Перевести в двоичную систему счисления' ).SetPosition( 174, 42 ).SetSize( 243, 17 );
    // Result.EditBoxS3.TabOrder = 2
      Result.EditBoxS3 := NewEditBox( Result.GroupBox3, [ eoNumber ] ).SetPosition( 100, 38 ).SetSize( 41, 0 );
    Result.EditBoxS3.Color := clWindow;
      Result.EditBoxS3.Text := '8';
    // Result.EditBoxO3.TabOrder = 3
      Result.EditBoxO3 := NewEditBox( Result.GroupBox3, [  ] ).SetPosition( 208, 66 ).SetSize( 205, 0 );
    Result.EditBoxO3.Color := clWindow;
      Result.EditBoxO3.Text := 'пусто';
    // Result.GroupBox4.TabOrder = 3
    Result.GroupBox4 := NewGroupBox( Result.Form, 'GetDPNE AddExt' ).SetAlign ( caClient );
    Result.GroupBox4.TabStop := FALSE;
    // Result.Button4.TabOrder = 0
      Result.Button4 := NewButton( Result.GroupBox4, 'Файл ...' ).SetPosition( 12, 18 );
    // Result.EditBox1.TabOrder = 1
      Result.EditBox1 := NewEditBox( Result.GroupBox4, [  ] ).SetPosition( 10, 48 ).SetSize( 225, 0 );
    Result.EditBox1.Color := clWindow;
      Result.EditBox1.Text := 'c:\Mydir\MyFile.doc';
    // Result.ListBox1.TabOrder = 2
      Result.ListBox1 := NewEditBox( Result.GroupBox4, [ eoMultiline ] ).SetAlign ( caRight ).SetSize( 265, 0 );
    Result.ListBox1.Color := clWindow;
    // Result.Button5.TabOrder = 3
      Result.Button5 := NewButton( Result.GroupBox4, 'Добавить расширение' ).SetPosition( 8, 78 ).SetSize( 123, 0 );
    // Result.EditBox2.TabOrder = 4
      Result.EditBox2 := NewEditBox( Result.GroupBox4, [  ] ).SetPosition( 136, 78 ).SetSize( 63, 0 );
    Result.EditBox2.Color := clWindow;
      Result.EditBox2.Text := 'doc';
    // Result.Button6.TabOrder = 5
      Result.Button6 := NewButton( Result.GroupBox4, 'Вычислить все >' ).SetPosition( 10, 106 ).SetSize( 223, 0 );
      Result.Button4.OnClick := Result.Button4Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button5.OnClick := Result.Button5Click;
      Result.Button6.OnClick := Result.Button6Click;
      Result.OpenDialog1.WndOwner := Result.Form.GetWindowHandle;

end;

