{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontCharset := 0;
    Result.Form.Border := 0;
    // Result.ComboBox1.TabOrder = 1
    Result.ComboBox1 := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 8, 296 );
      Result.ComboBox1.OnMouseMove := Result.BB2MouseMove;
    Result.ComboBox1.Items[ 0 ] := 'ComboBox1';
    Result.ComboBox1.CurIndex := 0;
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esRaised ).SetAlign ( caBottom ).SetSize( 0, 29 );
    Result.Panel1.Border := 2;
      Result.Panel1.OnMouseMove := Result.BB2MouseMove;
    Result.Panel1.Caption := 'Panel1';
    // Result.BB.TabOrder = 1
      Result.BB := NewBitBtn( Result.Panel1, 'BitBtn1', [  ], glyphLeft, 0, 0 ).SetPosition( -1, -1 ).SetSize( 65, 0 ).LikeSpeedButton;
      Result.BB.OnMouseMove := Result.BB2MouseMove;
    // Result.EditBox1.TabOrder = 4
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 8, 328 );
      Result.EditBox1.OnMouseMove := Result.BB2MouseMove;
    Result.EditBox1.Text := 'EditBox1';
    // Result.CheckBox1.TabOrder = 5
    Result.CheckBox1 := NewCheckBox( Result.Form, 'CheckBox1' ).SetPosition( 8, 368 );
      Result.CheckBox1.OnMouseMove := Result.BB2MouseMove;
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;

