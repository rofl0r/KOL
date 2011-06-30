{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Convert Type Library (TLB) to KOL&MCK' ).SetPosition( 217, 107 ).SetSize( 520, 424 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;

    Result.OpenDialog1 := NewOpenSaveDialog( '', '', [  ] );
      Result.OpenDialog1.Filter := 'Type library unit (*.pas)|*.pas';
  Result.Form.Add2AutoFree( Result.OpenDialog1 );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Source unit (TLB):' ).SetPosition( 12, 11 ).SetSize( 109, 0 );
    // Result.EditBox1.TabOrder = 0
    Result.EditBox1 := NewEditBox( Result.Form, [  ] ).SetPosition( 132, 11 ).SetSize( 269, 0 );
      Result.EditBox1.OnChange := Result.EditBox1Change;
    // Result.BtnBrowse.TabOrder = 1
    Result.BtnBrowse := NewButton( Result.Form, 'Browse' ).SetPosition( 413, 11 ).SetSize( 88, 0 );
      Result.BtnBrowse.OnClick := Result.BtnBrowseClick;
    // Result.BtnStart.TabOrder = 2
    Result.BtnStart := NewButton( Result.Form, 'Start' ).SetPosition( 202, 100 ).SetSize( 109, 0 );
    Result.BtnStart.Enabled := False;
      Result.BtnStart.OnClick := Result.BtnStartClick;
    // Result.Memo1.TabOrder = 3
    Result.Memo1 := NewEditBox( Result.Form, [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetPosition( 13, 40 ).SetSize( 488, 345 );
    Result.Memo1.Visible := False;
    Result.Form.CanResize := False;

end;

