{ KOL MCK } // Do not remove this line!
const nDateTime = 0;
const n1Restore = 1;
const nTrayView = 2;
const nSecondsTray = 3;
const nColored = 4;
const n1Exit = 6;

const nAbout = 0;
const nLanguage = 1;
const nLangEnd = 2;
const nLangEdit = 3;
const nPlugins = 4;
const nPluginEnd = 5;
const nView = 6;
const nSecondsFace = 7;
const nKeep = 8;
const nBorder = 9;
const nColor = 10;
const nColorSilver = 11;
const nColorBlue = 12;
const nColorRed = 13;
const nColorGreen = 14;
const nColorYellow = 15;
const nColorMagenta = 16;
const nColorWhite = 17;
const nColorBlack = 18;
const nTransparent = 19;
const N4 = 20;
const nExit = 21;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Round Watch' );
  Result.Form.Add2AutoFree( Result );
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_TOOLWINDOW;
    Result.Form.AlphaBlend := 154;
    Result.Form.StayOnTop := True;
    Result.Form.Icon := THandle(-1);
    Result.Form.Border := 0;
      Result.Form.OnMessage := Result.KOLForm1Message;
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnMouseDown := Result.PaintBox1MouseDown;
      Result.Form.OnMouseMove := Result.PaintBox1MouseMove;
      Result.Form.OnMouseUp := Result.PaintBox1MouseUp;
      Result.Form.OnResize := Result.KOLForm1Resize;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnPaint := Result.PaintBox1Paint;
      Result.Form.OnEraseBkgnd := Result.KOLForm1EraseBkgnd;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;
    Result.Form.MinWidth := 64;
    Result.Form.MinHeight := 64;
    Result.Form.MaxWidth := 256;
    Result.Form.MaxHeight := 256;
    NewMenu( Result.Form, 0, [ '' ], nil );

    Result.TrayIcon3 := NewTrayIcon( Applet, 0 );
    Result.TrayIcon3.Active := FALSE;
    Result.TrayIcon3.AutoRecreate := TRUE;
  Result.Form.Add2AutoFree( Result.TrayIcon3 );
      Result.TrayIcon3.OnMouse := Result.TrayIcon1Mouse;

    Result.TrayIcon1 := NewTrayIcon( Applet, 0 );
    Result.TrayIcon1.Active := FALSE;
    Result.TrayIcon1.AutoRecreate := TRUE;
  Result.Form.Add2AutoFree( Result.TrayIcon1 );
      Result.TrayIcon1.OnMouse := Result.TrayIcon1Mouse;

    Result.TrayIcon2 := NewTrayIcon( Applet, 0 );
    Result.TrayIcon2.Active := FALSE;
    Result.TrayIcon2.AutoRecreate := TRUE;
  Result.Form.Add2AutoFree( Result.TrayIcon2 );
      Result.TrayIcon2.OnMouse := Result.TrayIcon1Mouse;

    Result.Timer1 := NewTimer( 100 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;

    Result.PopupMenu1 := NewMenu( Result.Form, 0, [ '&Date Time'
      , '&Restore', '&View', '(', '+' + '&Seconds'
      , '+' + '&Colored', ')', '-' + '', 'E&xit', '' ], nil );
    Result.PopupMenu1.AssignEvents( 0, [ Result.PopupMenu1nDateTimeMenu ] );
    Result.PopupMenu1.AssignEvents( 1, [ Result.PopupMenu1n1RestoreMenu ] );
    Result.PopupMenu1.AssignEvents( 3, [ Result.PopupMenu1nSecondsTray1Menu ] );
    Result.PopupMenu1.AssignEvents( 4, [ Result.PopupMenu1nColoredMenu ] );
    Result.PopupMenu1.AssignEvents( 6, [ Result.PopupMenu1n1ExitMenu ] );

    Result.PopupMenu2 := NewMenu( Result.Form, 0, [ '&About'
      , '&Language', '(', '-' + '', 'Edit', ')', '&Plugins', '('
      , '-' + '', ')', '&View', '(', '+' + '&Seconds'
      , '+' + '&Keep Ratio', '+' + '&Border', '&Color', '('
      , 'Silver', 'Blue', 'Red', 'Green', 'Yellow', 'Magenta'
      , 'White', 'Black', ')', '+' + '&Transparent', ')'
      , '-' + '', 'E&xit', '' ], nil );
    Result.PopupMenu2.AssignEvents( 0, [ Result.PopupMenu2nAboutMenu ] );
    Result.PopupMenu2.AssignEvents( 3, [ Result.PopupMenu2nLangEditMenu ] );
    Result.PopupMenu2.ItemVisible[ 5 ] := False;
    Result.PopupMenu2.AssignEvents( 7, [ Result.PopupMenu2nSecondsFaceMenu ] );
    Result.PopupMenu2.AssignEvents( 8, [ Result.PopupMenu2nKeepMenu ] );
    Result.PopupMenu2.AssignEvents( 9, [ Result.PopupMenu2nBorderMenu ] );
    Result.PopupMenu2.AssignEvents( 11, [ Result.PopupMenu2nColorSilverMenu ] );
    Result.PopupMenu2.AssignEvents( 12, [ Result.PopupMenu2ncolorBlueMenu ] );
    Result.PopupMenu2.AssignEvents( 13, [ Result.PopupMenu2nColorRedMenu ] );
    Result.PopupMenu2.AssignEvents( 14, [ Result.PopupMenu2ncolorGreenMenu ] );
    Result.PopupMenu2.AssignEvents( 15, [ Result.PopupMenu2nColorYellowMenu ] );
    Result.PopupMenu2.AssignEvents( 16, [ Result.PopupMenu2nColorMagentaMenu ] );
    Result.PopupMenu2.AssignEvents( 17, [ Result.PopupMenu2nColorWhiteMenu ] );
    Result.PopupMenu2.AssignEvents( 18, [ Result.PopupMenu2nColorBlackMenu ] );
    Result.PopupMenu2.AssignEvents( 19, [ Result.PopupMenu2nTransparentMenu ] );
    Result.PopupMenu2.AssignEvents( 21, [ Result.PopupMenu2nExitMenu ] );
      Result.PopupMenu2.OnPopup := Result.PopupMenu2Popup;
    Result.Timer1.Enabled := True;
    Result.Form.SetAutoPopupMenu( Result.PopupMenu2 );
    Result.KOLForm1FormCreate( Result );

end;

