{ KOL MCK } // Do not remove this line!
const TBTimeBack = 0;
const TBTimeFwd = 1;
const TBMap = 2;
const TBAddRoom = 3;
const TBConfig = 4;

const pr1 = 0;
const pr2 = 1;
const pr3 = 2;
const pr4 = 3;
const pr5 = 4;
const pr6 = 5;
const pr7 = 6;
const pr8 = 7;
const pr9 = 8;

const N37 = 0;
const N36 = 1;

const N1 = 0;
const mmOpen = 1;
const mmOpenPokes = 2;
const mmSave = 3;
const mmSaveAs = 4;
const N44 = 5;
const mmShot = 6;
const N8 = 7;
const mmRecordSound = 8;
const mmRecordVideo = 9;
const mmRecordAction = 10;
const mmStopRecord = 11;
const N45 = 12;
const N5 = 13;
const mmS48 = 14;
const mmS128 = 15;
const mmPentagon = 16;
const mmScorpion = 17;
const mmKAY = 18;
const mmProfi = 19;
const mmATM1 = 20;
const mmATM2 = 21;
const N47 = 22;
const mmCustomROM = 23;
const mmReset = 24;
const N35 = 25;
const mmTimeBack = 26;
const mmTimeHistory = 27;
const mm2secBack = 28;
const mm2secFwd = 29;
const mmTimeBkPauseOn = 30;
const N32 = 31;
const mmReopen1 = 32;
const mmReopen2 = 33;
const mmReopen3 = 34;
const mmReopen4 = 35;
const mmReopen5 = 36;
const mmReopen6 = 37;
const mmReopen7 = 38;
const mmReopen8 = 39;
const mmReopen9 = 40;
const mmSepReopen = 41;
const N18 = 42;
const N17 = 43;
const N33 = 44;
const N11 = 45;
const mmPause = 46;
const mmMinimize2Tray = 47;
const mmAutoPause = 48;
const N13 = 49;
const mmJoyOn = 50;
const N21 = 51;
const mmKeybRemap = 52;
const N12 = 53;
const N14 = 54;
const mmSpeed50 = 55;
const mmSpeed70 = 56;
const mmSpeed100 = 57;
const mmSpeed150 = 58;
const mmSpeed200 = 59;
const mmSpeed300 = 60;
const mmSpeed400 = 61;
const mmSpeed500 = 62;
const mmSpeed600 = 63;
const mmSpeed700 = 64;
const mmSpeed800 = 65;
const mmSpeedCustom = 66;
const N25 = 67;
const mmPriorityHigh = 68;
const mmPriorityAbove = 69;
const mmPriorityNormal = 70;
const mmSound = 71;
const mmSoundOn = 72;
const N26 = 73;
const mmDirectSound = 74;
const mmPCSpeaker = 75;
const N38 = 76;
const mmTape = 77;
const mmTapePlay = 78;
const mmAutoPlayTape = 79;
const N23 = 80;
const mmTapeFastLoad = 81;
const mmFlashTape = 82;
const mmDoublePilot = 83;
const N22 = 84;
const mmTapeCatalog = 85;
const N31 = 86;
const mmInterface1On = 87;
const mmMDrives = 88;
const N42 = 89;
const mmFastMicrodrive = 90;
const mmDisciple_PlusD = 91;
const mmDisciplePlusd_Off = 92;
const mmDisciple_On = 93;
const mmPlusD_On = 94;
const mmDisciplePlusD_Auto = 95;
const N20 = 96;
const mmDiscipleBrowser = 97;
const mmTRDOS = 98;
const mmTRDOS_on = 99;
const mmFastDisk = 100;
const mmDiskBrowser = 101;
const N34 = 102;
const mmBootDisk = 103;
const mmMagic = 104;
const N28 = 105;
const mmConfigs = 106;
const N2 = 107;
const mmViewToolbar = 108;
const mmViewStatus = 109;
const N39 = 110;
const N16 = 111;
const mmDirectX = 112;
const mmGUI = 113;
const mmInterlace = 114;
const mmProportional = 115;
const N3 = 116;
const N4 = 117;
const N6 = 118;
const N7 = 119;
const N24 = 120;
const mmReduce = 121;
const mmIncrease = 122;
const N15 = 123;
const mmBorderNone = 124;
const mmBorderThin = 125;
const mmBorderSmall = 126;
const mmBorderMedium = 127;
const mmBorderThick = 128;
const mmAllowSkipFrames = 129;
const N19 = 130;
const mmAdjustColors = 131;
const N27 = 132;
const N41 = 133;
const mmMulticolor = 134;
const N43 = 135;
const mmTimingAuto = 136;
const mmTiming48 = 137;
const mmTiming128 = 138;
const mmTiming128Plus2 = 139;
const mmTiming128Plus2APlus3 = 140;
const mmTimingPentagon = 141;
const mmTimingScorpion = 142;
const mmTimingCustom = 143;
const mm256Colors = 144;
const N30 = 145;
const mmHQMFilter = 146;
const mmGigaScreen = 147;
const mmSnowEffect = 148;
const mmFlipVert = 149;
const mmStayOnTop = 150;
const N40 = 151;
const mmDebug = 152;
const mmAssembler = 153;
const mmGFXEditor = 154;
const N9 = 155;
const mmKeyboard = 156;
const mmPokes = 157;
const mmEnterPoke = 158;
const mmMap = 159;
const N29 = 160;
const mmLensKey = 161;
const N10 = 162;

const TBOpen = 0;
const TBSave = 1;
const TBSep1 = 2;
const TBDisplaySize = 3;
const TBFullScreen = 4;
const TBKeyboard = 5;
const TBPokes = 6;
const TBSep2 = 7;
const TBReset = 8;
const TBPause = 9;
const TBDebug = 10;
const TBSpeed = 11;
const TBSoundOn = 12;
const TBSoundOff = 13;
const TBMulticolor = 14;
const TBSep3 = 15;
const TBDisk = 16;
const TBPlayTape = 17;


