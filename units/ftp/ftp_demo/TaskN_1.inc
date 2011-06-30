{ KOL MCK } // Do not remove this line!
const N5 = 0;
const N6 = 1;
const N8 = 3;

const N1 = 0;
const N2 = 1;
const N4 = 3;
const N9 = 4;


procedure NewForm6( var Result: PForm6; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm6.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewPanel( AParent, esNone ).SetAlign( caClient).SetSize( 800, 456 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontCharset := 0;
    Result.Form.Border := 0;
      Result.Form.OnResize := Result.KFResize;
      Result.Form.OnShow := Result.KFShow;
      Result.Form.OnDestroy := Result.KFDestroy;

    Result.PT := NewMenu( Result.Form, 0, [ 'Select All'
      , 'Deselect All', '-' + '', 'Delete from list'
      , '' ], nil );
    Result.PT.AssignEvents( 0, [ Result.PTN5Menu ] );
    Result.PT.AssignEvents( 1, [ Result.PTN6Menu ] );
    Result.PT.AssignEvents( 3, [ Result.PTN8Menu ] );

    Result.FC := NewKOLFtpClient;
  Result.Form.Add2AutoFree( Result.FC );
      Result.FC.OnFTPStatus := Result.FCFTPStatus;
      Result.FC.OnFTPLogger := Result.FCFTPLogger;
      Result.FC.OnFTPConnect := Result.FTPConnect;
      Result.FC.OnFTPLogin := Result.FTPLogin;
      Result.FC.OnFTPError := Result.FTPError;
      Result.FC.OnFTPData := Result.FTPData;
      Result.FC.OnProgress := Result.FTPProgress;
      Result.FC.OnGetExist := Result.FCGetExist;
      Result.FC.OnPutExist := Result.FCPutExist;
      Result.FC.OnFileDone := Result.FTPFileDone;
      Result.FC.OnFTPClose := Result.FTPClose;

    Result.TM := NewTimer( 5000 );
  Result.Form.Add2AutoFree( Result.TM );
      Result.TM.OnTimer := Result.TMTimer;

    Result.PL := NewMenu( Result.Form, 0, [ 'Select All'
      , 'Deselect All', '-' + '', 'Add to transfer list'
      , 'Delete selected', '' ], nil );
    Result.PL.AssignEvents( 0, [ Result.PLN1Menu ] );
    Result.PL.AssignEvents( 1, [ Result.PLN2Menu ] );
    Result.PL.AssignEvents( 3, [ Result.PLN4Menu ] );
    Result.PL.AssignEvents( 4, [ Result.PLN9Menu ] );
    // Result.P1.TabOrder = 1
    Result.P1 := NewPanel( Result.Form, esRaised ).SetAlign ( caTop ).SetSize( 0, 249 ).BringToFront;
    Result.P1.VerticalAlign := vaCenter;
    Result.P1.Border := 4;
    // Result.LV.TabOrder = 0
      Result.LV := NewListView( Result.P1, lvsDetail, [ lvoAutoArrange, lvoRowSelect ], nil, nil, nil ).SetAlign ( caLeft ).SetSize( 369, 0 ).BringToFront;
    Result.LV.Font.FontCharset := 1;
    // Result.S1.TabOrder = 1
      Result.S1 := NewSplitter( Result.P1, 0, 0 ).SetAlign ( caLeft ).BringToFront;
    // Result.RV.TabOrder = 2
      Result.RV := NewListView( Result.P1, lvsDetail, [ lvoRowSelect ], nil, nil, nil ).SetAlign ( caClient ).BringToFront;
    Result.RV.Font.FontCharset := 1;
    // Result.S2.TabOrder = 2
    Result.S2 := NewSplitter( Result.Form, 0, 0 ).SetAlign ( caTop ).BringToFront;
    // Result.P2.TabOrder = 3
    Result.P2 := NewPanel( Result.Form, esRaised ).SetAlign ( caClient ).BringToFront;
    Result.P2.Border := 4;
    // Result.TV.TabOrder = 0
      Result.TV := NewListView( Result.P2, lvsDetail, [ lvoMultiselect, lvoRowSelect, lvoRegional ], nil, nil, nil ).SetAlign ( caClient ).BringToFront;
    Result.TV.Font.FontCharset := 1;
      Result.TV.SetAutoPopupMenu( Result.PT );
    Result.RV.LVCount := 3;
    Result.TM.Enabled := True;
    Result.KFFormCreate( Result );
    Result.Form.CreateWindow;

end;


