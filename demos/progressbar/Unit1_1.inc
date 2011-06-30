{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 228, 107 ).SetSize( 336, 216 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Progress' ).SetPosition( 122, 96 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'MaxProgress' ).SetPosition( 12, 96 ).AutoSize( TRUE );
    // Result.ProgressBar1.TabOrder = 0
    Result.ProgressBar1 := NewProgressBarEx( Result.Form, [ pboSmooth ] ).SetPosition( 12, 40 );
    Result.ProgressBar1.ProgressColor := clRed;
    Result.ProgressBar1.ProgressBkColor := clBlack;
    // Result.EditBox1.TabOrder = 1
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 12, 120 ).SetSize( 97, 0 );
    Result.EditBox1.Text := '100';
    // Result.EditBox2.TabOrder = 2
    Result.EditBox2 := NewEditBox( Result.Form, [  ] ).SetPosition( 120, 120 ).SetSize( 99, 0 );
    Result.EditBox2.Text := '0';
    // Result.Button1.TabOrder = 3
    Result.Button1 := NewButton( Result.Form, 'Set' ).SetPosition( 230, 120 );
      Result.Button1.OnClick := Result.Button1Click;

end;