procedure NewForm1( var Result: PForm1; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PForm1.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'EmuZ Win' ).SetPosition( 196, 370 ).SetClientSize( 653, 351 ).SupportMnemonics;
  Result.Form.Add2AutoFree( Result );
    Result.Form.Font.FontHeight := 16;
    Result.Form.Font.FontName := 'Arial';
      Applet.OnMessage := Result.KOLApplet1Message;
      Applet.OnMinimize := Result.KOLApplet1Minimize;
      Result.Form.OnMessage := Result.KOLForm1Message;
      Result.Form.OnClose := Result.KOLForm1Close;
      Result.Form.OnMaximize := Result.KOLForm1Maximize;
      Result.Form.OnMouseDblClk := Result.PaintBox1MouseDblClk;
      Result.Form.OnResize := Result.KOLForm1Resize;
      Result.Form.OnShow := Result.KOLForm1Show;
      Result.Form.OnDropFiles := Result.KOLForm1DropFiles;
      Result.Form.OnDestroy := Result.KOLForm1Destroy;

    Result.MainMenu1 := NewMenu( Result.Form, 0, [ '&File', '('
      , '&Open'+#9+'F3', 'Open &Pokes...', '&Save'+#9+'F2'
      , 'Save &As...'+#9+'Alt+F2', '-' + ''
      , 'Save screensho&t'+#9+'F5', 'Save Opcodes'
      , '&Record and Save Sound As...'
      , 'Record and Save &Video As...'
      , 'Record and Save Replay Action As ...'+#9+'Alt+R'
      , 'Stop Recording Sound/Video'+#9+'F6', '-' + '', '&Model'
      , '(', '+!' + 'Spectrum-&48', '-!' + 'Spectrum-&128'
      , '-!' + '&Pentagon 256K/512K'
      , '-!' + '&Scorpion 256K/1024K', '-!' + '&KAY 256K/1024K'
      , '-!' + 'Pro&fi 256K-1024K', '-!' + '&ATM-1 512K/1024K'
      , '-!' + 'ATM-Turbo2/Turbo2+ 1024K', '-' + ''
      , 'Custom &ROM Image...', ')', '&Reset'+#9+'F11', '-' + ''
      , 'Time &Back', '(', '+' + 'History Enabled'
      , '2 seconds back^Alt+<, Alt+Left'
      , '2 seconds forward^Alt+>, Alt+Right'
      , '+' + '&Pause On Apply', ')', '-' + '', ' ', ' ', ' '
      , ' ', ' ', ' ', ' ', ' ', ' ', '-' + ''
      , 'Path To PKUN&ZIP', '-' + '', 'E&xit', ')', '&Control'
      , '(', '&Pause/Resume'+#9+'F9'
      , 'Pause And &Minimize To Tray'+#9+'Escape'
      , '+' + '&Auto Pause', '-' + ''
      , '+' + '&Joystick On'+#9+'Alt+J'
      , 'Joystick and Mouse Configuration'
      , '&Keyboard Remapping', '-' + '', '&Speed', '('
      , '-!' + '50% (1.75MHz)^Alt+Num[ * ] to fast switch'
      , '-!' + '70% (2.45MHz)'
      , '+!' + '100% (3.5MHz) ^NUM[ * ] to fast switch'
      , '-!' + '150% (5.25MHz)'
      , '-!' + '200% (7MHz)^NUM[ * ] to fast switch'
      , '-!' + '300% (10.5MHz)', '-!' + '400% (14MHz)'
      , '-!' + '500% (17.5MHz)', '-!' + '600% (21MHz)'
      , '-!' + '700% (24.5MHz)'
      , '-!' + '800% (28MHz)^Alt+Num[ * ] to fast switch'
      , '-!' + '&Custom'+#9+'Alt+S', ')', 'Priorit&y', '('
      , '-!' + '&High', '-!' + '&Above Normal', '+!' + '&Normal'
      , ')', 'S&ound', '(', '+' + 'Sound &On', '-' + ''
      , '+!' + '&Direct Sound', '-!' + '&PC Speaker', ')'
      , '-' + '', '&Tape', '(', '&Play/Stop'+#9+'Alt+P'
      , '+' + '&Auto Play/Stop', '-' + ''
      , '+' + '&Fast Load'+#9+'/', '+' + 'F&lash Load'
      , '+' + '&Double Pilot', '-' + ''
      , '&Catalog Show'+#9+'Alt+T', ')'
      , '&Interface-I && Microdrive', '('
      , '+' + 'Interface-I &On', '&Microdrive slots', '-' + ''
      , '+' + '&Fast Microdrive', ')'
      , '&Disciple/+D Disk interface', '('
      , '+!' + 'Disciple/+D Off', '-!' + 'Disciple On'
      , '-!' + ' +D On', '-!' + 'Disciple/+D &Autoselect'
      , '-' + '', '&Disciple/+D Disk Browser'+#9+'Alt+D', ')'
      , '&Beta 128 (TR-DOS)', '(', '+' + 'TR-DOS &On'
      , '+' + '&Fast Disk', '&Disk Browser'+#9+'Alt+D', '-' + ''
      , '&Boot'+#9+'Alt+B', '&Magic Button'+#9+'Alt+M', ')'
      , '-' + '', '&Configurations'+#9+'Alt+C', ')', '&View'
      , '(', '+' + '&Toolbar', '+' + '&Statusbar', '-' + ''
      , 'Display &Mode', '('
      , '-!' + '&Full-Screen^Alt+Enter,Dbl Click'
      , '+!' + '&GUI^Alt+Enter,Dbl Click', ')'
      , '+' + '&Interlaced in Full Screen'+#9+'Alt+I'
      , '+' + 'Pr&oportional Size', 'Display &Size', '('
      , '1:1 (256x192 main screen)', '2:1 (512x384 main screen)'
      , '3:1 (768x576 main screen)', '-' + ''
      , '&Reduce^Alt+NUM[ - ]', '&Increase^Alt+NUM[ + ]', ')'
      , 'Display &Border', '(', '-!' + '&None'
      , '-!' + '&Thin (8 pts)', '-!' + '&Small (16 pts)'
      , '+!' + '&Medium (32 pts)', '-!' + 'Thic&k (48 pts)', ')'
      , '+' + '&Allow Skip Frames', '-' + '', 'Adjust &Colors'
      , ')', '&Effects', '(', '&Multicolor', '('
      , '+' + 'Multicolor &On', '-' + '', '-!' + 'Timing &Auto'
      , '-!' + 'Timing Spectrum &48'
      , '-!' + 'Timing Spectrum &128'
      , '-!' + 'Timing Spectrum 128+&2'
      , '-!' + 'Timing Spectrum 128+2A/+&3'
      , '-!' + 'Timing &Pentagon', 'Timing Sco&rpion'
      , '-!' + 'Timing &Custom', ')', '+' + '256 &Colors'
      , '-' + '', '+' + 'High Quality Magnification'+#9+'Alt+H'
      , '+' + '&GigaScreen'+#9+'Alt+G'
      , '+' + '&Snow Effect Allowed'
      , '+' + 'Flip &Vertical'+#9+'Alt+Y'
      , '+' + 'Stay On &Top, Transparent (Win2000, XP, LongHorn only)'
      , ')', '&Tools', '(', '&Debug Window', '&Assembler'
      , '&GFX Editor', '-' + '', '&Keyboard'+#9+'Alt+K'
      , '&Pokes'+#9+'Alt+O', '&Enter Poke'+#9+'Alt+E'
      , '&Map Builder', '-' + '', '&Lens Key', ')', '&About'
      , '' ], nil );
    Result.MainMenu1.ItemBitmap[ 1 ] := LoadBmp( hInstance, 'FORM1_MMOPEN_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmOpen_BMP.res}
    Result.MainMenu1.AssignEvents( 1, [ Result.KOLForm1mmOpenMenu ] );
    Result.MainMenu1.ItemAccelerator[ 1 ] := MakeAccelerator( FVIRTKEY, VK_F3 );
    Result.MainMenu1.ItemBitmap[ 2 ] := LoadBmp( hInstance, 'FORM1_MMOPENPOKES_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmOpenPokes_BMP.res}
    Result.MainMenu1.AssignEvents( 2, [ Result.KOLForm1mmOpenPokesMenu ] );
    Result.MainMenu1.ItemBitmap[ 3 ] := LoadBmp( hInstance, 'FORM1_MMSAVE_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmSave_BMP.res}
    Result.MainMenu1.AssignEvents( 3, [ Result.KOLForm1mmSaveMenu ] );
    Result.MainMenu1.ItemAccelerator[ 3 ] := MakeAccelerator( FVIRTKEY, VK_F2 );
    Result.MainMenu1.ItemBitmap[ 4 ] := LoadBmp( hInstance, 'FORM1_MMSAVEAS_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmSaveAs_BMP.res}
    Result.MainMenu1.AssignEvents( 4, [ Result.MainMenu1mmSaveAsMenu ] );
    Result.MainMenu1.ItemAccelerator[ 4 ] := MakeAccelerator( FVIRTKEY or FALT, VK_F2 );
    Result.MainMenu1.ItemBitmap[ 6 ] := LoadBmp( hInstance, 'FORM1_MMSHOT_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmShot_BMP.res}
    Result.MainMenu1.AssignEvents( 6, [ Result.KOLForm1mmShotMenu ] );
    Result.MainMenu1.ItemAccelerator[ 6 ] := MakeAccelerator( FVIRTKEY, VK_F5 );
    Result.MainMenu1.ItemVisible[ 7 ] := False;
    Result.MainMenu1.AssignEvents( 7, [ Result.MainMenu1N8Menu ] );
    Result.MainMenu1.AssignEvents( 8, [ Result.KOLForm1mmRecordSoundMenu ] );
    Result.MainMenu1.ItemVisible[ 9 ] := False;
    Result.MainMenu1.AssignEvents( 10, [ Result.KOLForm1mmRecordAction_Menu ] );
    Result.MainMenu1.ItemAccelerator[ 10 ] := MakeAccelerator( FVIRTKEY or FALT, $52 );
    Result.MainMenu1.ItemEnabled[ 11 ] := False;
    Result.MainMenu1.AssignEvents( 11, [ Result.MainMenu1mmStopRecordMenu ] );
    Result.MainMenu1.ItemAccelerator[ 11 ] := MakeAccelerator( FVIRTKEY, VK_F6 );
    Result.MainMenu1.AssignEvents( 14, [ Result.MainMenu1mmS48Menu ] );
    Result.MainMenu1.AssignEvents( 15, [ Result.MainMenu1mmS128Menu ] );
    Result.MainMenu1.AssignEvents( 16, [ Result.MainMenu1mmPentagonMenu ] );
    Result.MainMenu1.AssignEvents( 17, [ Result.MainMenu1mmScorpionMenu ] );
    Result.MainMenu1.AssignEvents( 18, [ Result.MainMenu1mmKAYMenu ] );
    Result.MainMenu1.AssignEvents( 19, [ Result.MainMenu1mmProfiMenu ] );
    Result.MainMenu1.AssignEvents( 20, [ Result.MainMenu1mmATM1Menu ] );
    Result.MainMenu1.AssignEvents( 21, [ Result.MainMenu1mmATM2Menu ] );
    Result.MainMenu1.AssignEvents( 23, [ Result.MainMenu1mmCustomROMMenu ] );
    Result.MainMenu1.ItemBitmap[ 24 ] := LoadBmp( hInstance, 'FORM1_MMRESET_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmReset_BMP.res}
    Result.MainMenu1.AssignEvents( 24, [ Result.MainMenu1mmResetMenu ] );
    Result.MainMenu1.ItemAccelerator[ 24 ] := MakeAccelerator( FVIRTKEY, VK_F11 );
    Result.MainMenu1.AssignEvents( 27, [ Result.MainMenu1mmTimeHistoryMenu ] );
    Result.MainMenu1.AssignEvents( 28, [ Result.KOLForm1mm2secBackMenu ] );
    Result.MainMenu1.AssignEvents( 29, [ Result.KOLForm1mm2secFwdMenu ] );
    Result.MainMenu1.ItemVisible[ 32 ] := False;
    Result.MainMenu1.AssignEvents( 32, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[32].Tag := DWORD(1);
    Result.MainMenu1.ItemVisible[ 33 ] := False;
    Result.MainMenu1.AssignEvents( 33, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[33].Tag := DWORD(2);
    Result.MainMenu1.ItemVisible[ 34 ] := False;
    Result.MainMenu1.AssignEvents( 34, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[34].Tag := DWORD(3);
    Result.MainMenu1.ItemVisible[ 35 ] := False;
    Result.MainMenu1.AssignEvents( 35, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[35].Tag := DWORD(4);
    Result.MainMenu1.ItemVisible[ 36 ] := False;
    Result.MainMenu1.AssignEvents( 36, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[36].Tag := DWORD(5);
    Result.MainMenu1.ItemVisible[ 37 ] := False;
    Result.MainMenu1.AssignEvents( 37, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[37].Tag := DWORD(6);
    Result.MainMenu1.ItemVisible[ 38 ] := False;
    Result.MainMenu1.AssignEvents( 38, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[38].Tag := DWORD(7);
    Result.MainMenu1.ItemVisible[ 39 ] := False;
    Result.MainMenu1.AssignEvents( 39, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[39].Tag := DWORD(8);
    Result.MainMenu1.ItemVisible[ 40 ] := False;
    Result.MainMenu1.AssignEvents( 40, [ Result.MainMenu1mmReopen1Menu ] );
    Result.MainMenu1.Items[40].Tag := DWORD(9);
    Result.MainMenu1.ItemVisible[ 41 ] := False;
    Result.MainMenu1.AssignEvents( 42, [ Result.MainMenu1N18Menu ] );
    Result.MainMenu1.AssignEvents( 44, [ Result.MainMenu1N33Menu ] );
    Result.MainMenu1.ItemBitmap[ 46 ] := LoadBmp( hInstance, 'FORM1_MMPAUSE_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmPause_BMP.res}
    Result.MainMenu1.AssignEvents( 46, [ Result.MainMenu1mmPauseMenu ] );
    Result.MainMenu1.ItemAccelerator[ 46 ] := MakeAccelerator( FVIRTKEY, VK_F9 );
    Result.MainMenu1.AssignEvents( 47, [ Result.MainMenu1mmMinimize2TrayMenu ] );
    Result.MainMenu1.ItemAccelerator[ 47 ] := MakeAccelerator( FVIRTKEY, VK_ESCAPE );
    Result.MainMenu1.AssignEvents( 48, [ Result.MainMenu1mmAutoPauseMenu ] );
    Result.MainMenu1.AssignEvents( 50, [ Result.MainMenu1mmJoyOnMenu ] );
    Result.MainMenu1.ItemAccelerator[ 50 ] := MakeAccelerator( FVIRTKEY or FALT, $4A );
    Result.MainMenu1.AssignEvents( 51, [ Result.MainMenu1N21Menu ] );
    Result.MainMenu1.AssignEvents( 52, [ Result.MainMenu1mmKeybRemapMenu ] );
    Result.MainMenu1.ItemBitmap[ 54 ] := LoadBmp( hInstance, 'FORM1_N14_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_N14_BMP.res}
    Result.MainMenu1.AssignEvents( 55, [ Result.MainMenu1mmSpeed50Menu ] );
    Result.MainMenu1.AssignEvents( 56, [ Result.KOLForm1mmSpeed70Menu ] );
    Result.MainMenu1.AssignEvents( 57, [ Result.MainMenu1mmSpeed100Menu ] );
    Result.MainMenu1.AssignEvents( 58, [ Result.MainMenu1mmSpeed150Menu ] );
    Result.MainMenu1.AssignEvents( 59, [ Result.MainMenu1mmSpeed200Menu ] );
    Result.MainMenu1.AssignEvents( 60, [ Result.MainMenu1mmSpeed300Menu ] );
    Result.MainMenu1.AssignEvents( 61, [ Result.MainMenu1mmSpeed400Menu ] );
    Result.MainMenu1.AssignEvents( 62, [ Result.MainMenu1mmSpeed500Menu ] );
    Result.MainMenu1.AssignEvents( 63, [ Result.MainMenu1mmSpeed600Menu ] );
    Result.MainMenu1.AssignEvents( 64, [ Result.MainMenu1mmSpeed700Menu ] );
    Result.MainMenu1.AssignEvents( 65, [ Result.MainMenu1mmSpeed800Menu ] );
    Result.MainMenu1.AssignEvents( 66, [ Result.KOLForm1mmSpeedCustomMenu ] );
    Result.MainMenu1.ItemAccelerator[ 66 ] := MakeAccelerator( FVIRTKEY or FALT, $53 );
    Result.MainMenu1.AssignEvents( 68, [ Result.MainMenu1mmPriorityHighMenu ] );
    Result.MainMenu1.AssignEvents( 69, [ Result.MainMenu1mmPriorityAboveMenu ] );
    Result.MainMenu1.AssignEvents( 70, [ Result.MainMenu1mmPriorityNormalMenu ] );
    Result.MainMenu1.ItemBitmap[ 71 ] := LoadBmp( hInstance, 'FORM1_MMSOUND_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmSound_BMP.res}
    Result.MainMenu1.AssignEvents( 72, [ Result.MainMenu1mmSoundOnMenu ] );
    Result.MainMenu1.AssignEvents( 74, [ Result.KOLForm1mmDirectSoundMenu ] );
    Result.MainMenu1.AssignEvents( 75, [ Result.KOLForm1mmPCSpeakerMenu ] );
    Result.MainMenu1.ItemBitmap[ 78 ] := LoadBmp( hInstance, 'FORM1_MMTAPEPLAY_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmTapePlay_BMP.res}
    Result.MainMenu1.AssignEvents( 78, [ Result.MainMenu1mmTapePlayMenu ] );
    Result.MainMenu1.ItemAccelerator[ 78 ] := MakeAccelerator( FVIRTKEY or FALT, $50 );
    Result.MainMenu1.AssignEvents( 79, [ Result.MainMenu1mmAutoPlayTapeMenu ] );
    Result.MainMenu1.AssignEvents( 81, [ Result.MainMenu1mmTapeFastLoadMenu ] );
    Result.MainMenu1.ItemAccelerator[ 81 ] := MakeAccelerator( FVIRTKEY, VK_DIVIDE );
    Result.MainMenu1.AssignEvents( 82, [ Result.MainMenu1mmFlashTapeMenu ] );
    Result.MainMenu1.AssignEvents( 83, [ Result.KOLForm1mmDoublePilotMenu ] );
    Result.MainMenu1.AssignEvents( 85, [ Result.MainMenu1mmTapeCatalogMenu ] );
    Result.MainMenu1.ItemAccelerator[ 85 ] := MakeAccelerator( FVIRTKEY or FALT, $54 );
    Result.MainMenu1.AssignEvents( 87, [ Result.KOLForm1mmInterface1OnMenu ] );
    Result.MainMenu1.AssignEvents( 88, [ Result.MainMenu1mmMDrivesMenu ] );
    Result.MainMenu1.AssignEvents( 90, [ Result.KOLForm1mmFastMicrodriveMenu ] );
    Result.MainMenu1.AssignEvents( 92, [ Result.MainMenu1mmDisciplePlusd_OffMenu ] );
    Result.MainMenu1.AssignEvents( 93, [ Result.KOLForm1mmDisciple_OnMenu ] );
    Result.MainMenu1.AssignEvents( 94, [ Result.KOLForm1mmPlusD_OnMenu ] );
    Result.MainMenu1.AssignEvents( 95, [ Result.KOLForm1mmDisciplePlusD_AutoMenu ] );
    Result.MainMenu1.ItemEnabled[ 97 ] := False;
    Result.MainMenu1.ItemBitmap[ 97 ] := LoadBmp( hInstance, 'FORM1_MMDISCIPLEBROWSER_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmDiscipleBrowser_BMP.res}
    Result.MainMenu1.AssignEvents( 97, [ Result.MainMenu1mmDiscipleBrowserMenu ] );
    Result.MainMenu1.ItemAccelerator[ 97 ] := MakeAccelerator( FVIRTKEY or FALT, $44 );
    Result.MainMenu1.AssignEvents( 99, [ Result.KOLForm1mmTRDOS_onMenu ] );
    Result.MainMenu1.AssignEvents( 100, [ Result.MainMenu1mmFastDiskMenu ] );
    Result.MainMenu1.ItemBitmap[ 101 ] := LoadBmp( hInstance, 'FORM1_MMDISKBROWSER_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmDiskBrowser_BMP.res}
    Result.MainMenu1.AssignEvents( 101, [ Result.MainMenu1mmDiskBrowserMenu ] );
    Result.MainMenu1.ItemAccelerator[ 101 ] := MakeAccelerator( FVIRTKEY or FALT, $44 );
    Result.MainMenu1.AssignEvents( 103, [ Result.MainMenu1mmBootDiskMenu ] );
    Result.MainMenu1.ItemAccelerator[ 103 ] := MakeAccelerator( FVIRTKEY or FALT, $42 );
    Result.MainMenu1.AssignEvents( 104, [ Result.MainMenu1mmMagicMenu ] );
    Result.MainMenu1.ItemAccelerator[ 104 ] := MakeAccelerator( FVIRTKEY or FALT, $4D );
    Result.MainMenu1.ItemBitmap[ 106 ] := LoadBmp( hInstance, 'FORM1_MMCONFIGS_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmConfigs_BMP.res}
    Result.MainMenu1.AssignEvents( 106, [ Result.MainMenu1mmConfigsMenu ] );
    Result.MainMenu1.ItemAccelerator[ 106 ] := MakeAccelerator( FVIRTKEY or FALT, $43 );
    Result.MainMenu1.AssignEvents( 108, [ Result.MainMenu1mmViewToolbarMenu ] );
    Result.MainMenu1.AssignEvents( 109, [ Result.KOLForm1mmViewStatusMenu ] );
    Result.MainMenu1.AssignEvents( 112, [ Result.MainMenu1mmDirectXMenu ] );
    Result.MainMenu1.AssignEvents( 113, [ Result.KOLForm1mmGUIMenu ] );
    Result.MainMenu1.AssignEvents( 114, [ Result.MainMenu1mmInterlaceMenu ] );
    Result.MainMenu1.ItemAccelerator[ 114 ] := MakeAccelerator( FVIRTKEY or FALT, $49 );
    Result.MainMenu1.AssignEvents( 115, [ Result.MainMenu1mmProportionalMenu ] );
    Result.MainMenu1.ItemBitmap[ 116 ] := LoadBmp( hInstance, 'FORM1_N3_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_N3_BMP.res}
    Result.MainMenu1.AssignEvents( 117, [ Result.MainMenu1N4Menu ] );
    Result.MainMenu1.AssignEvents( 118, [ Result.MainMenu1N6Menu ] );
    Result.MainMenu1.AssignEvents( 119, [ Result.MainMenu1N7Menu ] );
    Result.MainMenu1.AssignEvents( 121, [ Result.KOLForm1mmReduceMenu ] );
    Result.MainMenu1.AssignEvents( 122, [ Result.KOLForm1mmIncreaseMenu ] );
    Result.MainMenu1.AssignEvents( 124, [ Result.MainMenu1mmBorderNoneMenu ] );
    Result.MainMenu1.ItemVisible[ 125 ] := False;
    Result.MainMenu1.AssignEvents( 125, [ Result.MainMenu1mmBorderThinMenu ] );
    Result.MainMenu1.AssignEvents( 126, [ Result.MainMenu1mmBorderSmallMenu ] );
    Result.MainMenu1.AssignEvents( 127, [ Result.MainMenu1mmBorderMediumMenu ] );
    Result.MainMenu1.AssignEvents( 128, [ Result.MainMenu1mmBorderThickMenu ] );
    Result.MainMenu1.AssignEvents( 129, [ Result.MainMenu1mmAllowSkipFrames1Menu ] );
    Result.MainMenu1.ItemBitmap[ 131 ] := LoadBmp( hInstance, 'FORM1_MMADJUSTCOLORS_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmAdjustColors_BMP.res}
    Result.MainMenu1.AssignEvents( 131, [ Result.MainMenu1mmAdjustColorsMenu ] );
    Result.MainMenu1.ItemBitmap[ 133 ] := LoadBmp( hInstance, 'FORM1_N41_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_N41_BMP.res}
    Result.MainMenu1.AssignEvents( 134, [ Result.MainMenu1mmMulticolorMenu ] );
    Result.MainMenu1.AssignEvents( 136, [ Result.MainMenu1mmTimingAutoMenu ] );
    Result.MainMenu1.AssignEvents( 137, [ Result.MainMenu1mmTiming48Menu ] );
    Result.MainMenu1.AssignEvents( 138, [ Result.MainMenu1mmTiming128Menu ] );
    Result.MainMenu1.AssignEvents( 139, [ Result.MainMenu1mmTiming128Plus2Menu ] );
    Result.MainMenu1.AssignEvents( 140, [ Result.MainMenu1mmTiming128Plus2APlus3Menu ] );
    Result.MainMenu1.AssignEvents( 141, [ Result.MainMenu1mmTimingPentagonMenu ] );
    Result.MainMenu1.AssignEvents( 142, [ Result.MainMenu1mmTimingScorpionMenu ] );
    Result.MainMenu1.AssignEvents( 143, [ Result.MainMenu1mmTimingCustomMenu ] );
    Result.MainMenu1.AssignEvents( 144, [ Result.MainMenu1mm256ColorsMenu ] );
    Result.MainMenu1.AssignEvents( 146, [ Result.KOLForm1mmHQMFilterMenu ] );
    Result.MainMenu1.ItemAccelerator[ 146 ] := MakeAccelerator( FVIRTKEY or FALT, $48 );
    Result.MainMenu1.AssignEvents( 147, [ Result.MainMenu1mmGigaScreenMenu ] );
    Result.MainMenu1.ItemAccelerator[ 147 ] := MakeAccelerator( FVIRTKEY or FALT, $47 );
    Result.MainMenu1.AssignEvents( 148, [ Result.KOLForm1mmSnowEffectMenu ] );
    Result.MainMenu1.AssignEvents( 149, [ Result.KOLForm1mmFlipVertMenu ] );
    Result.MainMenu1.ItemAccelerator[ 149 ] := MakeAccelerator( FVIRTKEY or FALT, $59 );
    Result.MainMenu1.AssignEvents( 150, [ Result.MainMenu1mmStayOnTopMenu ] );
    Result.MainMenu1.ItemBitmap[ 152 ] := LoadBmp( hInstance, 'FORM1_MMDEBUG_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmDebug_BMP.res}
    Result.MainMenu1.AssignEvents( 152, [ Result.MainMenu1mmDebugMenu ] );
    Result.MainMenu1.ItemBitmap[ 153 ] := LoadBmp( hInstance, 'FORM1_MMASSEMBLER_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmAssembler_BMP.res}
    Result.MainMenu1.AssignEvents( 153, [ Result.MainMenu1mmAssemblerMenu ] );
    Result.MainMenu1.ItemBitmap[ 154 ] := LoadBmp( hInstance, 'FORM1_MMGFXEDITOR_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmGFXEditor_BMP.res}
    Result.MainMenu1.AssignEvents( 154, [ Result.KOLForm1mmGFXEditorMenu ] );
    Result.MainMenu1.ItemBitmap[ 156 ] := LoadBmp( hInstance, 'FORM1_MMKEYBOARD_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmKeyboard_BMP.res}
    Result.MainMenu1.AssignEvents( 156, [ Result.mmKeyboardClick ] );
    Result.MainMenu1.ItemAccelerator[ 156 ] := MakeAccelerator( FVIRTKEY or FALT, $4B );
    Result.MainMenu1.ItemEnabled[ 157 ] := False;
    Result.MainMenu1.ItemBitmap[ 157 ] := LoadBmp( hInstance, 'FORM1_MMPOKES_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmPokes_BMP.res}
    Result.MainMenu1.AssignEvents( 157, [ Result.MainMenu1mmPokes1Menu ] );
    Result.MainMenu1.ItemAccelerator[ 157 ] := MakeAccelerator( FVIRTKEY or FALT, $4F );
    Result.MainMenu1.AssignEvents( 158, [ Result.MainMenu1mmEnterPokeMenu ] );
    Result.MainMenu1.ItemAccelerator[ 158 ] := MakeAccelerator( FVIRTKEY or FALT, $45 );
    Result.MainMenu1.ItemBitmap[ 159 ] := LoadBmp( hInstance, 'FORM1_MMMAP_BMP_BITMAP', Result.MainMenu1 );
    {$R Form1_mmMap_BMP.res}
    Result.MainMenu1.AssignEvents( 159, [ Result.MainMenu1mmMap1Menu ] );
    Result.MainMenu1.ItemEnabled[ 161 ] := False;
    Result.MainMenu1.AssignEvents( 161, [ Result.MainMenu1mmLensKeyMenu ] );
    Result.MainMenu1.AssignEvents( 162, [ Result.KOLForm1N10Menu ] );

      {$R Form1_TrayIcon1.RES}
    Result.TrayIcon1 := NewTrayIcon( Applet, 0 );
    Result.TrayIcon1.Active := FALSE;
    Result.TrayIcon1.Icon := LoadIcon( hInstance, 'ZFORM1_TRAYICON1' );
    Result.TrayIcon1.Tooltip := 'EmuZWin 2.0';
    Result.TrayIcon1.AutoRecreate := TRUE;
  Result.Form.Add2AutoFree( Result.TrayIcon1 );
      Result.TrayIcon1.OnMouse := Result.TrayIcon1Mouse;

    Result.OpenPokesDialog := NewOpenSaveDialog( 'Select POKes file to open', '', [  ] );
      Result.OpenPokesDialog.Filter := 'Pokes file (*.pok)|*.pok';
      Result.OpenPokesDialog.DefExtension := 'pok';
  Result.Form.Add2AutoFree( Result.OpenPokesDialog );

    Result.KeystrokeTimer := NewTimer( 100 );
  Result.Form.Add2AutoFree( Result.KeystrokeTimer );
      Result.KeystrokeTimer.OnDestroy := Result.KeystrokeTimerTimer;
      Result.KeystrokeTimer.OnTimer := Result.KeystrokeTimerTimer;

    Result.SaveScreenDialog := NewOpenSaveDialog( 'Save screenshot as...', '', [ OSFileMustExist, OSHideReadonly, OSOverwritePrompt, OSPathMustExist, OSTemplate, OSHook ] );
      Result.SaveScreenDialog.OpenDialog := FALSE;
      Result.SaveScreenDialog.DefExtension := 'bmp';
  Result.Form.Add2AutoFree( Result.SaveScreenDialog );

    Result.SaveActionDialog := NewOpenSaveDialog( 'Select file to save Replay Action sequence', '', [ OSFileMustExist, OSHideReadonly, OSOverwritePrompt, OSPathMustExist, OSTemplate, OSHook ] );
      Result.SaveActionDialog.Filter := 'Replay Action File (*.RZX)|*.RZX';
      Result.SaveActionDialog.OpenDialog := FALSE;
      Result.SaveActionDialog.DefExtension := 'rzx';
  Result.Form.Add2AutoFree( Result.SaveActionDialog );

    Result.Thread2 := NewThread;
    Result.Thread2.OnExecute := Result.Thread2Execute;
    Result.Thread2.ThreadPriority := THREAD_PRIORITY_HIGHEST;
  Result.Form.Add2AutoFree( Result.Thread2 );

    Result.OpenROMDialog := NewOpenSaveDialog( 'Select ROM Image', '', [  ] );
      Result.OpenROMDialog.Filter := 'Spectrum ROM Image 16K or 32K (*.rom)|*.rom|Any file 16K or 32K (*.*)|*.*';
      Result.OpenROMDialog.DefExtension := 'rom';
  Result.Form.Add2AutoFree( Result.OpenROMDialog );

    Result.Timer1 := NewTimer( 500 );
  Result.Form.Add2AutoFree( Result.Timer1 );
      Result.Timer1.OnTimer := Result.Timer1Timer;

    Result.TimerDisableScreenSaver := NewTimer( 5000 );
  Result.Form.Add2AutoFree( Result.TimerDisableScreenSaver );
      Result.TimerDisableScreenSaver.OnTimer := Result.TimerDisableScreenSaverTimer;

    Result.SaveDialog1 := NewOpenSaveDialog( 'Select File To Save State', '', [  ] );
      Result.SaveDialog1.Filter := 'EmuZWin shapshot (*.ezx)|*.ezx';
      Result.SaveDialog1.OpenDialog := FALSE;
  Result.Form.Add2AutoFree( Result.SaveDialog1 );

    Result.StatusTimer := NewTimer( 500 );
  Result.Form.Add2AutoFree( Result.StatusTimer );
      Result.StatusTimer.OnTimer := Result.StatusTimerTimer;

    Result.Thread1 := NewThread;
    Result.Thread1.OnExecute := Result.Thread1Execute;
  Result.Form.Add2AutoFree( Result.Thread1 );

    Result.PopupRecentList := NewMenu( Result.Form, 0, [ '1'
      , '2', '3', '4', '5', '6', '7', '8', '9', '' ], nil );
    Result.PopupRecentList.ItemVisible[ 0 ] := False;
    Result.PopupRecentList.AssignEvents( 0, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[0].Tag := DWORD(1);
    Result.PopupRecentList.ItemVisible[ 1 ] := False;
    Result.PopupRecentList.AssignEvents( 1, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[1].Tag := DWORD(2);
    Result.PopupRecentList.ItemVisible[ 2 ] := False;
    Result.PopupRecentList.AssignEvents( 2, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[2].Tag := DWORD(3);
    Result.PopupRecentList.ItemVisible[ 3 ] := False;
    Result.PopupRecentList.AssignEvents( 3, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[3].Tag := DWORD(4);
    Result.PopupRecentList.ItemVisible[ 4 ] := False;
    Result.PopupRecentList.AssignEvents( 4, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[4].Tag := DWORD(5);
    Result.PopupRecentList.ItemVisible[ 5 ] := False;
    Result.PopupRecentList.AssignEvents( 5, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[5].Tag := DWORD(6);
    Result.PopupRecentList.ItemVisible[ 6 ] := False;
    Result.PopupRecentList.AssignEvents( 6, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[6].Tag := DWORD(7);
    Result.PopupRecentList.ItemVisible[ 7 ] := False;
    Result.PopupRecentList.AssignEvents( 7, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[7].Tag := DWORD(8);
    Result.PopupRecentList.ItemVisible[ 8 ] := False;
    Result.PopupRecentList.AssignEvents( 8, [ Result.PopupRecentListpr1Menu ] );
    Result.PopupRecentList.Items[8].Tag := DWORD(9);

    Result.TrayPopupMenu := NewMenu( Result.Form, 0, [ 
      '&Restore', 'E&xit', '' ], nil );
    Result.TrayPopupMenu.AssignEvents( 0, [ Result.TrayPopupMenuN37Menu ] );
    Result.TrayPopupMenu.AssignEvents( 1, [ Result.TrayPopupMenuN36Menu ] );

    Result.IL_TB2 := NewImageList( Result.Form );
    Result.IL_TB2.Colors := ilcColorDDB;
      Result.IL_TB2.ImgWidth := 16;
      Result.IL_TB2.ImgHeight := 16;
      {$R Form1_IL_TB2.res}
    Result.IL_TB2.AddMasked( LoadBmp( hInstance, 'FORM1_IL_TB2', Result.IL_TB2 ), clFuchsia );

    Result.IL_TB1 := NewImageList( Result.Form );
    Result.IL_TB1.Colors := ilcColorDDB;
      Result.IL_TB1.ImgWidth := 16;
      Result.IL_TB1.ImgHeight := 16;
      {$R Form1_IL_TB1.res}
    Result.IL_TB1.AddMasked( LoadBmp( hInstance, 'FORM1_IL_TB1', Result.IL_TB1 ), clFuchsia );

    Result.IL_TB2_Disabled := NewImageList( Result.Form );
    Result.IL_TB2_Disabled.Colors := ilcColorDDB;
      Result.IL_TB2_Disabled.ImgWidth := 16;
      Result.IL_TB2_Disabled.ImgHeight := 16;
      {$R Form1_IL_TB2_Disabled.res}
    Result.IL_TB2_Disabled.AddMasked( LoadBmp( hInstance, 'FORM1_IL_TB2_DISABLED', Result.IL_TB2_Disabled ), clFuchsia );

    Result.IL_Thumb := NewImageList( Result.Form );
    Result.IL_Thumb.Colors := ilcColorDDB;
      Result.IL_Thumb.ImgWidth := 16;
      Result.IL_Thumb.ImgHeight := 16;
      {$R Form1_IL_Thumb.res}
    Result.IL_Thumb.AddMasked( LoadBmp( hInstance, 'FORM1_IL_THUMB', Result.IL_Thumb ), clFuchsia );
    // Result.Panel1.TabOrder = 0
    Result.Panel1 := NewPanel( Result.Form, esLowered ).SetAlign ( caClient );
    Result.Panel1.Border := 0;
    // Result.PaintBox1.TabOrder = 0
      Result.PaintBox1 := NewPaintBox( Result.Panel1 ).SetAlign ( caClient );
      Result.PaintBox1.Border := 2;
      Result.PaintBox1.Cursor := LoadCursor( hInstance, 'BLENDCURSOR' );
    // Result.pnSnd.TabOrder = 0
        Result.pnSnd := NewPanel( Result.PaintBox1, esNone ).SetPosition( 304, 168 ).SetSize( 89, 19 );
        Result.pnSnd.Visible := False;
    // Result.thumbVolume.TabOrder = 0
          Result.thumbVolume := NewImageShow( Result.pnSnd, Result.IL_Thumb, 0 ).SetPosition( 24, 2 ).SetSize( 16, 16 );
          Result.thumbVolume.Cursor := LoadCursor( 0, IDC_HAND );
    // Result.pnStereo.TabOrder = 1
          Result.pnStereo := NewPanel( Result.pnSnd, esRaised ).SetPosition( 62, 0 ).SetSize( 27, 18 );
    Result.pnStereo.Font.FontHeight := 12;
    Result.pnStereo.Font.FontWidth := 4;
    Result.pnStereo.VerticalAlign := vaCenter;
          Result.pnStereo.Cursor := LoadCursor( 0, IDC_HAND );
          Result.pnStereo.Caption := 'ABC';
    // Result.pnVolume.TabOrder = 9
          Result.pnVolume := NewPanel( Result.pnSnd, esLowered ).SetPosition( 0, 8 ).SetSize( 62, 4 );
    // Result.Panel2.TabOrder = 0
    Result.Panel2 := NewPanel( Result.Form, esNone ).SetAlign ( caTop ).SetSize( 0, 27 );
    Result.Panel2.Border := 0;
    // Result.pnTB2.TabOrder = 0
      Result.pnTB2 := NewPanel( Result.Panel2, esNone ).SetAlign ( caRight ).SetSize( 140, 0 );
      Result.pnTB2.MarginLeft := 2;
    // Result.Toolbar2.TabOrder = 0
        Result.Toolbar2 := NewToolbar( Result.pnTB2, caTop, [tboTextRight, tboFlat, tboNoDivider], 0, [ ' ', ' ', '+ ', ' ', ' ' ], [ 0, 1, 2, 4, 3 ] ).SetAlign ( caTop );
        Result.Toolbar2.Border := 2;
          Result.Toolbar2.TBSetTooltips( Result.Toolbar2.TBIndex2Item( 0 ), [ 'Time 2 seconds Back (Alt+<, Alt+left, Alt+NUM4)', 'Time 2 seconds Forward (Alt+>, Alt+Right, Alt+NUM6)', 'Map Builder', '&Add Room (Insert)', 'Configuration (Alt+C)' ] );
         Result.Toolbar2.Perform( TB_SETIMAGELIST, 0, Result.IL_TB2.Handle );
         Result.Toolbar2.Perform( TB_SETDISABLEDIMAGELIST, 0, Result.IL_TB2_Disabled.Handle );
          Result.Toolbar2.TBAssignEvents( 0, [ Result.Toolbar2TBTimeBackClick, Result.Toolbar2TBTimeFwdClick, Result.Toolbar2TBMapClick, Result.Toolbar2TBAddRoomClick, Result.Toolbar2TBConfigClick ] );
        Result.Toolbar2.TBButtonVisible[ 3 ] := FALSE;
        Result.Toolbar2.TBButtonVisible[ 1 ] := FALSE;
        Result.Toolbar2.TBButtonVisible[ 0 ] := FALSE;
        if WinVer >= wvXP then
        begin
          Result.Toolbar2.Style := Result.Toolbar2.Style or TBSTYLE_WRAPABLE;
          Result.Toolbar2.Transparent := TRUE;
        end;
    // Result.TapeProgressPanel.TabOrder = 0
      Result.TapeProgressPanel := NewPanel( Result.Panel2, esNone ).SetAlign ( caClient );
      Result.TapeProgressPanel.MarginTop := 1;
      Result.TapeProgressPanel.MarginBottom := 3;
    // Result.ProgressBar1.TabOrder = 0
        Result.ProgressBar1 := NewProgressBarEx( Result.TapeProgressPanel, [ pboSmooth ] ).SetAlign ( caClient );
        Result.ProgressBar1.Cursor := LoadCursor( 0, IDC_HAND );
    // Result.ToolPanel1.TabOrder = 1
      Result.ToolPanel1 := NewPanel( Result.Panel2, esNone ).SetAlign ( caLeft ).SetSize( 445, 0 );
      Result.ToolPanel1.MarginBottom := 2;
    // Result.Toolbar1.TabOrder = 2
        Result.Toolbar1 := NewToolbar( Result.ToolPanel1, caTop, [tboTextRight, tboFlat, tboNoDivider], 0, [ '^ ', ' ', '-', ' ', ' ', '- ', ' ', '-', ' ', '+ ', ' ', '- ', '+ ', ' ', '+ ', '-', ' ', '- ' ], [ 1, 2, -2, 3, 4, 5, 6, -2, 7, 8, 17, 9, 10, 11, 18, -2, 12, 0 ] ).SetAlign ( caTop );
        Result.Toolbar1.MarginLeft := 366;
          Result.Toolbar1.TBSetTooltips( Result.Toolbar1.TBIndex2Item( 0 ), [ 'Open (F3)', 'Save (F2)', '', 'Display Size (Alt+NUM[ + ]/Alt+NUM[ - ])', 'Full Screen (Alt+Enter)', 'Keyboard (Alt+K)', 'Pokes (Alt+O)', '', 'Reset (F11)', 'Pause (Break)', 'Debugger (F12)', 'Normal/Double Speed (NUM[ * ], Alt+NUM[ * ])', 'Sound On/Off', 'Sound On/Off', 'Multicolor', '', 'Disk Browser', 'Play Tape' ] );
         Result.Toolbar1.Perform( TB_SETIMAGELIST, 0, Result.IL_TB1.Handle );
          Result.Toolbar1.TBAssignEvents( 0, [ Result.Toolbar1TBOpenClick, Result.Toolbar1TBSaveClick, nil, Result.Toolbar1TBDisplaySizeClick, Result.Toolbar1TBFullScreenClick, Result.Toolbar1TBKeyboardClick, Result.Toolbar1TBPokesClick, nil, Result.Toolbar1TBResetClick, Result.Toolbar1TBPauseClick, Result.Toolbar1TBDebugClick, Result.Toolbar1TBSpeedClick, Result.Toolbar1TBSoundOnClick, Result.Toolbar1TBSoundOnClick, Result.Toolbar1TBMulticolorClick, nil, Result.Toolbar1TBDiskClick, Result.Toolbar1TBPlayTapeClick ] );
        Result.Toolbar1.TBButtonEnabled[ 17 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 16 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 14 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 13 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 10 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 8 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 6 ] := FALSE;
        Result.Toolbar1.TBButtonVisible[ 4 ] := FALSE;
        if WinVer >= wvXP then
        begin
          Result.Toolbar1.Style := Result.Toolbar1.Style or TBSTYLE_WRAPABLE;
          Result.Toolbar1.Transparent := TRUE;
        end;
    // Result.Panel3.TabOrder = 1
      Result.Panel3 := NewPanel( Result.Panel2, esLowered ).SetAlign ( caBottom ).SetSize( 0, 2 );
      Result.Panel3.Border := 2;
      Result.pnSnd.OnMouseDown := Result.pnSndMouseDown;
      Result.PaintBox1.OnMouseDblClk := Result.PaintBox1MouseDblClk;
      Result.PaintBox1.OnMessage := Result.PaintBox1Message;
      Result.PaintBox1.OnMouseDown := Result.PaintBox1MouseDown;
      Result.PaintBox1.OnMouseMove := Result.PaintBox1MouseMove;
      Result.PaintBox1.OnMouseUp := Result.PaintBox1MouseUp;
      Result.PaintBox1.OnPaint := Result.PaintBox1Paint;
      Result.PaintBox1.OnResize := Result.PaintBox1Resize;
      Result.thumbVolume.OnMessage := Result.thumbVolumeMessage;
      Result.thumbVolume.OnMouseDown := Result.thumbVolumeMouseDown;
      Result.thumbVolume.OnMouseUp := Result.thumbVolumeMouseUp;
      Result.ProgressBar1.OnMouseDown := Result.ProgressBar1MouseDown;
      Result.OpenPokesDialog.WndOwner := Result.Form.GetWindowHandle;
      Result.pnStereo.OnClick := Result.pnStereoClick;
      Result.pnStereo.OnMouseDblClk := Result.pnStereoMouseDblClk;
      Result.pnStereo.OnShow := Result.pnStereoShow;
      Result.SaveScreenDialog.WndOwner := Result.Form.GetWindowHandle;
      Result.SaveActionDialog.WndOwner := Result.Form.GetWindowHandle;
      Result.OpenROMDialog.WndOwner := Result.Form.GetWindowHandle;
    Result.Timer1.Enabled := True;
      Result.SaveDialog1.WndOwner := Result.Form.GetWindowHandle;
      Result.Toolbar1.OnMouseMove := Result.Toolbar1MouseMove;
      Result.pnVolume.OnMouseDown := Result.pnVolumeMouseDown;
    Result.Form.CenterOnParent;
    Result.Form.MinimizeNormalAnimated;
    Result.KOLForm1FormCreate( Result );

end;

