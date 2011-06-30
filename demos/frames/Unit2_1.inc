{ KOL MCK } // Do not remove this line!

procedure NewForm2( var Result: PForm2; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewPanel( AParent, esNone ).SetAlign( caClient).SetSize( 511, 282 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Color := clWindow ;
      Result.Form.OnDestroy := Result.KOLFrame1Destroy;
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewWordWrapLabel( Result.Form, 'Example of frame dynamic creation / destruction' ).SetPosition( 72, 56 ).SetSize( 289, 129 );
    // Result.Button1.TabOrder = 0
    Result.Button1 := NewButton( Result.Form, 'Remove me' ).SetPosition( 72, 24 ).SetSize( 185, 0 );
      Result.Button1.OnClick := Result.Button1Click;
    Result.Form.CreateWindow;

end;

