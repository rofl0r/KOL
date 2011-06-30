{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 208, 124 ).SetSize( 362, 309 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.Border := 6;
    // Result.Memo1.TabOrder = 0
    Result.Memo1 := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll ] ).SetAlign ( caClient );
    Result.Memo1.Color := clWindow;
    Result.Memo1.Text := ''
 + 'To create splash form:'+#13+#10+'1. Add new form to a project (File|New Form, save it and'
 + ' drop TKOLForm component on it).'+#13+#10+'2. Remove this form from auto-create sequence '
 + '( Project|Options|Forms...|[>] ).'+#13+#10+'3. Add a code, which creates and shows splash'
 + ' form, in OnFormCreate of the main form.'+#13+#10+'4. It is a good idea to make main form'
 + ' initially ivisible, and make it visible after the finishing initialization proc'
 + 'ess.'+#13+#10
;
    Result.KOLForm1FormCreate( Result );

end;


