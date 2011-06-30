{ KOL MCK } // Do not remove this line!

procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'KOL FTP client' ).SetPosition( 195, 127 ).SetSize( 652, 371 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.DoubleBuffered := True;
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
    Result.Form.StatusText[ 0 ] := ' ';
    Result.Form.StatusText[ 1 ] := ' ';
    Result.Form.StatusText[ 2 ] := ' ';
    Result.Form.StatusText[ 3 ] := ' ';
      Result.Form.OnMessage := Result.KFMessage;
      Result.Form.OnClose := Result.KFClose;
      Result.Form.OnResize := Result.KFResize;
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.PL := NewMenu( Result.Form, 0, [ 'Select All'
      , 'Deselect All', '-', 'Add to transfer list'
      , 'Delete selected', '' ], nil );
    Result.PL.AssignEvents( 0, [ Result.PLN1Menu ] );
    Result.PL.AssignEvents( 1, [ Result.PLN2Menu ] );
    Result.PL.AssignEvents( 2, [ Result.PLN4Menu ] );
    Result.PL.AssignEvents( 3, [ Result.PLN9Menu ] );

    Result.PT := NewMenu( Result.Form, 0, [ 'Select All'
      , 'Deselect All', '-', 'Delete from list', '' ], nil );
    Result.PT.AssignEvents( 0, [ Result.PTN5Menu ] );
    Result.PT.AssignEvents( 1, [ Result.PTN6Menu ] );
    Result.PT.AssignEvents( 2, [ Result.PTN8Menu ] );

    Result.TM := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.TM );
      Result.TM.OnTimer := Result.TMTimer;

    Result.FC := NewKOLFtpClient;
  Result.Form.Add2AutoFree( Result.FC );
      Result.FC.OnFTPStatus := Result.FCFTPStatus;
      Result.FC.OnFTPLogger := Result.FTPLogger;
      Result.FC.OnFTPConnect := Result.FTPConnect;
      Result.FC.OnFTPLogin := Result.FTPLogin;
      Result.FC.OnFTPError := Result.FTPError;
      Result.FC.OnFTPData := Result.FTPData;
      Result.FC.OnProgress := Result.FTPProgress;
      Result.FC.OnGetExist := Result.FTPExist;
      Result.FC.OnPutExist := Result.FTPExist;
      Result.FC.OnFileDone := Result.FTPFileDone;
      Result.FC.OnFTPClose := Result.FTPClose;

    Result.TI := NewTrayIcon( Applet, LoadIcon( hInstance, 'ZFORM1_TI' ) );
    Result.TI.Tooltip := 'KOLFtpClient';
      {$R Form1_TI.RES}
  Result.Form.Add2AutoFree( Result.TI );
      Result.TI.OnMouse := Result.TIMouse;

    Result.PM := NewMenu( Result.Form, 0, [ 'Restore', '-'
      , 'Exit', '' ], nil );
    Result.PM.AssignEvents( 0, [ Result.PMN10Menu ] );
    Result.PM.AssignEvents( 1, [ Result.PMN12Menu ] );
    // Result.P3.TabOrder = 0
    Result.P3 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 37 );
    Result.P3.Border := 4;
    // Result.DB.TabOrder = 0
      Result.DB := NewComboBox( Result.P3, [ coReadOnly, coNoIntegralHeight ] ).SetAlign ( caLeft ).SetSize( 46, 0 );
      Result.DB.OnChange := Result.DBChange;
      Result.DB.CurIndex := 0;
    // Result.P5.TabOrder = 2
      Result.P5 := NewPanel( Result.P3, esRaised ).SetAlign ( caClient );
      Result.P5.Border := 2;
    // Result.TB.TabOrder = 0
          {$R Form1_TB.res}
        Result.TB := NewToolbar( Result.P5, caClient, [], LoadMappedBitmap( hInstance, 5000, [ clFuchsia, Color2RGB( clBtnFace ) ] ), [ ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' ], [ 0 ] ).SetAlign ( caClient );
      Result.TB.OnClick := Result.TBClick;
      Result.TB.OnMouseDblClk := Result.TBMouseDblClk;
          Result.TB.TBSetTooltips( Result.TB.TBIndex2Item( 0 ), [ 'Connect', 'Disconnect', 'Download', 'Upload', 'Delete', 'Up one level', 'Stop', 'Make folder', 'Refresh', 'Edit Updater' ] );
    // Result.TC.TabOrder = 3
    Result.TC := NewTabControl( Result.Form, [ 'FTP' ], [ tcoButtons, tcoFixedWidth ], nil, 0 ).SetAlign ( caClient );
    Result.TC.TabStop := FALSE;
      Result.TC.OnSelChange := Result.TCSelChange;
    // Result.TC.Pages[ 0 ].TabOrder = 0
    // Result.P1.TabOrder = 1
        Result.P1 := NewPanel( Result.TC.Pages[ 0 ], esRaised ).SetAlign ( caTop ).SetSize( 0, 186 );
    Result.P1.VerticalAlign := vaCenter;
        Result.P1.Border := 4;
    // Result.LV.TabOrder = 0
          Result.LV := NewListView( Result.P1, lvsDetail, [ lvoAutoArrange, lvoMultiselect, lvoRowSelect ], nil, nil, nil ).SetAlign ( caLeft ).SetSize( 300, 0 );
      Result.LV.OnMouseDblClk := Result.LVMouseDblClk;
          Result.LV.LVBkColor := clBtnFace;
          Result.LV.SetAutoPopupMenu( Result.PL );
    // Result.S1.TabOrder = 1
          Result.S1 := NewSplitter( Result.P1, 0, 0 ).SetAlign ( caLeft );
    // Result.RV.TabOrder = 2
          Result.RV := NewListView( Result.P1, lvsDetail, [ lvoMultiselect, lvoRowSelect, lvoRegional ], nil, nil, nil ).SetAlign ( caClient );
      Result.RV.OnMouseDblClk := Result.RVMouseDblClk;
          Result.RV.LVBkColor := clBtnFace;
          Result.RV.SetAutoPopupMenu( Result.PL );
    // Result.S2.TabOrder = 2
        Result.S2 := NewSplitter( Result.TC.Pages[ 0 ], 0, 0 ).SetAlign ( caTop ).SetSize( 0, 1 );
    // Result.P2.TabOrder = 3
        Result.P2 := NewPanel( Result.TC.Pages[ 0 ], esRaised ).SetAlign ( caClient );
        Result.P2.Border := 4;
    // Result.TV.TabOrder = 0
          Result.TV := NewListView( Result.P2, lvsDetail, [ lvoMultiselect, lvoRowSelect, lvoRegional ], nil, nil, nil ).SetAlign ( caClient );
          Result.TV.LVBkColor := clBtnFace;
          Result.TV.SetAutoPopupMenu( Result.PT );
    Result.TM.Enabled := True;
    Result.KFFormCreate( Result );

end;

