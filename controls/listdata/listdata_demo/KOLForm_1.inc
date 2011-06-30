{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOLForm' ).SetPosition( 209, 135 ).SetSize( 627, 390 ).Tabulate;
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );

    Result.DS := NewDataSource(
    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=kn.mdb;Persist Security Inf' +
    'o=False');
  Result.Form.Add2AutoFree( Result.DS );

    Result.SS := NewSession( Result.DS );
  Result.Form.Add2AutoFree( Result.SS );

    Result.QR := NewQuery( Result.SS );
    Result.QR.Text := 'Select [code],[proc],[term],[debe],[cred] from kb';
  Result.Form.Add2AutoFree( Result.QR );
    // Result.LD.TabOrder = 0
    Result.LD := NewListData( Result.Form, lvsDetail, [ lvoRowSelect ], nil, nil, nil ).SetAlign ( caClient );
    Result.LD.Color := clWindow;
    Result.LD.LVColAdd('name',taLeft , 50);
    Result.LD.LVColAdd('proc',taRight , 100);
    Result.LD.LVColAdd('term',taRight , 100);
    Result.LD.LVColAdd('debe',taRight , 150);
    Result.LD.LVColAdd('cred',taRight , 150);
    Result.LD.Query := Result.QR;
    Result.LD.Open;

end;


