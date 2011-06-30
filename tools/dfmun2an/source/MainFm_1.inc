{ KOL MCK } // Do not remove this line!

procedure NewMainForm( var Result: PMainForm; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Dfm Unicode To Ansi v1.01' ).SetPosition( 222, 140 ).SetClientSize( 295, 133 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.IconLoad( hInstance, 'UA' );
    Result.Form.Font.FontHeight := -11;
      Result.Form.OnShow := Result.KOLForm1Show;

    Result.OpenDirDialog1 := NewOpenDirDialog( 'Выберите каталог с dfm-файлами:', [  ] );
      Result.OpenDirDialog1.CenterOnScreen := TRUE;
  Result.Form.Add2AutoFree( Result.OpenDirDialog1 );
    // Result.lDir.TabOrder = -1
    Result.lDir := NewLabel( Result.Form, '' ).SetPosition( 8, 24 ).SetSize( 257, 17 );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Каталог:' ).SetPosition( 8, 8 ).SetSize( 49, 17 );
    // Result.bOpenDir.TabOrder = 0
    Result.bOpenDir := NewButton( Result.Form, 'Выбрать каталог' ).SetPosition( 16, 80 ).SetSize( 153, 0 );
    // Result.bGo.TabOrder = 1
    Result.bGo := NewButton( Result.Form, 'Перевести' ).SetPosition( 192, 80 ).SetSize( 89, 0 );
    // Result.ProgressBar1.TabOrder = 2
    Result.ProgressBar1 := NewProgressBar( Result.Form ).SetPosition( 8, 48 ).SetSize( 281, 0 );
      Result.bOpenDir.OnClick := Result.bOpenDirClick;
      Result.bGo.OnClick := Result.bGoClick;
      Result.OpenDirDialog1.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CanResize := False;
    Result.KOLForm1FormCreate( Result );

end;

