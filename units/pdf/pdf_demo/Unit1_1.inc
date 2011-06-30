{ KOL MCK } // Do not remove this line!
const N1 = 0;
const N2 = 1;
const N4 = 3;
const N13 = 4;
const N6 = 6;
const N14 = 7;
const N15 = 8;
const N7 = 9;
const N8 = 10;
const N9 = 11;
const N10 = 12;
const N11 = 13;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Test PDF control' ).SetPosition( 192, 110 ).SetClientSize( 688, 426 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := -11;
    Result.Form.Border := 0;
      Result.Form.OnResize := Result.KOLForm1Resize;
      Result.Form.OnShow := Result.KOLForm1Show;

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ 'File', '('
      , 'Open...'+#9+'Ctrl+O', '-' + '', 'Print...'
      , 'Print with dialog...', '-' + '', 'Exit', ')', 'View'
      , '(', '+' + 'Show toolbar', ')', 'Commands', '('
      , 'Goto first page'+#9+'Ctrl+F'
      , 'Goto last page'+#9+'Ctrl+L'
      , 'Goto next page'+#9+'Ctrl+N'
      , 'Goto previous page'+#9+'Ctrl+P', ')', '' ], nil );
    Result.MainMenu1.AssignEvents( 1, [ Result.KOLForm1N2Menu ] );
    Result.MainMenu1.ItemAccelerator[ 1 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $4F );
    Result.MainMenu1.AssignEvents( 3, [ Result.KOLForm1N4Menu ] );
    Result.MainMenu1.AssignEvents( 4, [ Result.KOLForm1N13Menu ] );
    Result.MainMenu1.AssignEvents( 6, [ Result.KOLForm1N6Menu ] );
    Result.MainMenu1.AssignEvents( 8, [ Result.KOLForm1N15Menu ] );
    Result.MainMenu1.AssignEvents( 10, [ Result.KOLForm1N8Menu ] );
    Result.MainMenu1.ItemAccelerator[ 10 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $46 );
    Result.MainMenu1.AssignEvents( 11, [ Result.KOLForm1N9Menu ] );
    Result.MainMenu1.ItemAccelerator[ 11 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $4C );
    Result.MainMenu1.AssignEvents( 12, [ Result.KOLForm1N10Menu ] );
    Result.MainMenu1.ItemAccelerator[ 12 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $4E );
    Result.MainMenu1.AssignEvents( 13, [ Result.KOLForm1N11Menu ] );
    Result.MainMenu1.ItemAccelerator[ 13 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $50 );

    Result.OpenDlg := NewOpenSaveDialog( 'Select PDF document...', '', [  ] );
      Result.OpenDlg.Filter := 'Adobe PDF documents|*.pdf|All files|*.*';
      Result.OpenDlg.DefExtension := 'pdf';
  Result.Form.Add2AutoFree( Result.OpenDlg );
    // Result.PDF1.TabOrder = 0
    Result.PDF1 := NewKOLPDF(Result.Form); 
      Result.OpenDlg.WndOwner := Result.Form.GetWindowHandle;

end;

