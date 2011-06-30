{ KOL MCK } // Do not remove this line!
const TBClose = 0;

const TBSave = 0;
const TBView = 1;

const ColDate = 0;
const ColSize = 1;
const ColUsed = 2;

procedure NewfmHistory( var Result: PfmHistory; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PfmHistory.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'History of versions: ' ).SetPosition( 214, 295 ).SetClientSize( 338, 413 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    Result.Form.MinWidth := 340;
    Result.Form.MinHeight := 200;

    Result.dSaveAs := NewOpenSaveDialog( 'Select file name and directory location to save', '', [  ] );
      Result.dSaveAs.OpenDialog := FALSE;
  Result.Form.Add2AutoFree( Result.dSaveAs );
    // Result.lvHistory.TabOrder = 1
    Result.lvHistory := NewListView( Result.Form, lvsDetail, [ lvoRowSelect, lvoOwnerData ], nil, nil, nil ).SetAlign ( caClient );
    Result.lvHistory.Color := clWindow;
    Result.lvHistory.LVColAdd( 'Date', taLeft, 130);
    Result.lvHistory.LVColAdd( 'Size', taRight, 90);
    Result.lvHistory.LVColAdd( 'Used', taRight, 90);
    // Result.Panel1.TabOrder = 2
    Result.Panel1 := NewPanel( Result.Form, esNone ).SetAlign ( caTop ).SetSize( 0, 23 );
    Result.Panel1.Border := 0;
    // Result.Panel2.TabOrder = 0
      Result.Panel2 := NewPanel( Result.Panel1, esNone ).SetAlign ( caLeft ).SetSize( 185, 0 );
    // Result.Toolbar1.TabOrder = 0
        Result.Toolbar1 := NewToolbar( Result.Panel2, caTop, [tboTextRight, tboFlat, tboNoDivider], THandle( -1 ), [ 'Save as...', 'View' ], [ 8, 7 ] ).SetAlign ( caTop );
        Result.Toolbar1.Border := 2;
          Result.Toolbar1.TBAssignEvents( 0, [ Result.Toolbar1TBSaveClick, Result.Toolbar1TBViewClick ] );
        if WinVer >= wvXP then
        begin
          Result.Toolbar1.Style := Result.Toolbar1.Style or TBSTYLE_WRAPABLE;
          Result.Toolbar1.Transparent := TRUE;
        end;
    // Result.Panel3.TabOrder = 1
      Result.Panel3 := NewPanel( Result.Panel1, esNone ).SetAlign ( caRight ).SetSize( 71, 0 );
    // Result.Toolbar2.TabOrder = 0
        Result.Toolbar2 := NewToolbar( Result.Panel3, caTop, [tboTextRight, tboFlat, tboNoDivider], THandle( -9 ), [ 'Close' ], [ 1 ] ).SetAlign ( caTop );
        Result.Toolbar2.Border := 2;
          Result.Toolbar2.TBAssignEvents( 0, [ Result.Toolbar1TBCloseClick ] );
        if WinVer >= wvXP then
        begin
          Result.Toolbar2.Style := Result.Toolbar2.Style or TBSTYLE_WRAPABLE;
          Result.Toolbar2.Transparent := TRUE;
        end;
      Result.lvHistory.OnMouseDblClk := Result.lvHistoryMouseDblClk;
      Result.lvHistory.OnKeyDown := Result.lvHistoryKeyDown;
      Result.lvHistory.OnLVData := Result.lvHistoryLVData;
      Result.lvHistory.OnLVStateChange := Result.lvHistoryLVStateChange;
      Result.dSaveAs.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CenterOnParent;
    Result.KOLForm1FormCreate( Result );

end;

