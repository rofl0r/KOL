{ KOL MCK } // Do not remove this line!
const TB1 = 0;
const TB2 = 1;


procedure NewfmEditFilter( var Result: PfmEditFilter; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PfmEditFilter.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Add/Edit Filter' ).SetPosition( 187, 482 ).SetClientSize( 632, 158 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.dSelDir := NewOpenDirDialog( 'Select directory to monitor', [ odOnlyFileSystemAncestors, odOnlySystemDirs ] );
  Result.Form.Add2AutoFree( Result.dSelDir );
    // Result.Label4.TabOrder = -1
    Result.Label4 := NewLabel( Result.Form, 'Time to wait changes (seconds):' ).SetPosition( 8, 132 ).AutoSize( TRUE );
    // Result.Label3.TabOrder = -1
    Result.Label3 := NewLabel( Result.Form, 'Action:' ).SetPosition( 368, 64 ).AutoSize( TRUE );
    // Result.Label2.TabOrder = -1
    Result.Label2 := NewLabel( Result.Form, 'Filter:' ).SetPosition( 8, 64 ).AutoSize( TRUE );
    // Result.Label1.TabOrder = -1
    Result.Label1 := NewLabel( Result.Form, 'Directory path:' ).SetPosition( 8, 8 ).AutoSize( TRUE );
    // Result.eDir.TabOrder = 0
    Result.eDir := NewEditBox( Result.Form, [  ] ).SetPosition( 8, 32 ).SetSize( 545, 0 );
    Result.eDir.Color := clWindow;
    // Result.bBrowse.TabOrder = 1
    Result.bBrowse := NewButton( Result.Form, 'Browse' ).SetPosition( 560, 32 );
    // Result.eFilter.TabOrder = 2
    Result.eFilter := NewComboBox( Result.Form, [ coNoIntegralHeight ] ).SetPosition( 8, 88 ).SetSize( 353, 0 );
    Result.eFilter.Color := clWindow;
    Result.eFilter.Items[ 0 ] := '';
    Result.eFilter.Items[ 1 ] := '*.txt;*.diz;*.doc';
    Result.eFilter.Items[ 2 ] := '*.pas;*.dpr;*.dfm;*.res;*.rc;*.inc;*.dcr;*.dof;*.cfg;*.asm';
    Result.eFilter.Items[ 3 ] := '*.cpp;*.c;*.hpp;*.h';
    Result.eFilter.Items[ 4 ] := '*.ico;*.bmp;*.jpg;*.jpeg;*.gif;*.png;*.psd;*.pcx;*.tif;*.tiff;*.tga';
    Result.eFilter.Items[ 5 ] := '*.*';
    Result.eFilter.CurIndex := 0;
    // Result.eAction.TabOrder = 3
    Result.eAction := NewComboBox( Result.Form, [ coReadOnly, coNoIntegralHeight ] ).SetPosition( 368, 88 ).SetSize( 225, 0 );
    Result.eAction.Color := clWindow;
    Result.eAction.Items[ 0 ] := 'Store entire HISTORY of changes';
    Result.eAction.Items[ 1 ] := 'Store LAST version only';
    Result.eAction.Items[ 2 ] := 'No store (skip filter)';
    Result.eAction.CurIndex := 0;
    // Result.eTime.TabOrder = 4
    Result.eTime := NewEditBox( Result.Form, [  ] ).SetPosition( 216, 128 ).SetSize( 41, 0 );
    Result.eTime.Color := clWindow;
    Result.eTime.Text := '30';
    // Result.Panel1.TabOrder = 5
    Result.Panel1 := NewPanel( Result.Form, esNone ).SetPosition( 256, 128 ).SetSize( 49, 25 );
    Result.Panel1.Border := 0;
    // Result.Toolbar1.TabOrder = 0
      Result.Toolbar1 := NewToolbar( Result.Panel1, caTop, [tboTextRight, tboFlat, tboNoDivider], 0, [ '<', '>' ], [ -2 ] ).SetAlign ( caTop );
      Result.Toolbar1.Border := 2;
        Result.Toolbar1.TBAssignEvents( 0, [ Result.Toolbar1TB1Click, Result.Toolbar1TB2Click ] );
      if WinVer >= wvXP then
      begin
        Result.Toolbar1.Style := Result.Toolbar1.Style or TBSTYLE_WRAPABLE;
        Result.Toolbar1.Transparent := TRUE;
      end;
    // Result.bAdd.TabOrder = 6
    Result.bAdd := NewButton( Result.Form, 'Add' ).SetPosition( 488, 128 );
    Result.bAdd.Enabled := False;
    // Result.bClose.TabOrder = 7
    Result.bClose := NewButton( Result.Form, 'Close' ).SetPosition( 560, 128 );
    // Result.cSubdirectories.TabOrder = 8
    Result.cSubdirectories := NewCheckBox( Result.Form, 'Subdirectories' ).SetPosition( 312, 128 ).AutoSize( TRUE );
    Result.cSubdirectories.Checked := TRUE;
    // Result.isSubdirs.TabOrder = 9
    Result.isSubdirs := NewImageShow( Result.Form, nil, 3 ).SetPosition( 424, 128 ).SetSize( 16, 16 );
    Result.isSubdirs.CurIndex := 3;
    // Result.isAction.TabOrder = 10
    Result.isAction := NewImageShow( Result.Form, nil, 0 ).SetPosition( 602, 90 ).SetSize( 16, 16 );
      Result.eDir.OnChange := Result.eDirChange;
      Result.bBrowse.OnClick := Result.bBrowseClick;
      Result.eFilter.OnChange := Result.eDirChange;
      Result.eAction.OnChange := Result.eActionChange;
      Result.eTime.OnChar := Result.eTimeChar;
      Result.bAdd.OnClick := Result.bAddClick;
    Result.bAdd.DefaultBtn := TRUE;
      Result.bClose.OnClick := Result.bCloseClick;
    Result.bClose.CancelBtn := TRUE;
      Result.cSubdirectories.OnClick := Result.cSubdirectoriesClick;
      Result.dSelDir.WndOwner := Result.Form.GetWindowHandle;
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Icon := THandle(-1);

end;

