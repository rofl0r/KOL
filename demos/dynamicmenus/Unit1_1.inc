{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 324, 268 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Add main menu' ).SetPosition( 24, 32 ).SetSize( 129, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    // Result.Button2.TabOrder = 1
    Result.Button2 := NewButton( Result.Form, 'Add Item' ).SetPosition( 160, 32 ).SetSize( 129, 0 );
      Result.Button2.OnClick := Result.Button2Click;
    // Result.Button5.TabOrder = 2
    Result.Button5 := NewButton( Result.Form, 'Add Popupmenu as Submenu' ).SetPosition( 24, 144 ).SetSize( 265, 0 );
      Result.Button5.OnClick := Result.Button5Click;
    // Result.Button3.TabOrder = 2
    Result.Button3 := NewButton( Result.Form, 'Add Submenu' ).SetPosition( 24, 64 ).SetSize( 265, 0 );
      Result.Button3.OnClick := Result.Button3Click;
    // Result.Button6.TabOrder = 3
    Result.Button6 := NewButton( Result.Form, 'Remove Popupmenu from MainMenu' ).SetPosition( 24, 176 ).SetSize( 265, 0 );
      Result.Button6.OnClick := Result.Button6Click;
    // Result.Button4.TabOrder = 3
    Result.Button4 := NewButton( Result.Form, 'Delete SubMenu' ).SetPosition( 24, 96 ).SetSize( 265, 0 );
      Result.Button4.OnClick := Result.Button4Click;

end;


