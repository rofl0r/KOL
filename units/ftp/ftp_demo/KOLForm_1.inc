{ KOL MCK } // Do not remove this line!
const TB1 = 0;
const TB2 = 1;
const TB3 = 2;
const TB4 = 3;
const TB5 = 4;
const TB6 = 5;
const TB7 = 6;
const TB8 = 7;
const TB9 = 8;
const TB10 = 9;

const _T0 = 0;
const N5 = 0;
const N6 = 1;
const N8 = 3;

const N10 = 0;
const N12 = 2;

const N1 = 0;
const N2 = 1;
const N4 = 3;
const N9 = 4;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'KOL FTP client' ).SetPosition( 201, 226 ).SetClientSize( 792, 423 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontStyle := [ fsBold ];
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
    Result.Form.Font.FontCharset := 0;
      Result.Form.OnMessage := Result.KFMessage;
      Result.Form.OnClose := Result.KFClose;
      Result.Form.OnResize := Result.KFResize;
    NewMenu( Result.Form, 0, [ '' ], nil );

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

      {$R Form1_TI.RES}
    Result.TI := NewTrayIcon( Applet, 0 );
    Result.TI.Active := FALSE;
    Result.TI.Icon := LoadIcon( hInstance, 'ZFORM1_TI' );
    Result.TI.Tooltip := 'KOLFtpClient';
  Result.Form.Add2AutoFree( Result.TI );
      Result.TI.OnMouse := Result.TIMouse;

    Result.PT := NewMenu( Result.Form, 0, [ 'Select All'
      , 'Deselect All', '-' + '', 'Delete from list'
      , '' ], nil );
    Result.PT.AssignEvents( 0, [ Result.PTN5Menu ] );
    Result.PT.AssignEvents( 1, [ Result.PTN6Menu ] );
    Result.PT.AssignEvents( 3, [ Result.PTN8Menu ] );

    Result.PM := NewMenu( Result.Form, 0, [ 'Restore', '-' + ''
      , 'Exit', '' ], nil );
    Result.PM.AssignEvents( 0, [ Result.PMN10Menu ] );
    Result.PM.AssignEvents( 2, [ Result.PMN12Menu ] );

    Result.PL := NewMenu( Result.Form, 0, [ 
      'Select All'+#9+'Ctrl+A', 'Deselect All', '-' + ''
      , 'Add to transfer list', 'Delete selected', '' ], nil );
    Result.PL.AssignEvents( 0, [ Result.PLN1Menu ] );
    Result.PL.ItemAccelerator[ 0 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $41 );
    Result.PL.AssignEvents( 1, [ Result.PLN2Menu ] );
    Result.PL.AssignEvents( 3, [ Result.PLN4Menu ] );
    Result.PL.AssignEvents( 4, [ Result.PLN9Menu ] );

    Result.XP := NewMHXP( 'Hidden.Hole.LTD' );
      {$R XP.RES}
  Result.Form.Add2AutoFree( Result.XP );
    // Result.P3.TabOrder = 0
    Result.P3 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 46 );
    Result.P3.Border := 4;
    // Result.DB.TabOrder = 0
      Result.DB := NewComboBox( Result.P3, [ coReadOnly, coNoIntegralHeight ] ).SetAlign ( caLeft ).SetSize( 57, 0 );
      Result.DB.CurIndex := 0;
    // Result.P5.TabOrder = 2
      Result.P5 := NewPanel( Result.P3, esLowered ).SetAlign ( caClient );
      Result.P5.Border := 0;
    // Result.TB.TabOrder = 0
          {$R Form1_TB.res}
        Result.TB := NewToolbar( Result.P5, caClient, [], LoadMappedBitmapEx( Result, hInstance, 'FORM1_TBBMP5000', [ clFuchsia, Color2RGB( clBtnFace ) ] ), [ ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' ], [ 0 ] ).SetAlign ( caClient );
        Result.TB.Border := 2;
          Result.TB.TBSetTooltips( Result.TB.TBIndex2Item( 0 ), [ 'Connect', 'Disconnect', 'Download', 'Upload', 'Delete', 'Up one level', 'Stop', 'Make folder', 'Refresh', 'Edit Updater' ] );
    // Result.TC.TabOrder = 3
    Result.TC := NewTabControl( Result.Form, [ 'FTP' ], [ tcoButtons, tcoFixedWidth ], nil, 0 ).SetAlign ( caClient );
    Result.TC.TabStop := FALSE;
    // Result.TC.Pages[ 0 ].TabOrder = 0
    // Result.P1.TabOrder = 1
        Result.P1 := NewPanel( Result.TC.Pages[ 0 ], esRaised ).SetAlign ( caTop ).SetSize( 0, 229 );
    Result.P1.VerticalAlign := vaCenter;
        Result.P1.Border := 4;
    // Result.LV.TabOrder = 0
          Result.LV := NewListView( Result.P1, lvsDetail, [ lvoAutoArrange, lvoMultiselect, lvoRowSelect ], nil, nil, nil ).SetAlign ( caLeft ).SetSize( 369, 0 );
    Result.LV.Color := clWindow;
    Result.LV.Font.FontCharset := 1;
          Result.LV.SetAutoPopupMenu( Result.PL );
    // Result.S1.TabOrder = 1
          Result.S1 := NewSplitter( Result.P1, 0, 0 ).SetAlign ( caLeft );
    // Result.RV.TabOrder = 2
          Result.RV := NewListView( Result.P1, lvsDetail, [ lvoMultiselect, lvoRowSelect, lvoRegional ], nil, nil, nil ).SetAlign ( caClient );
    Result.RV.Font.FontCharset := 1;
          Result.RV.SetAutoPopupMenu( Result.PL );
    // Result.S2.TabOrder = 2
        Result.S2 := NewSplitter( Result.TC.Pages[ 0 ], 0, 0 ).SetAlign ( caTop );
    // Result.P2.TabOrder = 3
        Result.P2 := NewPanel( Result.TC.Pages[ 0 ], esRaised ).SetAlign ( caClient );
        Result.P2.Border := 4;
    // Result.TV.TabOrder = 0
          Result.TV := NewListView( Result.P2, lvsDetail, [ lvoMultiselect, lvoRowSelect, lvoRegional ], nil, nil, nil ).SetAlign ( caClient );
    Result.TV.Font.FontCharset := 1;
          Result.TV.SetAutoPopupMenu( Result.PT );
      Result.DB.OnChange := Result.DBChange;
      Result.TB.OnClick := Result.TBClick;
      Result.TB.OnMouseDblClk := Result.TBMouseDblClk;
      Result.LV.OnMouseDblClk := Result.LVMouseDblClk;
      Result.RV.OnMouseDblClk := Result.RVMouseDblClk;
      Result.TC.OnSelChange := Result.TCSelChange;
    Result.TM.Enabled := True;
    Result.KFFormCreate( Result );

end;


