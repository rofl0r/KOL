{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 251, 250 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.StayOnTop := True;
    // Result.CheckBox1.TabOrder = 0
    Result.CheckBox1 := NewCheckBox( Result.Form, 'Stay On Top' ).SetPosition( 40, 64 ).SetSize( 157, 0 );
    Result.CheckBox1.TabStop := FALSE;
      Result.CheckBox1.OnClick := Result.CheckBox1Click;
    Result.CheckBox1.Checked := TRUE;

end;

