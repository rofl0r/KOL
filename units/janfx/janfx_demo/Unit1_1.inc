{ KOL MCK } // Do not remove this line!
const N1 = 0;
const N2 = 1;
const N4 = 3;
const N105 = 4;
const N5 = 5;
const N6 = 6;
const N7 = 7;
const N8 = 8;
const N9 = 9;
const N10 = 10;
const N11 = 11;
const N106 = 12;
const N107 = 13;
const N108 = 14;
const N12 = 15;
const N13 = 16;
const N17 = 17;
const N18 = 18;
const N19 = 19;
const N14 = 20;
const N20 = 21;
const N21 = 22;
const N22 = 23;
const N23 = 24;
const N24 = 25;
const N25 = 26;
const N26 = 27;
const N28 = 29;
const N29 = 30;
const N30 = 31;
const N31 = 32;
const N32 = 33;
const N33 = 34;
const N34 = 35;
const N35 = 36;
const N36 = 37;
const N37 = 38;
const N38 = 39;
const N39 = 40;
const N40 = 41;
const N41 = 42;
const N42 = 43;
const N43 = 44;
const N44 = 45;
const N45 = 46;
const N46 = 47;
const N48 = 48;
const N49 = 49;
const N50 = 50;
const N51 = 51;
const N52 = 52;
const N53 = 53;
const N54 = 54;
const N55 = 55;
const N56 = 56;
const N57 = 57;
const N59 = 58;
const N62 = 59;
const N60 = 60;
const N61 = 61;
const N63 = 62;
const N64 = 63;
const N65 = 64;
const N66 = 65;
const N67 = 66;
const N68 = 67;
const N69 = 68;
const N70 = 69;
const N71 = 70;
const N72 = 71;
const N73 = 72;
const N74 = 73;
const N75 = 74;
const N76 = 75;
const N77 = 76;
const N78 = 77;
const N79 = 78;
const N80 = 79;
const N81 = 80;
const N82 = 81;
const N83 = 82;
const N84 = 83;
const N85 = 84;
const N86 = 85;
const N87 = 86;
const N88 = 87;
const N90 = 88;
const N91 = 89;
const N92 = 90;
const N93 = 91;
const N94 = 92;
const N95 = 93;
const N96 = 94;
const N97 = 95;
const N98 = 96;
const N99 = 97;
const N103 = 98;
const N104 = 99;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Test KOLjanFX' ).SetPosition( 192, 110 ).SetClientSize( 688, 426 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := -11;
    Result.Form.Font.FontName := 'Tahoma';
    Result.Form.Border := 0;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ 'File', '('
      , 'Open bitmap...'+#9+'Ctrl+O', '-' + '', 'Exit', ')'
      , 'Undo', 'Effects', '(', 'Add color noise'
      , 'Add mono noise', 'AntiAliasing', 'Blend', 'Button'
      , 'Oval button', '(', 'Rimmed', 'Round', 'Double round'
      , ')', 'Contrast', 'Convolve', '(', 'Convolve E'
      , 'Convolve I', 'Convolve M', ')', 'Darkness', 'Embossing'
      , 'Exclude color', 'Extract color', 'Filter', '(', 'Red'
      , 'Green', 'Blue', '-' + '', 'X Red', 'X Green', 'X Blue'
      , ')', 'Fish eye', 'Flip', '(', 'Vertical', 'Horizontal'
      , ')', 'FoldRight', 'Gaussian blur'
      , 'Convert to grayscale', 'Grow', 'Height map', 'Invert'
      , 'Keep', '(', 'Red', 'Green', 'Blue', ')', 'Lightness'
      , 'Make seamless clip', 'Marble', '(', 'Marble 1'
      , 'Marble 2', 'Marble 3', 'Marble 4', 'Marble 5'
      , 'Marble 6', 'Marble 7', 'Marble 8', ')', 'Mask oval'
      , 'Mirror', '(', 'Horizontal', 'Vertical', ')', 'Mosaic'
      , 'Plasma', 'Posterize', 'Opaque', '(', 'Semi', 'Quarto'
      , ')', 'Ripple', '(', 'Tooth', 'Triangle', 'Random', ')'
      , 'Saturation', 'Seamless', 'Shadow', '(', 'Down left'
      , 'Down right', 'Up left', 'Up right', ')', 'Shake', '('
      , 'Vertical', 'Horizontal', ')', 'Smooth', '(', 'Resize'
      , 'Rotate', ')', 'Solarize', 'Split', '(', 'Blur', 'Light'
      , ')', 'Spot light', 'Spray', 'Squeeze horizontal'
      , 'Strecth', 'Texturize', '(', 'Overlap', 'Tile', ')'
      , 'Tile', 'Trace', 'Triangles', 'Twist', 'Wave', ')'
      , '' ], nil );
    Result.MainMenu1.AssignEvents( 1, [ Result.KOLForm1N2Menu ] );
    Result.MainMenu1.ItemAccelerator[ 1 ] := MakeAccelerator( FVIRTKEY or FCONTROL, $4F );
    Result.MainMenu1.AssignEvents( 3, [ Result.KOLForm1N4Menu ] );
    Result.MainMenu1.ItemEnabled[ 4 ] := False;
    Result.MainMenu1.AssignEvents( 4, [ Result.MainMenu1N105Menu ] );
    Result.MainMenu1.AssignEvents( 6, [ Result.KOLForm1N6Menu ] );
    Result.MainMenu1.AssignEvents( 7, [ Result.KOLForm1N7Menu ] );
    Result.MainMenu1.AssignEvents( 8, [ Result.KOLForm1N8Menu ] );
    Result.MainMenu1.AssignEvents( 9, [ Result.KOLForm1N9Menu ] );
    Result.MainMenu1.AssignEvents( 10, [ Result.KOLForm1N10Menu ] );
    Result.MainMenu1.AssignEvents( 12, [ Result.MainMenu1N106Menu ] );
    Result.MainMenu1.AssignEvents( 13, [ Result.MainMenu1N106Menu ] );
    Result.MainMenu1.AssignEvents( 14, [ Result.MainMenu1N106Menu ] );
    Result.MainMenu1.AssignEvents( 15, [ Result.KOLForm1N12Menu ] );
    Result.MainMenu1.AssignEvents( 17, [ Result.MainMenu1N17Menu ] );
    Result.MainMenu1.AssignEvents( 18, [ Result.MainMenu1N17Menu ] );
    Result.MainMenu1.AssignEvents( 19, [ Result.MainMenu1N17Menu ] );
    Result.MainMenu1.AssignEvents( 20, [ Result.KOLForm1N14Menu ] );
    Result.MainMenu1.AssignEvents( 21, [ Result.MainMenu1N20Menu ] );
    Result.MainMenu1.AssignEvents( 22, [ Result.KOLForm1N21Menu ] );
    Result.MainMenu1.AssignEvents( 23, [ Result.KOLForm1N22Menu ] );
    Result.MainMenu1.AssignEvents( 25, [ Result.KOLForm1N24Menu ] );
    Result.MainMenu1.AssignEvents( 26, [ Result.KOLForm1N24Menu ] );
    Result.MainMenu1.AssignEvents( 27, [ Result.KOLForm1N24Menu ] );
    Result.MainMenu1.AssignEvents( 29, [ Result.KOLForm1N24Menu ] );
    Result.MainMenu1.AssignEvents( 30, [ Result.KOLForm1N24Menu ] );
    Result.MainMenu1.AssignEvents( 31, [ Result.KOLForm1N24Menu ] );
    Result.MainMenu1.AssignEvents( 32, [ Result.KOLForm1N31Menu ] );
    Result.MainMenu1.AssignEvents( 34, [ Result.KOLForm1N33Menu ] );
    Result.MainMenu1.AssignEvents( 35, [ Result.KOLForm1N33Menu ] );
    Result.MainMenu1.AssignEvents( 36, [ Result.KOLForm1N35Menu ] );
    Result.MainMenu1.AssignEvents( 37, [ Result.KOLForm1N36Menu ] );
    Result.MainMenu1.AssignEvents( 38, [ Result.KOLForm1N37Menu ] );
    Result.MainMenu1.AssignEvents( 39, [ Result.KOLForm1N38Menu ] );
    Result.MainMenu1.AssignEvents( 40, [ Result.KOLForm1N39Menu ] );
    Result.MainMenu1.AssignEvents( 41, [ Result.KOLForm1N40Menu ] );
    Result.MainMenu1.AssignEvents( 43, [ Result.KOLForm1N42Menu ] );
    Result.MainMenu1.AssignEvents( 44, [ Result.KOLForm1N42Menu ] );
    Result.MainMenu1.AssignEvents( 45, [ Result.KOLForm1N42Menu ] );
    Result.MainMenu1.AssignEvents( 46, [ Result.KOLForm1N45Menu ] );
    Result.MainMenu1.AssignEvents( 47, [ Result.KOLForm1N46Menu ] );
    Result.MainMenu1.AssignEvents( 49, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 50, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 51, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 52, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 53, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 54, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 55, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 56, [ Result.KOLForm1N49Menu ] );
    Result.MainMenu1.AssignEvents( 57, [ Result.KOLForm1N57Menu ] );
    Result.MainMenu1.AssignEvents( 59, [ Result.KOLForm1N62Menu ] );
    Result.MainMenu1.AssignEvents( 60, [ Result.KOLForm1N62Menu ] );
    Result.MainMenu1.AssignEvents( 61, [ Result.KOLForm1N61Menu ] );
    Result.MainMenu1.AssignEvents( 62, [ Result.KOLForm1N63Menu ] );
    Result.MainMenu1.AssignEvents( 63, [ Result.KOLForm1N64Menu ] );
    Result.MainMenu1.AssignEvents( 65, [ Result.KOLForm1N66Menu ] );
    Result.MainMenu1.AssignEvents( 66, [ Result.KOLForm1N66Menu ] );
    Result.MainMenu1.AssignEvents( 68, [ Result.KOLForm1N69Menu ] );
    Result.MainMenu1.AssignEvents( 69, [ Result.KOLForm1N69Menu ] );
    Result.MainMenu1.AssignEvents( 70, [ Result.KOLForm1N69Menu ] );
    Result.MainMenu1.AssignEvents( 71, [ Result.KOLForm1N72Menu ] );
    Result.MainMenu1.AssignEvents( 72, [ Result.KOLForm1N73Menu ] );
    Result.MainMenu1.AssignEvents( 74, [ Result.KOLForm1N75Menu ] );
    Result.MainMenu1.AssignEvents( 75, [ Result.KOLForm1N75Menu ] );
    Result.MainMenu1.AssignEvents( 76, [ Result.KOLForm1N75Menu ] );
    Result.MainMenu1.AssignEvents( 77, [ Result.KOLForm1N75Menu ] );
    Result.MainMenu1.AssignEvents( 79, [ Result.KOLForm1N80Menu ] );
    Result.MainMenu1.AssignEvents( 80, [ Result.KOLForm1N80Menu ] );
    Result.MainMenu1.AssignEvents( 82, [ Result.KOLForm1N83Menu ] );
    Result.MainMenu1.AssignEvents( 83, [ Result.KOLForm1N83Menu ] );
    Result.MainMenu1.AssignEvents( 84, [ Result.KOLForm1N85Menu ] );
    Result.MainMenu1.AssignEvents( 86, [ Result.KOLForm1N87Menu ] );
    Result.MainMenu1.AssignEvents( 87, [ Result.KOLForm1N87Menu ] );
    Result.MainMenu1.AssignEvents( 88, [ Result.KOLForm1N90Menu ] );
    Result.MainMenu1.AssignEvents( 89, [ Result.KOLForm1N91Menu ] );
    Result.MainMenu1.AssignEvents( 90, [ Result.KOLForm1N92Menu ] );
    Result.MainMenu1.AssignEvents( 91, [ Result.KOLForm1N93Menu ] );
    Result.MainMenu1.AssignEvents( 93, [ Result.KOLForm1N95Menu ] );
    Result.MainMenu1.AssignEvents( 94, [ Result.KOLForm1N95Menu ] );
    Result.MainMenu1.AssignEvents( 95, [ Result.KOLForm1N97Menu ] );
    Result.MainMenu1.AssignEvents( 96, [ Result.KOLForm1N98Menu ] );
    Result.MainMenu1.AssignEvents( 97, [ Result.KOLForm1N99Menu ] );
    Result.MainMenu1.AssignEvents( 98, [ Result.MainMenu1N103Menu ] );
    Result.MainMenu1.AssignEvents( 99, [ Result.KOLForm1N104Menu ] );

    Result.OpenDlg := NewOpenSaveDialog( 'Select bitmap...', '', [ OSFileMustExist, OSHideReadonly, OSPathMustExist ] );
      Result.OpenDlg.Filter := 'Bitmaps|*.bmp;*.dib|All files|*.*';
      Result.OpenDlg.DefExtension := 'bmp';
  Result.Form.Add2AutoFree( Result.OpenDlg );
    // Result.ScrollBox1.TabOrder = 0
    Result.ScrollBox1 := NewScrollBoxEx( Result.Form, esLowered ).SetAlign ( caClient );
    Result.ScrollBox1.Color := clAppWorkSpace;
    // Result.Image.TabOrder = 0
      Result.Image := NewPaintBox( Result.ScrollBox1 ).SetSize( 32, 32 );
      Result.Image.OnPaint := Result.ImagePaint;
      Result.OpenDlg.WndOwner := Result.Form.GetWindowHandle;
    Result.KOLForm1FormCreate( Result );

end;

