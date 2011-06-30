{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form2' ).SetPosition( 336, 267 ).SetSize( 336, 241 );
  Result.Form.Add2AutoFree( Result );

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form2';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );

end;

