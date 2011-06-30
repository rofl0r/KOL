{ KOL MCK } // Do not remove this line!
const N3 = 0;
const N1 = 1;
const N4 = 3;
const N2 = 5;

const N7 = 0;
const N8 = 1;

const TB1 = 0;
const TB2 = 1;
const TB3 = 2;
const TB4 = 3;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, '' ).SetPosition( 398, 169 ).SetSize( 404, 224 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.SizeGrip := FALSE;
    Result.Form.Style := Result.Form.Style and not WS_MAXIMIZEBOX;
    Result.Form.HasCaption := False;
    Result.Form.Color := clInfoBk;
    Result.Form.Font.FontHeight := 20;
    Result.Form.Font.FontName := 'Trebuchet MS';
    Result.Form.Font.FontCharset := 0;
      Result.Form.OnMessage := Result.KFMessage;
      Result.Form.OnClose := Result.KFClose;
    NewMenu( Result.Form, 0, [ '' ], nil );

      {$R Form1_TI.RES}
    Result.TI := NewTrayIcon( Applet, 0 );
    Result.TI.Active := FALSE;
    Result.TI.Icon := LoadIcon( hInstance, 'ZFORM1_TI' );
    Result.TI.NoAutoDeactivate := TRUE;
    Result.TI.Tooltip := 'Simple dialer';
    Result.TI.AutoRecreate := TRUE;
  Result.Form.Add2AutoFree( Result.TI );
      Result.TI.OnMouse := Result.TIMouse;

    Result.PM := NewMenu( Result.Form, 0, [ 'Dial', 'Cancel'
      , '-' + '', 'Restore', '-' + '', 'Exit'
      , '' ], Result.PMMenuItem );
    Result.PM.AssignEvents( 0, [ Result.PMMenuItem ] );
    Result.PM.ItemEnabled[ 1 ] := False;
    Result.PM.AssignEvents( 1, [ Result.PMMenuItem ] );
    Result.PM.AssignEvents( 3, [ Result.PMMenuItem ] );
    Result.PM.AssignEvents( 5, [ Result.PMMenuItem ] );

    Result.PP := NewMenu( Result.Form, 0, [ 'Property', 'Hangup'
      , '' ], nil );
    Result.PP.AssignEvents( 0, [ Result.PPN7Menu ] );
    Result.PP.ItemVisible[ 1 ] := False;
    Result.PP.AssignEvents( 1, [ Result.PPN8Menu ] );
      Result.PP.OnPopup := Result.PPPopup;

    Result.TM := NewTimer( 1000 );
  Result.Form.Add2AutoFree( Result.TM );
      Result.TM.OnTimer := Result.TMTimer;

    Result.RAS := NewRASObj;
  Result.Form.Add2AutoFree( Result.RAS );
      Result.RAS.OnConnecting := Result.ConnectingEvent;
      Result.RAS.OnError := Result.RASError;

    Result.FS := NewFormSave(Result.Form);
    Result.FS.Registry := True;
    Result.FS.Section  := 'Main';
    Result.FS.SaveWindow(False);
  Result.Form.Add2AutoFree( Result.FS );

    Result.XP := NewMHXP( 'Test Dial Program.' );
      {$R XP.RES}
  Result.Form.Add2AutoFree( Result.XP );
    // Result.LB.TabOrder = -1
    Result.LB := NewLabel( Result.Form, '' ).SetAlign ( caBottom ).SetSize( 0, 26 );
    Result.LB.Color := clSilver;
    Result.LB.TextAlign := taCenter;
    Result.LB.VerticalAlign := vaCenter;
    // Result.List.TabOrder = 0
    Result.List := NewListView( Result.Form, lvsDetail, [ lvoSortAscending, lvoCheckBoxes, lvoRowSelect ], nil, nil, nil ).SetAlign ( caClient );
    Result.List.Color := clInfoBk;
    Result.List.LVTextBkColor := clInfoBk;
    Result.List.LVBkColor := clInfoBk;
    Result.List.SetAutoPopupMenu( Result.PP );
    // Result.Tool.TabOrder = 2
    Result.Tool := NewToolbar( Result.Form, caTop, [], 0, [ 'Dial', 'Cancel ', 'Hide', 'Exit' ], [ -2 ] ).SetAlign ( caTop );
    Result.Tool.Color := clBtnFace;
    Result.Tool.Font.FontName := 'Arial';
    Result.Tool.Border := 1;
      Result.Tool.TBSetTooltips( Result.Tool.TBIndex2Item( 0 ), [ 'Dial', 'Abort connection', 'Hide program', 'Exit program' ] );
      Result.LB.OnMouseDown := Result.L1MouseDown;
      Result.LB.OnDestroy := Result.L1Destroy;
      Result.List.OnMouseDblClk := Result.ListMouseDblClk;
      Result.List.OnMouseDown := Result.L1MouseDown;
      Result.List.OnLVStateChange := Result.ListLVStateChange;
    Result.TM.Enabled := True;
      Result.Tool.OnClick := Result.ToolClick;
    Result.KFFormCreate( Result );

end;


