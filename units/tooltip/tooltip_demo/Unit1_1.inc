{ KOL MCK } // Do not remove this line!
const TB1 = 0;
const TB2 = 1;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'ToolTip''s Demo' );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontCharset := 0;
    Result.Form.Border := 0;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Under ME!' ).SetPosition( 180, 223 );
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetPosition( 8, 8 ).SetSize( 377, 209 );
    Result.Panel1.Border := 2;
    // Result.Label1.TabOrder = -1
      Result.Label1 := NewLabel( Result.Panel1, 'Label1' ).SetPosition( 13, 29 );
    // Result.MHUpDown1.TabOrder = 0
      Result.MHUpDown1 := PMHUpDown( NewMHUpDown( Result.Panel1, udVertical, False, False, False, False, False,True,udRight ).SetPosition( 133, 77 ).SetSize( 22, 0 ));
      Result.MHUpDown1.Max:=100;
      Result.MHUpDown1.Min:=0;
    // Result.EditBox1.TabOrder = 1
      Result.EditBox1 := NewEditBox( Result.Panel1, [  ] ).SetPosition( 77, 29 );
    Result.EditBox1.Color := clWindow;
      Result.EditBox1.Text := 'EditBox1';
    // Result.Toolbar1.TabOrder = 2
      Result.Toolbar1 := NewToolbar( Result.Panel1, caTop, [], 0, [ 'dfgdfgdf', 'dfgdfgdf' ], [ -2 ] ).SetAlign ( caTop );
    // Result.CheckBox1.TabOrder = 4
      Result.CheckBox1 := NewCheckBox( Result.Panel1, 'CheckBox1' ).SetPosition( 14, 53 );
      Result.Button1.OnClick := Result.Button1Click;
    Result.MHUpDown1.Width := 22;
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;


