{ KOL MCK } // Do not remove this line!

procedure NewForm3( var Result: PForm3; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form3' ).SetPosition( 262, 112 ).SetSize( 696, 480 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.Font.Color := clBlack;

    Result.Report1 := NewReport;
    Result.Report1.DoubleBufferedPreview := TRUE;
    Result.Report1.DocumentName := 'Test';
  Result.Form.Add2AutoFree( Result.Report1 );
      Result.Report1.OnPrint := Result.Report1Print;
      Result.Report1.OnNewPage := Result.Report1NewPage;
    // Result.BandPagenumber.TabOrder = 0
    Result.BandPagenumber := NewBand( Result.Form, [frBottom] ).SetPosition( 280, 8 ).SetSize( 400, 19 );
    Result.BandPagenumber.Color := clWhite;
    Result.BandPagenumber.TextAlign := taRight;
    Result.BandPagenumber.Border := 1;
    Result.BandPagenumber.Caption := 'Page 1';
    // Result.BandTitle.TabOrder = 1
    Result.BandTitle := NewBand( Result.Form, [frLeft,frTop,frRight,frBottom] ).SetPosition( 112, 40 ).SetSize( 393, 89 );
    Result.BandTitle.Color := clWhite;
    Result.BandTitle.Border := 0;
    // Result.ReportLabel1.TabOrder = -1
      Result.ReportLabel1 := NewWordWrapReportLabel( Result.BandTitle, 'Sample Report to see what can be done with KOLReport', [] ).SetAlign ( caClient ).AutoSize( FALSE );
    Result.ReportLabel1.Font.FontStyle := [ fsBold ];
    Result.ReportLabel1.Font.FontHeight := 32;
    Result.ReportLabel1.Font.FontName := 'Arial';
    Result.ReportLabel1.TextAlign := taCenter;
      Result.ReportLabel1.Border := 1;
    // Result.BandMaster.TabOrder = 2
    Result.BandMaster := NewBand( Result.Form, [] ).SetPosition( 16, 160 ).SetSize( 400, 40 );
    Result.BandMaster.Color := clWhite;
    Result.BandMaster.Font.FontName := 'Arial';
    Result.BandMaster.Border := 1;
    // Result.Master1.TabOrder = -1
      Result.Master1 := NewReportLabel( Result.BandMaster, 'Master', [] ).SetPosition( 16, 8 );
      Result.Master1.Tag := 123;
    Result.Master1.Color := clWhite;
    Result.Master1.Font.FontStyle := [ fsBold ];
    // Result.Master2.TabOrder = -1
      Result.Master2 := NewReportLabel( Result.BandMaster, 'Data', [] ).SetPosition( 192, 8 );
    Result.Master2.Color := clWhite;
    // Result.BandColumns.TabOrder = 3
    Result.BandColumns := NewBand( Result.Form, [frLeft,frTop,frRight,frBottom] ).SetPosition( 16, 216 ).SetSize( 625, 25 );
    Result.BandColumns.Color := clWhite;
    Result.BandColumns.Font.FontName := 'Arial';
    Result.BandColumns.Border := 1;
    // Result.ReportLabel6.TabOrder = -1
      Result.ReportLabel6 := NewReportLabel( Result.BandColumns, 'Date', [frLeft] ).SetAlign ( caRight ).AutoSize( FALSE ).SetSize( 102, 0 );
    Result.ReportLabel6.Color := clWhite;
    Result.ReportLabel6.TextAlign := taCenter;
    Result.ReportLabel6.VerticalAlign := vaCenter;
    // Result.ReportLabel2.TabOrder = -1
      Result.ReportLabel2 := NewReportLabel( Result.BandColumns, '#', [] ).SetAlign ( caLeft ).AutoSize( FALSE ).SetSize( 24, 0 );
    Result.ReportLabel2.Color := clWhite;
    Result.ReportLabel2.TextAlign := taCenter;
    Result.ReportLabel2.VerticalAlign := vaCenter;
    // Result.ReportLabel4.TabOrder = -1
      Result.ReportLabel4 := NewReportLabel( Result.BandColumns, 'Last Name', [frLeft] ).SetAlign ( caClient ).AutoSize( FALSE );
    Result.ReportLabel4.Color := clWhite;
    Result.ReportLabel4.TextAlign := taCenter;
    Result.ReportLabel4.VerticalAlign := vaCenter;
    // Result.ReportLabel3.TabOrder = -1
      Result.ReportLabel3 := NewReportLabel( Result.BandColumns, 'First Name', [frLeft] ).SetAlign ( caLeft ).AutoSize( FALSE ).SetSize( 165, 0 );
    Result.ReportLabel3.Color := clWhite;
    Result.ReportLabel3.TextAlign := taCenter;
    Result.ReportLabel3.VerticalAlign := vaCenter;
    // Result.ReportLabel5.TabOrder = -1
      Result.ReportLabel5 := NewReportLabel( Result.BandColumns, 'Amount', [frLeft] ).SetAlign ( caRight ).AutoSize( FALSE ).SetSize( 135, 0 );
    Result.ReportLabel5.Color := clWhite;
    Result.ReportLabel5.TextAlign := taCenter;
    Result.ReportLabel5.VerticalAlign := vaCenter;
    // Result.BandCompany.TabOrder = 3
    Result.BandCompany := NewBand( Result.Form, [frLeft,frRight,frBottom] ).SetPosition( 16, 246 ).SetSize( 625, 25 );
    Result.BandCompany.Color := clWhite;
    Result.BandCompany.Font.FontName := 'Arial';
    Result.BandCompany.VerticalAlign := vaCenter;
    Result.BandCompany.Border := 1;
    Result.BandCompany.Caption := '   Company name';
    // Result.BandDetail.TabOrder = 3
    Result.BandDetail := NewBand( Result.Form, [] ).SetPosition( 17, 279 ).SetSize( 625, 25 );
    Result.BandDetail.Color := clWhite;
    Result.BandDetail.Font.FontName := 'Arial';
    Result.BandDetail.Border := 0;
    // Result.DetailDate.TabOrder = -1
      Result.DetailDate := NewReportLabel( Result.BandDetail, 'Date', [frLeft,frRight,frBottom] ).SetAlign ( caRight ).AutoSize( FALSE ).SetSize( 104, 0 );
    Result.DetailDate.Color := clWhite;
    Result.DetailDate.TextAlign := taCenter;
    Result.DetailDate.VerticalAlign := vaCenter;
      Result.DetailDate.Border := 1;
    // Result.DetailLName.TabOrder = -1
      Result.DetailLName := NewReportLabel( Result.BandDetail, 'Last Name', [frLeft,frBottom] ).SetAlign ( caClient ).AutoSize( FALSE );
    Result.DetailLName.Color := clWhite;
    Result.DetailLName.VerticalAlign := vaCenter;
      Result.DetailLName.Border := 1;
    // Result.DetailFName.TabOrder = -1
      Result.DetailFName := NewReportLabel( Result.BandDetail, 'First Name', [frLeft,frBottom] ).SetAlign ( caLeft ).AutoSize( FALSE ).SetSize( 165, 0 );
    Result.DetailFName.Color := clWhite;
    Result.DetailFName.VerticalAlign := vaCenter;
      Result.DetailFName.Border := 1;
    // Result.DetailN.TabOrder = -1
      Result.DetailN := NewReportLabel( Result.BandDetail, '#', [frLeft,frBottom] ).SetAlign ( caLeft ).AutoSize( FALSE ).SetSize( 24, 0 );
    Result.DetailN.Color := clWhite;
    Result.DetailN.TextAlign := taCenter;
    Result.DetailN.VerticalAlign := vaCenter;
      Result.DetailN.Border := 1;
    // Result.DetailAmt.TabOrder = -1
      Result.DetailAmt := NewReportLabel( Result.BandDetail, 'Amount', [frLeft,frBottom] ).SetAlign ( caRight ).AutoSize( FALSE ).SetSize( 135, 0 );
    Result.DetailAmt.Color := clWhite;
    Result.DetailAmt.TextAlign := taRight;
    Result.DetailAmt.VerticalAlign := vaCenter;
      Result.DetailAmt.Border := 1;

end;

