{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 198, 176 ).SetSize( 404, 348 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Form1';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );
    // Result.CB.TabOrder = 0
    Result.CB := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetAlign ( caTop );
    Result.CB.Color := clWindow;
      Result.CB.OnClick := Result.CBClick;
      Result.CB.OnKeyDown := Result.CBKeyDown;
      Result.CB.OnSelChange := Result.CBSelChange;
    Result.CB.Items[ 0 ] := 'desktop.htm';
    Result.CB.Items[ 1 ] := 'http://www.bonanzas.rinet.ru/';
    Result.CB.CurIndex := 0;
    // Result.DHTML.TabOrder = 1
    Result.DHTML := NewDHTMLEDIT(Result.Form);
    Result.DHTML.SetAlign(caClient);
    Result.DHTML.BrowseMode := True;

end;


