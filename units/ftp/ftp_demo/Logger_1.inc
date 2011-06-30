{ KOL MCK } // Do not remove this line!

procedure NewForm3( var Result: PForm3; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm3.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Protocol' ).SetPosition( 425, 492 ).SetClientSize( 591, 212 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.SizeGrip := FALSE;
    Result.Form.Visible := False;
    Result.Form.DoubleBuffered := True;
    Result.Form.Font.FontCharset := 0;
      Result.Form.OnClose := Result.KFClose;

    Result.FormSave1 := NewFormSave(Result.Form);
    Result.FormSave1.Registry := True;
    Result.FormSave1.Section  := 'Form3';
    Result.FormSave1.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FormSave1 );
    // Result.LM.TabOrder = 0
    Result.LM := NewEditBox( Result.Form, [ eoMultiline ] ).SetAlign ( caClient );
    Result.LM.DoubleBuffered := True;
    Result.LM.Text := ''+#13+#10;

end;

