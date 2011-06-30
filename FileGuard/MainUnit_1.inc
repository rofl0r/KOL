{ KOL MCK } // Do not remove this line!
const TBAdd = 0;
const TBEdit = 1;
const TBDel = 2;
const TBUp = 4;
const TBDn = 5;

const _TabControl1_Tab0 = 0;
const _TabControl1_Tab1 = 1;
const _TabControl1_Tab2 = 2;
const _tc1_Tab3 = 3;
const Col1 = 0;
const Col2 = 1;
const Col3 = 2;
const pmHistory = 0;
const pmRestore = 1;

const pmState = 0;
const pmExit = 1;

const pmDirRestore = 0;
const pmDirOpen = 2;

const ColName = 0;
const ColDate = 1;
const ColSize = 2;
const ColUsed = 3;

procedure NewfmMainGuard( var Result: PfmMainGuard; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PfmMainGuard.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'File Guard' ).SetPosition( 188, 136 ).SetClientSize( 624, 399 );
  Result.Form.Add2AutoFree( Result );
    Result.Form.Visible := False;
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
      Applet.OnMinimize := Result.KOLForm1Minimize;
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnMinimize := Result.KOLForm1Minimize;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    NewMenu( Result.Form, 0, [ '' ], nil );

      {$R fmMainGuard_TrayIcon1.RES}
    Result.TrayIcon1 := NewTrayIcon( Applet, LoadIcon( hInstance, 'ZFMMAINGUARD_TRAYICON1' ) );
    Result.TrayIcon1.Tooltip := 'File Guard';
    Result.TrayIcon1.AutoRecreate := TRUE;
  Result.Form.Add2AutoFree( Result.TrayIcon1 );
      Result.TrayIcon1.OnMouse := Result.TrayIcon1Mouse;

    Result.ThreadRescanStorageTree := NewThread;
    Result.ThreadRescanStorageTree.OnExecute := Result.ThreadRescanStorageTreeExecute;
    Result.ThreadRescanStorageTree.ThreadPriority := THREAD_PRIORITY_IDLE;
  Result.Form.Add2AutoFree( Result.ThreadRescanStorageTree );

    InitCommonControls;

    Result.TimerCheckConnect := NewTimer( 10000 );
  Result.Form.Add2AutoFree( Result.TimerCheckConnect );
      Result.TimerCheckConnect.OnTimer := Result.TimerCheckConnectTimer;

    Result.dSelStorage := NewOpenDirDialog( 'Select directory for save file changes history', [  ] );
  Result.Form.Add2AutoFree( Result.dSelStorage );

    Result.TimerHide := NewTimer( 100 );
  Result.Form.Add2AutoFree( Result.TimerHide );
      Result.TimerHide.OnTimer := Result.TimerHideTimer;

    Result.pm2 := NewMenu( Result.Form, 0, [ '&History'
      , '&Restore', '' ], nil );
    Result.pm2.AssignEvents( 0, [ Result.pm2pmHistoryMenu ] );
    Result.pm2.AssignEvents( 1, [ Result.pm2pmRestoreMenu ] );

    Result.pm1 := NewMenu( Result.Form, 0, [ 
      'Settings and State', 'Exit', '' ], nil );
    Result.pm1.AssignEvents( 0, [ Result.pm1pmStateMenu ] );
    Result.pm1.AssignEvents( 1, [ Result.pm1pmExitMenu ] );

    Result.pm3 := NewMenu( Result.Form, 0, [ '&Restore'
      , '-' + '', '&Open Directory', '' ], nil );
    Result.pm3.AssignEvents( 0, [ Result.pm3pmDirRestoreMenu ] );
    Result.pm3.AssignEvents( 2, [ Result.pm3pmDirOpenMenu ] );

    Result.ImageList3 := NewImageList( Result.Form );
    Result.ImageList3.LoadSystemIcons( True );

    Result.ImageList1 := NewImageList( Result.Form );
    Result.ImageList1.Colors := ilcColorDDB;
      Result.ImageList1.ImgWidth := 16;
      Result.ImageList1.ImgHeight := 16;
      {$R fmMainGuard_ImageList1.res}
    Result.ImageList1.AddMasked( LoadBmp( hInstance, 'FMMAINGUARD_IMAGELIST1', Result.ImageList1 ), clBlack );

    Result.ImageList2 := NewImageList( Result.Form );
    Result.ImageList2.Colors := ilcColorDDB;
      {$R fmMainGuard_ImageList2.res}
    Result.ImageList2.AddMasked( LoadBmp( hInstance, 'FMMAINGUARD_IMAGELIST2', Result.ImageList2 ), clBlack );
    // Result.tc1.TabOrder = 0
    Result.tc1 := NewTabControl( Result.Form, [ 'Monitor', 'Storage', 'Log', 'About' ], [ tcoFocusTabs ], nil, 0 ).SetAlign ( caClient );
    Result.tc1.TabStop := FALSE;
    // Result.tc1.Pages[ 0 ].TabOrder = 0
    // Result.Panel3.TabOrder = 0
        Result.Panel3 := NewPanel( Result.tc1.Pages[ 0 ], esNone ).SetAlign ( caTop ).SetSize( 0, 31 );
        Result.Panel3.Transparent := True;
    // Result.Toolbar1.TabOrder = 0
            {$R fmMainGuard_Toolbar1.res}
          Result.Toolbar1 := NewToolbar( Result.Panel3, caTop, [tboTextRight, tboFlat, tboNoDivider], 0, [ ' ', ' ', ' ', '-', ' ', ' ' ], [ 32, 20, 7, -2, 0, 1 ] ).SetAlign ( caTop );
    Result.Toolbar1.Color := clBtnFace;
          Result.Toolbar1.Transparent := True;
          Result.Toolbar1.EraseBackground := TRUE;
            Result.Toolbar1.TBBtnImgWidth := 16;
            Result.Toolbar1.TBAddBitmap( LoadMappedBitmapEx( Result.Toolbar1, hInstance, 'FMMAINGUARD_TBBMP5000', [ clFuchsia, Color2RGB( clBtnFace ) ] ) );
            Result.Toolbar1.TBAddBitmap( THandle( -1 ) );
            Result.Toolbar1.TBAddBitmap( THandle( -5 ) );
            Result.Toolbar1.TBAddBitmap( THandle( -9 ) );
            Result.Toolbar1.TBSetTooltips( Result.Toolbar1.TBIndex2Item( 0 ), [ 'Add directory to filter', 'Edit filter', 'Remove filter', '', 'Move Up', 'Move Down' ] );
            Result.Toolbar1.TBAssignEvents( 0, [ Result.Toolbar1TBAddClick, Result.Toolbar1TBEditClick, Result.Toolbar1TBDelClick, nil, Result.Toolbar1TBUpClick, Result.Toolbar1TBDnClick ] );
          if WinVer >= wvXP then
          begin
            Result.Toolbar1.Style := Result.Toolbar1.Style or TBSTYLE_WRAPABLE;
            Result.Toolbar1.Transparent := TRUE;
          end;
    // Result.lv1.TabOrder = 1
        Result.lv1 := NewListView( Result.tc1.Pages[ 0 ], lvsDetail, [ lvoGridLines, lvoRowSelect, lvoOwnerData ], Result.ImageList1, nil, Result.ImageList1 ).SetAlign ( caClient );
    Result.lv1.Color := clWindow;
        Result.lv1.LVColAdd( 'Directory', taLeft, 315);
        Result.lv1.LVColAdd( 'Filter', taLeft, 150);
        Result.lv1.LVColAdd( 'Time', taRight, 50);
    // Result.tc1.Pages[ 1 ].TabOrder = 1
    // Result.Panel2.TabOrder = 0
        Result.Panel2 := NewPanel( Result.tc1.Pages[ 1 ], esNone ).SetAlign ( caTop ).SetSize( 0, 26 );
    // Result.eStoragePath.TabOrder = 0
          Result.eStoragePath := NewEditBox( Result.Panel2, [  ] ).SetAlign ( caClient );
    Result.eStoragePath.Color := clWindow;
    // Result.bBrowseStorage.TabOrder = 1
          Result.bBrowseStorage := NewButton( Result.Panel2, 'Browse' ).SetAlign ( caRight );
    // Result.Panel7.TabOrder = 1
        Result.Panel7 := NewPanel( Result.tc1.Pages[ 1 ], esNone ).SetAlign ( caTop ).SetSize( 0, 19 );
    // Result.lStorageStatus.TabOrder = -1
          Result.lStorageStatus := NewLabel( Result.Panel7, '   ' ).SetAlign ( caClient ).AutoSize( TRUE );
    // Result.tvDirs.TabOrder = 2
        Result.tvDirs := NewTreeView( Result.tc1.Pages[ 1 ], [ tvoLinesRoot ], Result.ImageList3, nil ).SetAlign ( caLeft ).SetSize( 223, 0 );
    Result.tvDirs.Color := clWindow;
        Result.tvDirs.MinWidth := 100;
        Result.tvDirs.TVRightClickSelect := TRUE;
        Result.tvDirs.SetAutoPopupMenu( Result.pm3 );
    // Result.Splitter1.TabOrder = 3
        Result.Splitter1 := NewSplitter( Result.tc1.Pages[ 1 ], 0, 0 ).SetAlign ( caLeft ).SetSize( 6, 0 );
    // Result.lvFiles.TabOrder = 4
        Result.lvFiles := NewListView( Result.tc1.Pages[ 1 ], lvsDetail, [ lvoMultiselect, lvoRowSelect, lvoOwnerData ], Result.ImageList3, nil, nil ).SetAlign ( caClient );
    Result.lvFiles.Color := clWindow;
        Result.lvFiles.MinWidth := 100;
        Result.lvFiles.SetAutoPopupMenu( Result.pm2 );
        Result.lvFiles.LVColAdd( 'Name', taLeft, 145);
        Result.lvFiles.LVColAdd( 'Date', taLeft, 80);
        Result.lvFiles.LVColAdd( 'Size', taRight, 60);
        Result.lvFiles.LVColAdd( 'Used', taRight, 60);
    // Result.tc1.Pages[ 2 ].TabOrder = 2
    // Result.Memo1.TabOrder = 0
        Result.Memo1 := NewEditBox( Result.tc1.Pages[ 2 ], [ eoMultiline, eoNoHScroll, eoReadonly ] ).SetAlign ( caClient );
    Result.Memo1.Color := clWindow;
    // Result.pnLogInfo.TabOrder = 1
        Result.pnLogInfo := NewPanel( Result.tc1.Pages[ 2 ], esLowered ).SetAlign ( caBottom ).SetSize( 0, 24 );
    // Result.lQueued.TabOrder = -1
          Result.lQueued := NewLabel( Result.pnLogInfo, '  ' ).SetAlign ( caRight ).AutoSize( TRUE );
    // Result.cDetailed.TabOrder = 0
          Result.cDetailed := NewCheckBox( Result.pnLogInfo, 'Detailed' ).SetAlign ( caLeft ).AutoSize( TRUE );
    // Result.tc1.Pages[ 3 ].TabOrder = 3
    // Result.lLink.TabOrder = -1
        Result.lLink := NewLabel( Result.tc1.Pages[ 3 ], 'http://bonanzas.rinet.ru' ).SetAlign ( caBottom ).AutoSize( TRUE );
    Result.lLink.Font.Color := clBlue;
    Result.lLink.Font.FontStyle := [ fsUnderline ];
    Result.lLink.TextAlign := taCenter;
        Result.lLink.Cursor := LoadCursor( 0, IDC_HAND );
    // Result.Panel4.TabOrder = 0
        Result.Panel4 := NewPanel( Result.tc1.Pages[ 3 ], esLowered ).SetAlign ( caTop ).SetSize( 0, 47 );
    // Result.ImageShow1.TabOrder = 0
          Result.ImageShow1 := NewImageShow( Result.Panel4, Result.ImageList2, 0 ).SetAlign ( caLeft );
          Result.ImageShow1.Transparent := True;
    // Result.Panel5.TabOrder = 1
          Result.Panel5 := NewPanel( Result.Panel4, esNone ).SetAlign ( caClient );
          Result.Panel5.Border := 0;
    // Result.LabelEffect2.TabOrder = -1
            Result.LabelEffect2 := NewLabelEffect( Result.Panel5, ' File Guard v1.0.1 Beta', 2 ).SetAlign ( caLeft ).AutoSize( TRUE );
            Result.LabelEffect2.Ctl3D := False;
    Result.LabelEffect2.Font.Color := clPurple;
    Result.LabelEffect2.Font.FontStyle := [ fsBold ];
    Result.LabelEffect2.Font.FontHeight := 31;
    Result.LabelEffect2.TextAlign := taLeft;
            Result.LabelEffect2.Color2 := clBlack;
    // Result.LabelEffect1.TabOrder = -1
            Result.LabelEffect1 := NewLabelEffect( Result.Panel5, '   (C) by Vladimir Kladov, 2004', 1 ).SetAlign ( caLeft ).AutoSize( TRUE );
            Result.LabelEffect1.Ctl3D := False;
    Result.LabelEffect1.Font.Color := clBlue;
    Result.LabelEffect1.Font.FontStyle := [ fsBold ];
    Result.LabelEffect1.Font.FontHeight := 24;
    Result.LabelEffect1.TextAlign := taLeft;
    Result.LabelEffect1.VerticalAlign := vaBottom;
            Result.LabelEffect1.Color2 := clBlack;
    // Result.Panel6.TabOrder = 1
        Result.Panel6 := NewPanel( Result.tc1.Pages[ 3 ], esNone ).SetAlign ( caClient );
        Result.Panel6.Border := 12;
    // Result.lDescription_About.TabOrder = -1
          Result.lDescription_About := NewWordWrapLabel( Result.Panel6, 'text here' ).SetAlign ( caClient );
    // Result.Panel1.TabOrder = 1
    Result.Panel1 := NewPanel( Result.Form, esLowered ).SetAlign ( caTop ).SetSize( 0, 27 );
    // Result.lStatus.TabOrder = -1
      Result.lStatus := NewLabel( Result.Panel1, 'Monitored: 0 dirs   Storage: <not set>' ).SetAlign ( caClient ).AutoSize( TRUE );
    Result.lStatus.VerticalAlign := vaCenter;
    // Result.bExit.TabOrder = 0
      Result.bExit := NewButton( Result.Panel1, 'Exit' ).SetAlign ( caRight ).SetSize( 49, 0 );
      Result.lLink.OnClick := Result.lLinkClick;
      Result.lLink.OnMouseEnter := Result.lLinkMouseEnter;
      Result.lLink.OnMouseLeave := Result.lLinkMouseLeave;
      Result.eStoragePath.OnChange := Result.eStoragePathChange;
      Result.tc1.CurIndex := 2;
      Result.tc1.Pages[ 2 ].BringToFront;
      Result.bExit.OnClick := Result.bExitClick;
      Result.lv1.OnMouseDblClk := Result.lv1MouseDblClk;
      Result.lv1.OnKeyDown := Result.lv1KeyDown;
      Result.lv1.OnLVData := Result.lv1LVData;
      Result.lv1.OnLVStateChange := Result.lv1LVStateChange;
      Result.bBrowseStorage.OnClick := Result.bBrowseStorageClick;
      Result.tvDirs.OnSelChange := Result.tvDirsSelChange;
    Result.TrayIcon1.Active := TRUE;
      Result.dSelStorage.WndOwner := Result.Form.GetWindowHandle;
      Result.lvFiles.OnMouseDblClk := Result.lvFilesMouseDblClk;
      Result.lvFiles.OnKeyDown := Result.lvFilesKeyDown;
      Result.lvFiles.OnLVData := Result.lvFilesLVData;
      Result.lvFiles.OnLVStateChange := Result.lvFilesLVStateChange;
    Result.Form.CenterOnParent;
    Result.Form.MinimizeNormalAnimated;
    Result.KOLForm1FormCreate( Result );

end;

