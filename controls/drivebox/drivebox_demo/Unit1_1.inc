{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.CreateParented( Applet );
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'BAPDriveBox v1.04' ).SetPosition( 220, 100 ).SetClientSize( 256, 179 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.Font.FontHeight := 8;
      Result.Form.OnShow := Result.KOLForm1Show;

    Result.ColorDialog1 := NewColorDialog( ccoShortOpen );
  Result.Form.Add2AutoFree( Result.ColorDialog1 );
    // Result.lVol.TabOrder = -1
    Result.lVol := NewLabel( Result.Form, '' ).SetPosition( 104, 44 ).SetSize( 137, 17 );
    Result.lVol.Font.FontStyle := [ fsBold ];
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Метка диска:' ).SetPosition( 8, 40 ).SetSize( 81, 17 );
    Result.Label1.Font.FontStyle := [ fsBold ];
    Result.Label1.VerticalAlign := vaCenter;
    // Result.lLabel.TabOrder = -1
    Result.lLabel := NewLabel( Result.Form, '' ).SetPosition( 8, 66 ).SetSize( 89, 17 );
    Result.lLabel.VerticalAlign := vaCenter;
    // Result.lDrive.TabOrder = -1
    Result.lDrive := NewLabel( Result.Form, '' ).SetPosition( 80, 6 ).SetSize( 17, 25 );
    Result.lDrive.Font.FontStyle := [ fsBold ];
    Result.lDrive.VerticalAlign := vaCenter;
    // Result.BAPDriveBox1.TabOrder = 0
    Result.BAPDriveBox1 := NewBAPDriveBox(Result.Form, False);
    Result.BAPDriveBox1.SetPosition( 8, 8 ).SetSize( 62, 24 );
    Result.BAPDriveBox1.Color := clWindow;
    // Result.ebVol.TabOrder = 1
    Result.ebVol := NewEditBox( Result.Form, [  ] ).SetPosition( 104, 64 ).SetSize( 105, 0 );
    Result.ebVol.Color := clWindow;
    // Result.bSetVol.TabOrder = 2
    Result.bSetVol := NewButton( Result.Form, 'OK' ).SetPosition( 216, 64 ).SetSize( 32, 0 );
    // Result.CheckBox1.TabOrder = 3
    Result.CheckBox1 := NewCheckBox( Result.Form, 'Подсвечивать иконку' ).SetPosition( 8, 94 ).SetSize( 129, 0 );
    // Result.Button3.TabOrder = 4
    Result.Button3 := NewButton( Result.Form, 'Открыть DriveBox' ).SetPosition( 144, 96 ).SetSize( 105, 0 );
    // Result.Button1.TabOrder = 5
    Result.Button1 := NewButton( Result.Form, 'Цвет тектса выделенного элемента' ).SetPosition( 8, 122 ).SetSize( 241, 0 );
    // Result.Button2.TabOrder = 6
    Result.Button2 := NewButton( Result.Form, 'Цвет фона выделенного элемента' ).SetPosition( 8, 152 ).SetSize( 185, 0 );
    // Result.Button4.TabOrder = 7
    Result.Button4 := NewButton( Result.Form, 'Update' ).SetPosition( 200, 152 ).SetSize( 49, 0 );
    // Result.BAPDriveBox2.TabOrder = 8
    Result.BAPDriveBox2 := NewBAPDriveBox(Result.Form, True, clTeal);
    Result.BAPDriveBox2.SetPosition( 104, 8 ).SetSize( 145, 24 );
    Result.BAPDriveBox2.Color := clWindow;
      Result.BAPDriveBox1.OnChangeDrive := Result.BAPDriveBox1ChangeDrive;
      Result.BAPDriveBox1.OnChangeDriveLabel := Result.BAPDriveBox1ChangeDriveLabel;
      Result.bSetVol.OnClick := Result.bSetVolClick;
      Result.CheckBox1.OnClick := Result.CheckBox1Click;
      Result.Button3.OnClick := Result.Button3Click;
      Result.Button1.OnClick := Result.Button1Click;
      Result.Button2.OnClick := Result.Button2Click;
      Result.Button4.OnClick := Result.Button4Click;
    Result.Form.CanResize := False;

end;

