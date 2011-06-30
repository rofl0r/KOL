{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 195, 133 ).SetSize( 455, 333 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    // Result.LE.TabOrder = 0
    Result.LE := NewListEdit( Result.Form, lvsDetail, [ lvoIconLeft, lvoGridLines, lvoCheckBoxes, lvoRowSelect, lvoOneClickActivate, lvoInfoTip, lvoUnderlineHot, lvoMultiWorkares ], nil, nil, nil ).SetAlign ( caClient );
    Result.LE.Color := clBtnFace;
      Result.LE.Font.Color := clPurple;
      Result.LE.Font.FontStyle := [ fsBold, fsItalic ];
      Result.LE.Font.FontHeight := 20;
      Result.LE.Font.FontName := 'Arial';
      Result.LE.Font.FontCharset := 204;
    Result.LE.LVTextColor := clPurple;
    Result.LE.LVColAdd('Col1',taCenter , 80);
    Result.LE.LVColAdd('Col2',taCenter , 60);
    Result.LE.LVColAdd('Col3',taLeft , 60);
    Result.LE.LVColAdd('Col4',taRight , 60);
    Result.LE.LVColAdd('Col5',taLeft , 80);
    Result.LE.LVColAdd('Col6',taCenter , 95);
    Result.KOLFormFormCreate( Result );

end;


