{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Icon := THandle(-1);

end;


