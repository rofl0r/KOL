{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 195, 133 ).SetSize( 422, 333 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form1';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );

end;


