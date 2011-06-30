{ KOL MCK } // Do not remove this line!
const N1 = 0;
const pmiIcons = 1;
const pmiSmall = 2;
const pmiList = 3;
const pmiTable = 4;

const TBLevelUp = 0;
const TBIcons = 1;
const TBSmall = 2;
const TBList = 3;
const TBTable = 4;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  New( Result, Create );
  Result.Form := NewForm( AParent, 'Form1' ).SetPosition( 246, 107 ).SetSize( 537, 363 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.PopupMenu1 := NewMenu( Result.Form, 0, [ 'View', '('
      , 'Icons', 'Small Icons', 'List', 'Table', ')'
      , '' ], nil );
    Result.PopupMenu1.AssignEvents( 1, [ Result.PopupMenu1pmiIconsMenu ] );
    Result.PopupMenu1.AssignEvents( 2, [ Result.PopupMenu1pmiSmallMenu ] );
    Result.PopupMenu1.AssignEvents( 3, [ Result.PopupMenu1pmiListMenu ] );
    Result.PopupMenu1.AssignEvents( 4, [ Result.PopupMenu1pmiTableMenu ] );
      Result.PopupMenu1.OnPopup := Result.PopupMenu1Popup;

    Result.ilSmall := NewImageList( Result.Form );
    Result.ilSmall.LoadSystemIcons( True );
  Result.Form.Add2AutoFree( Result.ilSmall );

    Result.ilShell := NewImageList( Result.Form );
    Result.ilShell.LoadSystemIcons( False );
  Result.Form.Add2AutoFree( Result.ilShell );
    // Result.DirTree.TabOrder = 0
    Result.DirTree := NewDirTreeView( Result.Form, [ tvoLinesRoot ], ioReal, '*' ).SetAlign ( caLeft ).SetSize( 203, 0 );
    Result.DirTree.Color := clWindow;
      Result.DirTree.OnSelChange := Result.DirTreeSelChange;
    // Result.Splitter1.TabOrder = 1
    Result.Splitter1 := NewSplitter( Result.Form, 0, 0 ).SetAlign ( caLeft );
    // Result.FileView.TabOrder = 2
    Result.FileView := NewListView( Result.Form, lvsIcon, [  ], Result.ilSmall, Result.ilShell, nil ).SetAlign ( caClient );
    Result.FileView.Color := clWindow;
      Result.FileView.OnMouseDblClk := Result.FileViewMouseDblClk;
      Result.FileView.OnChar := Result.FileViewChar;
    Result.FileView.SetAutoPopupMenu( Result.PopupMenu1 );
    // Result.Toolbar1.TabOrder = 3
    Result.Toolbar1 := NewToolbar( Result.Form, caNone, [], 0, [ 'LevelUp', 'Icons', 'Small Icons', 'List', 'Table' ], [ 3, 15, 16, 17, 18 ] ).SetAlign ( caTop );
      Result.Toolbar1.TBAddBitmap( THandle( -1 ) );
      Result.Toolbar1.TBAddBitmap( THandle( -5 ) );
      Result.Toolbar1.TBAssignEvents( 0, [ Result.Toolbar1TBLevelUpClick, Result.Toolbar1TBIconsClick, Result.Toolbar1TBSmallClick, Result.Toolbar1TBListClick, Result.Toolbar1TBTableClick ] );
    Result.KOLForm1FormCreate( Result );

end;

