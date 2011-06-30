{
  Some tests for KOL. Comment/uncomment define directives below
  and compile in different test configurations. THAN SEE ONLY
  LINES WHICH REALLY ARE COMPILED (i.e. marked with blue dots
  on left side of IDE editor window) - this will help You learn
  how to do something in KOL.

  (C) by Kladov Vladimir, 2000
}

program TestKOL3;

uses
  windows,
  messages,
  MMSystem,
  err,
  KOL;

//{$DEFINE USE_RESOURCE}
{$DEFINE USE_APPBUTTON}
{$DEFINE TEST_FORM2}
{$DEFINE TEST_SHOWMODAL}
//{$DEFINE TEST_APPLETINVISIBLE}
//{$DEFINE CREATE_VISIBLE}
{$DEFINE TEST_CLICK}
//{$DEFINE TEST_ITEMS}
{$DEFINE TEST_RADIO}
//{$DEFINE TEST_MOUSE}
//{$DEFINE TEST_COLOR}
{$DEFINE TEST_FONT}
//{$DEFINE TEST_BRUSH}
// {$DEFINE TEST_PARENTFONTCOLOR}
//{$DEFINE TEST_DISABLED}
//{$DEFINE TEST_NOCAPTION}
//{$DEFINE TEST_NOBORDER}
//{$DEFINE TEST_NORESIZE}
//{$DEFINE TEST_ONTOP}
{$DEFINE TEST_CENTER}
{$DEFINE TEST_POSITION}
//{$DEFINE TEST_LIST}
//{$DEFINE TEST_STRLIST}
//{$DEFINE TEST_RECT}
//  {$DEFINE TEST_STRUTILS}
//{$DEFINE TEST_GROUP}
{$DEFINE TEST_SELECT}
{$DEFINE TEST_SELECTALL}
{$DEFINE TEST_KEYBD}
  {$DEFINE TEST_TABS}
//{$DEFINE TEST_TABS_EX}

{$DEFINE TEST_BITBTN}
{$DEFINE TEST_BITBTN_IMGLIST}
//{$DEFINE TEST_BITBTN_BMP}
//{$DEFINE TEST_BITBTN_REPEAT}
//{$DEFINE TEST_BITBTN_FIXED}
{$DEFINE TEST_BITBTN_FLAT}

{$DEFINE TEST_SPEEDBTN}
{$DEFINE TEST_OnTestMouseOver}

//{$DEFINE TEST_SPEEDBUTTON}
//{$DEFINE TEST_ALIGNTEXT}
//{$DEFINE TEST_ALIGNVERT}
{$DEFINE TEST_PAINT}
{$DEFINE TEST_CANVAS} // TEST_PAINT needed also
{$DEFINE TEST_GEOMETRIC_PEN}

{$DEFINE TEST_BITMAP} // Needed to test all bitmap operations below
{$DEFINE TEST_BMPPIXELFORMATCHANGE} // Set also to test scan lines in 256 colors mode
{$DEFINE TEST_BMPHEIGHT}
{$DEFINE TEST_BMPWIDTH}
{$DEFINE TEST_BMPDECREASE}
{$DEFINE TEST_BMPRESOURCE} // switch off also TEST_BMPMEM
//{$DEFINE TEST_BMPSTDRESOURCE}
//{$DEFINE TEST_BMPMEM}
{$DEFINE TEST_BMPCANVAS}
//{$DEFINE TEST_BMPDORMANT}
//{$DEFINE TEST_BMPSCANLINE}
{$DEFINE TEST_DRAWDDB}
//{$DEFINE TEST_STRETCHDRAW}
//{$DEFINE TEST_BMPTRANSPARENT}
{$DEFINE TEST_BMPROTATE}
{$DEFINE TEST_BMPFLIPVERT}
{$DEFINE TEST_BMPFLIPHORZ}
{$DEFINE TEST_BMPPIXELS}

{$DEFINE TEST_ICON}

//{$DEFINE TEST_MEDIAPLAYER} // When uncommented, application started a bit slowly...
//{$DEFINE TEST_CDAUDIO}
//{$DEFINE TEST_AVI}
//{$DEFINE TEST_PLAYSOUND} // test playing sounds from memory, resource, file, system event etc.
//{$DEFINE TEST_VOLUME}
//{$DEFINE TEST_DGVSPEED}

//{$DEFINE TEST_ORIENTATION} // use with test_3Dlabel only
//{$DEFINE TEST_3DLABEL}
//{$DEFINE TEST_DOUBLEBUF}
//{$DEFINE TEST_TRANSPARENT}
{$DEFINE TEST_GRADIENT}
//{$DEFINE TEST_GRADIENT_EX}

{$DEFINE TEST_TIMER}

{$DEFINE TEST_TRAYICON}
//{$DEFINE TEST_JUST_ONE} // also needed to test JustOneNotify below
//{$DEFINE TEST_JUST_ONE_NOTIFYANOTHERINSTANCE}
//{$DEFINE TEST_COMBO_ONDROP_ONCLOSE}
{$DEFINE TEST_COMBO_ONKEY}

{$DEFINE TEST_LISTBOX}
{$DEFINE TEST_DIRLIST}
{$DEFINE TEST_ADDDIRLIST} // TEST_DIRLIST also needed
{$DEFINE TEST_DIRCHANGE}

{$DEFINE TEST_MENU}
{$DEFINE TEST_POPUPMENU}
{$DEFINE TEST_AUTOPOPUP}
{$DEFINE TEST_MENUBITMAP}

{$DEFINE TEST_OPENSAVE} // TEST_MENU also needed
//{$DEFINE TEST_OPENDIR}// TEST_MENU also needed
//{$DEFINE TEST_QUICKSORT}

{------------- tests for common controls ----------------}
{$DEFINE TEST_LISTVIEW}
{$DEFINE TEST_LISTVIEW_IMGL}

  {$DEFINE TEST_PROGRESS}
  //{$DEFINE TEST_PROGRESS_COLORS}
  {$DEFINE TEST_PROGRESS_SMOOTH}

{$DEFINE TEST_TREEVIEW}
{$DEFINE TEST_TREEVIEW_IMGL}

{$DEFINE TEST_TOOLBAR}
//{$DEFINE TEST_TOOLBAR_CUSTOMBMP}
//{$DEFINE TEST_TOOLBER_NOTEXTLABELS}
//{$DEFINE TEST_TOOLBAR_HIGHLIGHT}
//{$DEFINE TEST_TOOLBAR_ENABLE}
{$DEFINE TEST_TOOLBAR_PRESS}
//{$DEFINE TEST_TOOLBAR_ROWS}
{$DEFINE TEST_TOOLBAR_TOOLTIPS}
{$DEFINE TEST_TOOLBAR_FLAT}
//{$DEFINE TEST_TOOLBAR_TEXTRIGHT}
//{$DEFINE TEST_TOOLBAR_INPANEL}
//{$DEFINE TEST_TOOLBAR_DROPDOWN}
{$DEFINE TEST_TOOLBAR_CHANGEIMG}

{$DEFINE TEST_STATUS}
{$DEFINE TEST_STATUS_N}

{--------------------------------------}
{$DEFINE TEST_ALIGN}
{$DEFINE TEST_PREVENTRESIZEFLICKS}

//{$DEFINE TEST_CLIPBOARD}


{------------------------------------------------------------------------------}
{$IFDEF TEST_BMPRESOURCE}
  {$DEFINE MENUBITMAPS_RES}
{$ENDIF}
{$IFDEF TEST_MENUBITMAP}
  {$DEFINE MENUBITMAPS_RES}
{$ENDIF}

{$IFDEF MENUBITMAPS_RES}
{$R MenuBitmaps.res}
{$ENDIF}

{$IFDEF TEST_BITBTN}
{$R BUTTON5.RES}
{$ENDIF}

{$IFDEF USE_RESOURCE}
  {$DEFINE RESOURCE_NEEDED}
{$ENDIF}

{$IFDEF TEST_TRAYICON}
  {$DEFINE RESOURCE_NEEDED}
{$ENDIF}
{$IFDEF RESOURCE_NEEDED}
{$R *.res}
{$ENDIF}

{$IFDEF TEST_PLAYSOUND}
{$R TSTWAV.RES}
{$ENDIF}

var NNN : Integer;
var W, P0, P1, P2, P3, B1, B2, BX, L1, L2, L2P, C1, C2,
    R1, R2, E1, E2, CB, PB, ProgressBar, TC : PControl;
    T : PTimer;
  //{$IFDEF TEST_LISTBOX}
    LB: PControl;
    {$IFDEF TEST_DIRLIST}
    {$IFNDEF TEST_ADDDIRLIST}
      DL : PDirList;
    {$ENDIF}
    {$ENDIF}
    {$IFDEF TEST_DIRCHANGE}
      DCN: PDirChange;
    {$ENDIF}
  //{$ENDIF}
  {$IFDEF TEST_LISTVIEW}
    LV: PControl;
  {$ENDIF}
  {$IFDEF TEST_TREEVIEW}
    TV: PControl;
  {$ENDIF}
  {$IFDEF TEST_TRAYICON}
    TrIc: PTrayIcon;
  {$ENDIF}
  {$IFDEF TEST_MENU}
    MainMenu: PMenu;
  {$ENDIF}
    ImgL: PImageList;
    Popup1: PMenu;
  //{$IFDEF TEST_TOOLBAR}
    TB: PControl;
    TBOptions: TToolbarOptions = [];
  //{$ENDIF}

{$IFDEF TEST_TOOLBAR_CUSTOMBMP}
  {$UNDEF TEST_TOOLBAR}
  {$DEFINE TEST_TB}
{$ENDIF}

{$IFDEF TEST_TOOLBAR}
  {$DEFINE TEST_TB}
{$ENDIF}

{$IFDEF TEST_TB}
  {$DEFINE LOAD_TBRES}
{$ENDIF}

{$IFDEF TEST_TREEVIEW_IMGL}
  {$DEFINE LOAD_TB_RES}
{$ENDIF}

{$IFDEF TEST_LISTVIEW_IMGL}
  {$DEFINE LOAD_TB_RES}
{$ENDIF}

{$IFDEF LOAD_TB_RES}
  {$R Toolbtn.res}
{$ENDIF}

type
  PMyObj = ^TMyObj;
  TMyObj = object( TObj ) // defined to simplify event assignment
  public
    procedure B1Click( Sender: PObj );
    procedure B2Click( Sender: PObj );
    procedure LVMouseUp( Sender: PControl; var MouseData: TMouseEventData );
    procedure LVMouseDown( Sender: PControl; var MouseData: TMouseEventData );
    procedure LVClick( Sender: PObj );
    procedure TBClick( Sender: PObj );
    procedure TBMouseDown( Sender: PControl; var MouseData: TMouseEventData );
    procedure TBDropDown( Sender: PObj );
    procedure ODSelChanged( Sender: POpenDirDialog; NewSel: PChar;
              var EnableOK: Integer; var Status: String );
    procedure CBDropDown( Sender: PObj );
    procedure CBCloseUp( Sender: PObj );
    procedure DirChanged( Sender: PDirChange; const Path: String );
    procedure TestMediaPlayer( Sender: PObj );
    procedure Played( Sender: PMediaPlayer; Reason: TMPNotifyValue );
    function BitBtn1Draw( Sender: PControl; State: Integer ): Boolean;
    function TestMouseOverB1( Sender: PControl ): Boolean;
    procedure CBOnKey( Sender: PControl; var Key: Char; Shift: DWORD );
    procedure LVChar( Sender: PControl; var Key: Char; Shift: DWORD );
  end;

var O: PMyObj;

procedure TMyObj.ODSelChanged( Sender: POpenDirDialog; NewSel: PChar;
              var EnableOK: Integer; var Status: String );
begin
  if StrLen( NewSel ) <= 3 then EnableOK := -1;
  Status := Status + '!';
end;

procedure Click1( Dummy : Pointer; Sender : PControl );
begin
  Dec( NNN );
  MsgBox( 'Hello! ' + Sender.Caption + ' ' + Int2Str( NNN ), MB_OK );
end;

procedure Click2( Dummy: Pointer; Sender: PControl );
  {$IFDEF TEST_LISTBOX}
  {$IFDEF TEST_ITEMS}
var I, J : Integer;
  {$ENDIF}
  {$ENDIF}
  {$IFDEF TEST_PROGRESS}
var    P: Integer;
  {$ENDIF}
  {$IFDEF TEST_STATUS_N}
var    K: Integer;
  {$ENDIF}
begin
  L2.Caption := L2.Caption + ' !';
  {$IFDEF TEST_PROGRESS}
  P := ProgressBar.Progress;
  if (P and 1) = 0 then
  begin
    if P >= 100 then
      Dec( P, 11 );
    Inc( P, 10 );
  end
     else
  begin
    if P <= 0 then
      Inc( P, 11 );
    Dec( P, 10 );
  end;
  ProgressBar.Progress := P;
  {$ENDIF}

  {$IFDEF TEST_RADIO}
  R2.SetRadioChecked;
  {$ENDIF}
  {$IFDEF TEST_ITEMS}
  E2.Items[ 2 ] := E2.Items[ 1 ] + ' Line2';
  //E2.Items[ 1 ] := '';
  {$IFDEF TEST_LISTBOX}
  LB.Add( 'Item' + Int2Str( LB.Count ) );
  J := 0;
  for I := 0 to LB.Count - 1 do
    if LB.ItemSelected[ I ] then
    begin
      J := I; break;
    end;
  LB.Items[ 2 ] := LB.Items[ J ] + E2.Items[ 1 ];
  {$ENDIF}
  CB.Add( 'Item' + Int2Str( CB.Count ) );
  {$ENDIF}

  {$IFDEF TEST_STATUS_N}
  K := W.StatusPanelCount;
  W.StatusText[ K ] := PChar( 'Status' + Int2Str( K ) + ': ' + Int2Str( W.StatusPanelRightX[ K - 1 ] ) );
  W.StatusPanelRightX[ 0 ] := 100;
  {$ELSE}
  {$IFDEF TEST_STATUS}
  if W.SimpleStatusText <> '' then
     W.RemoveStatus
  else
     W.SimpleStatusText := 'Status OK';
  {$ENDIF}
  {$ENDIF}
end;

procedure ClickChk( Dummy : Pointer; Sender : PControl );
begin
  if Sender.Checked then
     MsgOK( 'Checked: ' + Sender.Caption )
  else
     MsgOK( 'Unchecked: ' + Sender.Caption );
end;

procedure MouseDn1( Dummy : Pointer; Sender : PControl; var Mouse : TMouseEventData );
begin
  with Mouse do
  L2.Caption := 'X:' + Int2Str( X ) + ' Y:' + Int2Str( Y );
end;

procedure MouseMv1( Dummy : Pointer; Sender : PControl; var Mouse : TMouseEventData );
begin
  with Mouse do
  L2.Caption := 'X:' + Int2Str( X ) + ' Y:' + Int2Str( Y );
end;

procedure CloseClick( Dummy : Pointer; Sender : PControl );
begin
  PostQuitMessage( 0 );
end;

procedure Char1( Dummy: Pointer; Sender: PControl; var Key: Char; Shift: DWORD );
begin
  L1.Caption := Key;
  if Key in [ '0'..'9' ] then
     Key := #0;
end;

var Bmp1: PBitmap = nil;
    Ico1: PIcon   = nil;

procedure Experiment_Bitmap;
var Bmp: PBitmap;
  procedure TestBmpScanLine;
  var Y, X: Integer;
      SL: PByte;
      Ired, Igreen, Iblue: Integer;
  begin
    Ired := Bmp.DIBPalNearestEntry( clRed );
    Igreen := Bmp.DIBPalNearestEntry( clGreen );
    Iblue := Bmp.DIBPalNearestEntry( clBlue );
    for Y := 0 to Bmp.Height - 3 do
    begin
      SL := Bmp.ScanLine[ Y ];
      X := Y;
      PByte(Integer(SL) + X)^ := Ired;
      PByte(Integer(SL) + X + 1)^ := Igreen;
      PByte(Integer(SL) + X + 2)^ := Iblue;
    end;
  end;
begin
  Bmp := NewBitmap( 0, 0 );
  {$IFDEF TEST_BMPMEM}
  Bmp.BkColor := clRed;
  Bmp.Width := 30;
  Bmp.Height := 30;
  Bmp.Canvas.Brush.Color := clWhite;
  Bmp.Canvas.FrameRect( MakeRect( 10, 10, 20, 20 ) );
  Bmp.SaveToFile( 'tst0.bmp' );
  {$ELSE}
    Bmp.BkColor := clWindow;
    {$IFDEF TEST_BMPRESOURCE}
      {$IFDEF TEST_BMPSTDRESOURCE}
      Bmp.LoadFromResourceID( 0, OBM_ZOOM );
      {$ELSE}
      Bmp.LoadFromResourceName( hInstance, 'BITMAP1' );
      {$ENDIF}
    {$ELSE}
    Bmp.LoadFromFile( 'toolbar.bmp' );
    {$ENDIF}
    {$IFDEF TEST_BMPPIXELFORMATCHANGE}
    Bmp.SaveToFile( 'tst_1.bmp' );
    //Bmp.PixelFormat := pf15bit;
    //Bmp.SaveToFile( 'tst15bit.bmp' );
    Bmp.PixelFormat := pf8bit;
    {$ENDIF}
    {$IFDEF TEST_BMPROTATE}
    Bmp.SaveToFile( 'tst8bit.bmp' );
    //Bmp.Height := Bmp.Height + 2;
    Bmp.HandleType := bmDDB;
    //BitmapFormatChanged_PasUse := TRUE;
    Bmp.SaveToFile( 'tstH-2.bmp' );
    //BitmapFormatChanged_PasUse := FALSE;
    Bmp.RotateRight;
    Bmp.SaveToFile( 'tstrot.bmp' );
    //Bmp.RotateRight;
    //Bmp.RotateRight;
    //Bmp.RotateRight;
    {$ENDIF}
    {$IFDEF TEST_BMPPIXELS}
    Bmp.DIBPixels[ 0, 0 ] := clRed;
    Bmp.DIBPixels[ 1, 1 ] := clGreen;
    Bmp.DIBPixels[ 2, 2 ] := clYellow;
    Bmp.SaveToFile( 'tst16bit.bmp' );
    Bmp.DIBPixels[ 3, 3 ] := Bmp.DIBPixels[ 0, 0 ];
    Bmp.Pixels[ 4, 4 ] := Bmp.DIBPixels[ 1, 1 ];
    Bmp.Pixels[ 5, 5 ] := Bmp.Pixels[ 2, 2 ];
    Bmp.DIBPixels[ 6, 6 ] := Bmp.Pixels[ 0, 0 ];
    //Bmp.HandleType := bmDDB;
    Bmp.DIBPixels[ 7, 7 ] := Bmp.DIBPixels[ 1, 1 ];
    {$ENDIF}
    {$IFDEF TEST_BMPFLIPVERT}
    //Bmp.HandleType := bmDDB;
    Bmp.FlipVertical;
    {$ENDIF}
    {$IFDEF TEST_BMPFLIPHORZ}
    Bmp.FlipHorizontal;
    {$ENDIF}
    Bmp.SaveToFile( 'tst1.bmp' );
    {$IFDEF TEST_BMPSCANLINE}
    Bmp.PixelFormat := pf8bit;
    TestBmpScanLine;
    {$ENDIF}
    Bmp.SaveToFile( 'tst10.bmp' );
    {$IFDEF TEST_BMPWIDTH}
      {$IFDEF TEST_BMPDECREASE}
      Bmp.Width := 44;
      {$ELSE}
      Bmp.Width := 88;
      {$ENDIF}
    {$ENDIF}
    Bmp.SaveToFile( 'tst11.bmp' );
    {$IFDEF TEST_BMPHEIGHT}
      {$IFDEF TEST_BMPDECREASE}
      Bmp.Height := 11;
      {$ELSE}
      //Bmp.HandleType := bmDDB;
      Bmp.SaveToFile( 'tst12.bmp' );
      Bmp.Height := 44;
      {$ENDIF}
    Bmp.SaveToFile( 'tst13.bmp' );
    {$ENDIF}
    {$IFDEF TEST_BMPDORMANT}
    Bmp.Dormant;
    {$ENDIF}
    {$IFDEF TEST_BMPCANVAS}
    //Bmp.Canvas.Pen.PenWidth := 3;
    Bmp.Canvas.MoveTo( 3, 3 );
    Bmp.Canvas.LineTo( Bmp.Width div 2, Bmp.Height );
    {$ENDIF}
    {$IFDEF TEST_BMPPIXELFORMATCHANGE}
    //Bmp.PixelFormat := pf16bit;
    {$ENDIF}
    Bmp.SaveToFile( 'tst2.bmp' );
    {$IFDEF TEST_BMPCANVAS}
    Bmp.Canvas.Pen.Color := clBlue;
    Bmp.Canvas.LineTo( Bmp.Width, 3 );
    Bmp.RemoveCanvas;
    {$ENDIF}
  {$ENDIF}
  //Bmp1 := Bmp;
  Bmp1 := NewBitmap( 0, 0 );
  Bmp1.Assign( Bmp );
  Bmp.Free;
  {$IFDEF TEST_BMPPIXELFORMATCHANGE}
  //Bmp1.PixelFormat := pf24bit;
  {$ENDIF}
  Bmp1.SaveToFile( 'tst3.bmp' );
    {$IFDEF TEST_BMPDORMANT}
    Bmp1.Dormant;
    {$ELSE}
    Bmp1.Handle;
    Bmp1.SaveToFile( 'tst4.bmp' );
    //Bmp1.Dormant;
    {$ENDIF}
  {$IFDEF TEST_DRAWDDB}
  Bmp1.HandleType := bmDDB;
  {$ENDIF}
end;

procedure Experiment_Icon;
var Ico: PIcon;
begin
  Ico := NewIcon;
  Ico.LoadFromResourceName( hInstance, 'MAINICON', 0 );
  Ico.SaveToFile( 'test.ico' );
  Ico1 := NewIcon;
  Ico1.Handle := Ico.Handle;
  Ico.Free;
  {$IFDEF TEST_BITMAP}
  Bmp1.Handle := Ico1.Convert2Bitmap( clWhite );
  {$ENDIF}
end;

procedure TestPaintBitmap;
var TransColor: TColor;
begin
  {$IFDEF TEST_BMPMEM}
  TransColor := clRed;
  {$ELSE}
  TransColor := clBlack;
  {$ENDIF}
  if TransColor = 0 then;
  {$IFDEF TEST_STRETCHDRAW}
    {$IFNDEF TEST_BMPTRANSPARENT}
    Bmp1.SaveToFile( 'tst5.bmp' );
    Bmp1.StretchDraw( PB.Canvas.Handle, PB.ClientRect );
    {$ELSE}
    Bmp1.StretchDrawTransparent( PB.Canvas.Handle, PB.ClientRect, TransColor );
    {$ENDIF}
  {$ELSE}
    {$IFNDEF TEST_BMPTRANSPARENT}
    Bmp1.Draw( PB.Canvas.Handle, 10, 40 );
    {$ELSE}
    Bmp1.DrawTransparent( PB.Canvas.Handle, 10, 40, TransColor );
    {$ENDIF}
  {$ENDIF}
end;

procedure TestPaintIcon;
begin
  //Ico1.Draw( PB.Canvas.Handle, 20, 30 );
  Ico1.StretchDraw( PB.Canvas.Handle, MakeRect( 20, 30, 70, 80 ) );
end;

procedure TestPaint( Dummy: Pointer; Sender: PControl; DC: HDC );
var CR : TRect;
begin
  CR := Sender.ClientRect;
  Sender.Canvas.MoveTo( 1, 1 );
  Sender.Color := clBlue;
  Sender.Canvas.Brush.Color := clYellow;
  Sender.Canvas.FillRect( CR );
  {$IFDEF TEST_CANVAS}
  {$IFDEF TEST_GEOMETRIC_PEN}
  Sender.Canvas.Pen.GeometricPen := True;
  //Sender.Canvas.Pen.PenBrushStyle := bsBDiagonal; // interesting (must not supported)...
  {$ENDIF}
  Sender.Canvas.Pen.PenStyle := psInsideFrame;
  Sender.Canvas.Pen.Color := clGreen; //clHighlight; // OK - both work
  Sender.Canvas.Pen.PenWidth := 5;
  Sender.Canvas.LineTo( 59, 59 );
  Sender.Canvas.Chord( 0,0, 40,40, 0,0, 40, 40 );
  Sender.Canvas.CopyRect( MakeRect( 0, 0, 20, 20 ),
                          Sender.Canvas,
                          MakeRect( 20, 40, 40, 20 ) );
  Sender.Canvas.Ellipse( 0, 0, 60, 30 );
  Sender.Canvas.Brush.Color := clRed;
  Sender.Canvas.FrameRect( MakeRect( 10, 10, 50, 50 ) );
  Sender.Canvas.Pen.PenWidth := 1;
  Sender.Canvas.Pen.Color := clBlue;
  Sender.Canvas.Brush.Color := clAqua;
  Sender.Canvas.Polygon( [ MakePoint( 40, 40 ), MakePoint( 20, 10 ),
                            MakePoint( 15, 30 ), MakePoint( 40, 15 ),
                            MakePoint( 40, 40 ) ] );
  Sender.Canvas.Brush.BrushStyle := bsClear;
  Sender.Canvas.Font.Color := clFuchsia;
  Sender.Canvas.Font.FontStyle := [fsBold];
  Sender.Canvas.TextOut( 24, 24, 'xyz' );
  Sender.Canvas.Brush.BrushStyle := bsSolid;
  //Sender.Canvas.FloodFill( 20, 20, clGreen, fsBorder );
  {$ELSE}
  //Sender.PaintBackground( DC, @CR );
  {$ENDIF}
  {$IFDEF TEST_BITMAP}
  TestPaintBitmap;
  {$ENDIF}
  {$IFDEF TEST_ICON}
  TestPaintIcon;
  {$ENDIF}
end;

procedure Experiment_TList;
var L : PList;
begin
  L := NewList;
  L.Add( Pointer( 1234 ) );
  L.Insert( 0, Pointer( 5678 ) );
  L.Swap( 0, 1 );
  L.Items[ 0 ] := Pointer( 9000 );
  L.Delete( 0 );
  L.Add( Pointer( 777 ) );
  L.MoveItem( 1, 0 );
  L.Count := 1;
  L.Free;
end;

procedure Experiment_TRect;
var R : TRect;
    P : TPoint;
begin
  R := MakeRect( 0, 0, 100, 100 );
  P := MakePoint( 10, 10 );
  if PointInRect( P, R ) then ;
  if PtInRect( R, P ) then ;
end;

procedure Experiment_Strutils;
var S, Tmp : String;
begin
  S := Int2Hex( Hex2Int( '3A18' ), 5 );
  S := S + #13;
  S := S + Int2Ths( -153467 );
  S := S + #13;
  S := S + Int2Digs( -12345, 7 );
  S := S + #13;
  S := S + Num2Bytes( 1234560000.0 );
  S := S + #13;
  S := S + Int2Str( Str2Int( '-111292' ) );
  S := S + #13;
  Tmp := Trim( '    AAABBB   ' );
  DeleteTail( Tmp, 4 );
  S := S + '<' + Tmp + '>';
  S := S + #13;
  S := S + Int2Str( IndexOfCharsMin( S, '-0' ) );
  S := S + #13;
  S := S + Int2Str( IndexOfStr( S, 'AA' ) );
  S := S + #13;
  Tmp := 's1,s2,s3';
  S := S + Parse( Tmp, ',' ) + #13 + Parse( Tmp, ';' ) + #13 + Tmp;
  S := S + #13;
  if StrIn( 'aaA', ['Bbc', 'aAa', 'cCc' ] ) then
     S := S + 'aaA in [ Bbc, aAa, cCc ]';
  S := S + #13;
  if StrSatisfy( 'aaabcbcc', 'aa*bc*' ) then
     S := S + 'aaabcbcc satisfied to aa*bc*';
  MsgOK( S );
end;

procedure Experiment_StrList;
var SL, SL1: PStrList;
    FS: PStream;
begin
  SL := NewStrList;
  SL1 := NewStrList;
  SL1.Assign( SL );
  //SL1.LoadFromFile( 'tststrlist.txt' );
  SL.Text := '---'#13'+++';
  SL.MergeFromFile( 'tststrlist.txt' );
  SL.AddStrings( SL1 );
  //SL1.Assign( SL );
  MsgOK( SL.Items[ 0 ] + #13 + SL.Items[ 1 ] + #13 + Int2Str( SL.IndexOf( 'BBB' ) ) );
  SL.Add( 'aaa' );
  SL.Add( 'bbb' );
  SL.Items[ 1 ] := 'BBB';
  SL.Move( 1, 0 );
  SL.Insert( 1, 'ccc' );
  SL.Delete( 2 );
  FS := NewWriteFileStream( 'tststrlist.txt' );
  SL.SaveToStream( FS );
  FS.Free;
  //SL.Sort( False );
  SL.SaveToFile( 'tststrlist.txt' );
  //SL.AppendToFile( 'tststrlist.txt' );
  SL1.Assign( SL );
  SL.AddStrings( SL1 );
  SL.SaveToFile( 'tststrlist1.txt' );
  SL.Free;
  SL1.Free;
end;

procedure TestQuickSort;
const Size = 1000000;
type TIntArray = array[ 0..Size ] of Integer;
     PIntArray = ^TIntArray;
var Start: DWORD;
    A: PIntArray;
    I: Integer;
begin
  GetMem( A, Size * Sizeof( Integer ) );
  for I := 0 to Size - 1 do
    A[ I ] := Random( MaxInt );

  Start := GetTickCount;
  SortIntegerArray( Slice( A^, Size ) );

  MsgOK( Int2Str( Size ) + ' numbers sorted for ' + Int2Str( GetTickCount - Start ) +
         ' milliseconds.' );
  FreeMem( A );
end;

{$IFDEF TEST_TIMER}
var Time: Integer = 0;
{$ENDIF}
procedure TimerTick( Dummy: Pointer; Sender: PTimer );
begin
  {$IFDEF TEST_ORIENTATION}
  L2.Font.FontName := 'Arial';
  L2.Font.FontOrientation := L2.Font.FontOrientation - 100;
  {$ENDIF}
  {$IFDEF TEST_TIMER}
  L2.Caption := 'Counter ' + Int2Str( Time );
  W.Caption := L2.Caption;
  //L2.Invalidate;
  Inc( Time );
  {$ENDIF}
end;

procedure NotifyAnotherInstance( Dummy: PControl; const CmdLine: String );
begin
  L1.Caption := CmdLine;
end;

procedure TrayMouseMsg( Dummy: PControl; Sender: PTrayIcon; Mesg: WORD );
begin
  if Mesg = WM_LBUTTONDOWN then
     MsgOK( 'Hello! - Tray left mouse click.' );
end;

var OSDialog: POpenSaveDialog = nil;
    ODDialog: POpenDirDialog = nil;
procedure DoMenuItem( Dummy: PObj; Sender: PMenu; Item: Integer );
begin
  {$IFDEF TEST_TOOLBAR_CHANGEIMG}
  {$IFNDEF TEST_TOOLBAR_CUSTOMBMP}
  if Item = 2 then
  begin
    if TB.TBButtonImage[ 100 ] = STD_DELETE then
    begin
       TB.TBButtonImage[ 100 ] := STD_FILENEW;
       {$IFNDEF TEST_TOOLBER_NOTEXTLABELS}
       if TB.TBButtonText[ 100 ] <> 'New' then
         TB.TBButtonText[ 100 ] := 'New';
       {$ENDIF}
       //TB.TBButtonWidth[ 100 ] := TB.TBButtonWidth[ 100 ] + 1; // tested
    end
    else
    begin
       TB.TBButtonImage[ 100 ] := STD_DELETE;
       {$IFNDEF TEST_TOOLBER_NOTEXTLABELS}
       TB.TBButtonText[ 100 ] := 'Delete';
       {$ENDIF}
    end;
  end;
  {$ENDIF}
  {$ENDIF}

  {$IFDEF TEST_OPENSAVE}
  if Item = 8 then
  begin
    if OSDialog = nil then
      OSDialog := NewOpenSaveDialog( 'Test open save dialog', '', [] );
    OsDialog.Filter:='Record Files (*.rec)|*.rec';
    OsDialog.InitialDir:=GetStartDir;
    OSDialog.DefExtension := 'rec';
    OSDialog.OpenDialog := True;
    if OSDialog.Execute then
    begin
      MsgOK( 'Open dialog results: ' + OSDialog.Filename );
    end;
    Exit;
  end;
  if Item = 9 then
  begin
    if OSDialog = nil then
      OSDialog := NewOpenSaveDialog( 'Test open save dialog', '', [] );
    OsDialog.Filter:='Record Files (*.rec)|*.rec';
    OsDialog.InitialDir:=GetStartDir;
    OSDialog.DefExtension := 'rec';
    OSDialog.OpenDialog := False;
    if OSDialog.Execute then
    begin
      MsgOK( 'Save dialog results: ' + OSDialog.Filename );
    end;
    Exit;
  end;
  {$ENDIF}
  {$IFDEF TEST_OPENDIR}
  if Item = 10 then
  begin
    if ODDialog = nil then
    begin
      ODDialog := NewOpenDirDialog( 'Test open directory dialog',
               [ odOnlySystemDirs, odStatusText] );
      ODDialog.InitialPath := 'C:\';
      ODDialog.CenterOnScreen := True;
      ODDialog.OnSelChanged := O.ODSelChanged;
    end;
    if ODDialog.Execute then
    begin
      MsgOK( 'Directory dialog results: ' + ODDialog.Path );
    end;
    Exit;
  end;
  {$ENDIF}
  MsgOK( 'MenuItem' + Int2Str( Item ) + ': ' + Sender.ItemText[ Item ] );
  if Item = 1 then
  begin
    Sender.ItemText[ 1 ] := Sender.ItemText[ 1 ] + ' !';
    Sender.ItemEnabled[ 2 ] := not Sender.ItemEnabled[ 2 ];
  end;
  if Item = 3 then
  if Sender.Count > 4 then
    Sender.ItemVisible[ 4 ] := not Sender.ItemVisible[ 4 ];
  if Item = 5 then
    Sender.ItemChecked[ 2 ] := not Sender.ItemChecked[ 2 ];
end;

procedure DoL2MouseUp( Dummy: PObj; Sender : PControl; var Mouse : TMouseEventData );
var P: TPoint;
begin
  if Mouse.Button = mbRight then
  begin
    GetCursorPos( P );
    Popup1.Popup( P.X, P.Y )
  end;
end;

procedure TMyObj.DirChanged( Sender: PDirChange; const Path: String );
//var DL: PDirList;
//    IL: Integer;
begin
  //LB.Visible := False;
  LB.Clear;
  {
  DL := NewDirListEx( GetStartDir, '^Copy*.*;*.pas;*.inc', FILE_ATTRIBUTE_NORMAL );
  DL.Sort( [ sdrByExt ] );
  for IL := 0 to DL.Count - 1 do
    LB.Add( DL.Names[ IL ] );
  DL.Free;
  }
  LB.AddDirList( GetStartDir + '*.pas', DDL_ARCHIVE );
  LB.AddDirList( GetStartDir + '*.inc', DDL_ARCHIVE );
  //LB.Visible := True;
end;

procedure CreateTB( AParent: PControl );
begin
  {$IFDEF TEST_TB}
  {$IFDEF TEST_TOOLBAR_TEXTRIGHT}
  TBOptions := TBOptions + [ tboTextRight ];
  {$ENDIF}
  {$IFDEF TEST_TOOLBAR_FLAT}
  TBOptions := TBOptions + [ tboFlat ];
  {$ENDIF}
  {$IFDEF TEST_GRADIENT}
  TBOptions := TBOptions + [ tboTransparent ]; // - [ tboFlat];
  {$ENDIF}
  {$IFDEF TEST_TOOLBAR_ROWS}
  TBOptions := TBOptions + [ tboWrapable ];
  {$ENDIF}
  {$ENDIF}

  {$IFDEF TEST_TOOLBAR}
  TB := NewToolbar( AParent, caTop, TBOptions + [ tboTextRight{tboNoDivider} ], HBitmap(-1), [
     {$IFDEF TEST_TOOLBER_NOTEXTLABELS}
     ' ', '-',
     {$IFDEF TEST_TOOLBAR_DROPDOWN} '^', {$ELSE} ' ', {$ENDIF}
     ' ',
     {$ELSE}
     'New', '-',
     {$IFDEF TEST_TOOLBAR_DROPDOWN} '^Open', {$ELSE} 'Open', {$ENDIF}
     'Save',
     {$ENDIF}
     '' ], [ STD_FILENEW, -1, STD_FILEOPEN, STD_FILESAVE ] );
  TB.Tag := Integer( PChar( 'TB' ) );
  {$ELSE}
  {$IFDEF TEST_TOOLBAR_CUSTOMBMP}
  TB := NewToolbar( AParent, caTop, TBOptions, CreateMappedBitmap( hInstance, 111, 0, nil, 0 ), [
     {$IFDEF TEST_TOOLBER_NOTEXTLABELS}
     ' ', '-',
     {$IFDEF TEST_TOOLBAR_DROPDOWN} '^ ', {$ELSE} ' ', {$ENDIF}
     ' ',
     {$ELSE}
     'New', '-',
     {$IFDEF TEST_TOOLBAR_DROPDOWN} '^Open', {$ELSE} 'Open', {$ENDIF}
     'Save',
     {$ENDIF}
     '' ], [ 0, -1, 1, 2 ] );
  TB.Tag := PChar( 'TB' );
  {$ENDIF}
  {$ENDIF}

  {$IFDEF TEST_TB}
    {$IFNDEF TEST_GRADIENT}
    {$IFNDEF TEST_NORESIZE}
    TB.DoubleBuffered := True;
    {$ENDIF}
    {$ENDIF}

    {$IFDEF TEST_TOOLBAR_TOOLTIPS}
    TB.TBSetTooltips( TB.TBIndex2Item( 0 ), [ 'New', 'Open', 'Save' ] );
    {$ENDIF}
    {$IFDEF TEST_CLICK}
    TB.OnClick := O.TBClick;
    {$ENDIF}
    {$IFDEF TEST_MOUSE}
    //TB.OnMouseDown := O.TBMouseDown; // to test only - worked
    {$ENDIF}

    {$IFDEF TEST_TOOLBAR_DROPDOWN}
    TB.OnTBDropDown := O.TBDropDown;
    {$ENDIF}
  {$ENDIF}

end;

{$STACKFRAMES ON}
  // This directive needed to test JustOneNotify (without it due to bug
  // in Delphi compiler incorrect code is generated).

procedure TestObjs;
  {$IFDEF TEST_LISTBOX}
  {$IFDEF TEST_DIRLIST}
  {$IFNDEF TEST_ADDDIRLIST}
  var IL: Integer;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$IFDEF TEST_BITBTN}
  var bbIL: PImageList;
      BitBtnImg: THandle;
  {$ENDIF}
  {$IFDEF TEST_TREEVIEW}
  Node1, Node2: Integer;
  {$ENDIF}
begin

  //UseErrorMessageBox;

{$IFDEF USE_APPBUTTON}
  Applet := NewApplet( 'TstApp' );
  Applet.Tag := Integer( PChar( 'Applet' ) );
  {$IFDEF TEST_APPLETINVISIBLE}
  Applet.Visible := False;
  {$ENDIF}
  {$IFNDEF RESOURCE_NEEDED}
  Applet.Icon := THandle(-1);
  {$ENDIF}
{$ENDIF}

  {$IFDEF TEST_LIST}
  Experiment_TList;
  {$ENDIF}

  {$IFDEF TEST_RECT}
  Experiment_TRect;
  {$ENDIF}

  {$IFDEF TEST_STRUTILS}
  Experiment_Strutils;
  {$ENDIF}

  W := NewForm( Applet, 'TestKOL3' ); //.SetSize( 100, 100 );
  {$IFNDEF USE_APPBUTTON}
  {$IFNDEF RESOURCE_NEEDED}
  W.Icon := THandle(-1);
  {$ENDIF}
  {$ENDIF}

  W.Tag := Integer( PChar( 'W' ) );
  {$IFDEF TEST_PREVENTRESIZEFLICKS}
  W.PreventResizeFlicks;
  {$ENDIF}
  {$IFDEF CREATE_VISIBLE}
  W.CreateVisible := True;
  W.CreateWindow;
  {$ENDIF}

  //W.Font; // call to make independant from system fonts installed

  {$IFDEF TEST_JUST_ONE}
    {$IFDEF TEST_JUST_ONE_NOTIFYANOTHERINSTANCE}
  if JustOneNotify( W, 'Test JustOne instance of KOL application',
                    TOnAnotherInstance( MakeMethod( nil, @NotifyAnotherInstance ) ) ) then
    {$ELSE}
  if JustOne( W, 'Test JustOne instance of KOL application' ) then
    {$ENDIF}
  BEGIN
  {$ENDIF}

  {$IFDEF TEST_DOUBLEBUF}
  W.DoubleBuffered := True;
  {$ENDIF}

  {$IFDEF TEST_TRANSPARENT}
  W.Transparent := True;
  {$ENDIF}

  {$IFDEF TEST_NOCAPTION}
  W.HasCaption := False;
  {$ENDIF}

  {$IFDEF TEST_NOBORDER}
  W.HasBorder := False;
  W.Margin := 0;
  {$ENDIF}

  {$IFDEF TEST_ONTOP}
  W.StayOnTop := True;
  {$ENDIF}

  {$IFDEF TEST_NORESIZE}
  W.CanResize := False;
  {$ENDIF}

  {$IFDEF TEST_PARENTFONTCOLOR}
  W.Font.Color := clRed; //clHighlight;
  W.Font.FontStyle := [ fsItalic ];
  {$ENDIF}

  {$IFDEF TEST_BRUSH}
  W.Brush.Color := clAqua;
  {$ENDIF}

  {$IFDEF TEST_TABS_EX}
  W.TabulateEx;
  {$ENDIF}
  {$IFDEF TEST_TABS}
  W.Tabulate;
  {$ENDIF}

  {$IFDEF TEST_MENU}
  MainMenu := NewMenu( W, 0, [ 'MenuItem&1', '(', 'SubItem11'#9'Ctrl+1', '-SubItem12'#9'Ctrl+2', '-', '&SubItem13', ')',
                   'MenuItem&2', '(', '+!SubItem21', '-!SubItem22', ')',
                   '&File', '(', '&Open', '&Save', '-', 'Select &Directory', ')' ],
           TOnMenuItem( MakeMethod( nil, @DoMenuItem ) ) );
  MainMenu.ItemAccelerator[ 1 ] := MakeAccelerator( FCONTROL or FVIRTKEY, Word('1') );
  MainMenu.ItemAccelerator[ 2 ] := MakeAccelerator( FCONTROL or FVIRTKEY, Word('2') );
  W.SupportMnemonics;
  {$IFDEF TEST_MENUBITMAP}
  MainMenu.ItemBitmap[ 1 ] := LoadBitmap( hInstance, 'BITMAP1' );
  MainMenu.ItemBitmap[ 2 ] := LoadBitmap( hInstance, 'BITMAP2' );
  {$ENDIF}
  {$ENDIF}

  {$IFNDEF TEST_TOOLBAR_INPANEL}
  CreateTB( W );
  {$IFDEF TEST_ALIGN}
  TB.SetAlign( caTop );
  {$ENDIF}
  {$ENDIF}

  BX := NewButton( TB, 'X' ).SetSize( 18, 0 ).Shift( 280, 0 ); //.ResizeParentRight;
  BX.Tag := Integer( PChar( 'BX' ) );
  {$IFDEF TEST_ALIGN}
    BX.SetAlign ( caRight );
  {$ENDIF}
  BX.LikeSpeedButton;

  TC := NewTabcontrol( W, [ 'Page1', 'Page2', 'Page3' ],
                       [ {tcoVertical,} tcoFocusTabs ], nil, 0 ).Placedown
        .SetSize( 300, 270 ).ResizeParent;
    {$IFDEF TEST_ALIGN}
       TC.SetAlign( caClient );
    {$ENDIF}

  //TC.TC_Items[ 0 ] := 'kjdgfvkdfgbhvdlfjkvnlfdvnelvienv';

  {$IFDEF TEST_GRADIENT_EX}
  P0 := NewGradientPanelEx( TC.Pages[ 0 ], clYellow, clAqua, gsHorizontal, glLeft ).PlaceDown;
  P0.Tag := PChar( 'GradientEx' );
  P0.Caption := 'GradientEx';
  P0.Transparent := True;
  {$ELSE}
  {$IFDEF TEST_GRADIENT}
  P0 := NewGradientPanel( TC.Pages[ 0 ], clYellow, clAqua ).PlaceDown;
  P0.Tag := Integer( PChar( 'Gradient' ) );
  P0.Caption := 'Gradient';
  P0.Transparent := True;
  //P0.DoubleBuffered := False;
  {$ELSE}
  P0 := NewPanel( TC.Pages[ 0 ], esNone ).PlaceDown;
  P0.Tag := Integer( PChar( 'P0' ) );
  {$ENDIF}
  {$ENDIF}
  {$IFDEF TEST_TOOLBAR_INPANEL}
  CreateTB( P0 );
    {$IFDEF TEST_ALIGN}
    TB.SetAlign( caTop );
    {$ENDIF}
  {$ENDIF}
  {$IFDEF TEST_ALIGN}
    P0.SetAlign( caClient );
  {$ENDIF}

  P1 := NewPanel( P0, esRaised ).PlaceDown;
  P1.Tag := Integer( PChar( 'P1' ) );

  L1 := NewLabel {NewWordWrapLabel}( P1, 'Label1' ).SetSize( 90, 70 );
  L1.Tag := Integer( PChar( 'L1' ) );
  L1.VerticalAlign := vaBottom;

  {$IFDEF TEST_BITBTN}
  BitBtnImg := 0; bbIL := nil;
  if BitBtnImg = 0 then; // just to stop warnings
  if bbIL = nil then;

  {$IFDEF TEST_BITBTN_IMGLIST}
  bbIL := NewImageList( W );
  bbIL.ImgWidth := 40;
  bbIL.ImgHeight := 40;
  bbIL.LoadBitmap( 'BUTTON5', $806080 );
  //MsgOK( Int2Str( bbIL.Count ) );
  BitBtnImg := bbIL.Handle;
  B1 := NewBitBtn( P1, 'Button1', [ bboImageList, bboNoBorder, bboNoCaption
  {$IFDEF TEST_BITBTN_FIXED}
  , bboFixed
  {$ENDIF}
  ], glyphLeft,
    BitBtnImg, 0 or (5 shl 16) ).PlaceUnder.SetSize( 40, 40 );
  //B1.Enabled := False; // - to test
  {$ELSE}
  {$IFDEF TEST_BITBTN_BMP}
  BitBtnImg := LoadBitmap( hInstance, 'BUTTON5' );
               //LoadImage( hInstance, 'BUTTON5', IMAGE_BITMAP, 0, 0, 0 );

  B1 := NewBitBtn( P1, 'Button1', [ bboNoBorder
  {$IFDEF TEST_BITBTN_FIXED}
  , bboFixed
  {$ENDIF}
  ], glyphLeft,
    BitBtnImg, 0 ).PlaceUnder.SetSize( 100, 32 );
  {$ELSE}
  B1 := NewBitBtn( P1, 'Button1', [
  {$IFDEF TEST_BITBTN_FIXED}
  , bboFixed
  {$ENDIF}
  ], glyphLeft,
    0, 0 ).PlaceUnder.SetSize( 100, 32 );

  B1.OnBitBtnDraw := O.BitBtn1Draw;
  // Do not uncomment it - it is not compatible with current version
  // of graphics.inc (will be provided later)

  {$ENDIF}
  {$ENDIF}

  //B1.Color := clGreen;
  //B1.Transparent := False;
  {$IFDEF TEST_BITBTN_REPEAT}
  B1.RepeatInterval := 150;
  {$ENDIF}

  {$ELSE}
  B1 := NewButton( P1, 'Button1' ).PlaceUnder.SetSize( 100, 32 );
  {$ENDIF}
  B1.Tag := Integer( PChar( 'B1' ) );
  {$IFDEF TEST_SPEEDBTN}
  B1.LikeSpeedButton;
  {$ENDIF}
  {$IFDEF TEST_BITBTN_FLAT}
  B1.Flat := True;
  {$ENDIF}
  {$IFDEF TEST_OnTestMouseOver}
  B1.OnTestMouseOver := O.TestMouseOverB1;
  {$ENDIF}


  C1 := NewCheckbox( P1, 'Checkbox1' ).PlaceUnder.SetSize( 110, 0 );
  C1.Tag := Integer( PChar( 'C1' ) );

  C2 := NewCheckbox( P1, 'Checkbox2' ).PlaceUnder.SetSize( 110, 0 );
  C2.Tag := Integer( PChar( 'C2' ) );
  C2.Checked := True;

  C2.ResizeParent;

  P1.ResizeParent;

  {$IFDEF TEST_GROUP}
  P2 := NewGroupbox( P0, 'Group1' ).PlaceRight; //PlaceDown; //.AlignLeft( B2 );
  P2.tag := PChar( 'Group1 (P2)' );
  {$ELSE}
  P2 := NewPanel( P0, esLowered ).PlaceRight; //Under; //.AlignLeft( B2 );
  P2.Tag := Integer( PChar( 'P2' ) );
  {$ENDIF}

  B2 := NewButton( TC.Pages[ 2 ], 'Button2' ).PlaceRight.SetSize( 0, 33 );
  B2.Tag := Integer( PChar( 'B2' ) );
  {$IFDEF TEST_SPEEDBUTTON}
  B2.Tabstop := False;
  {$ENDIF}

  //L2 := NewWordWrapLabel( W, 'Label2' ).SetSize( 100, 0 ).PlaceUnder.AlignLeft( B2 );
  {$IFDEF TEST_3DLABEL}
  L2 := NewLabelEffect( P0, 'LabelEffect', 2 ).SetSize( 150, 150 );
  L2.Tag := PChar( 'LabelEffect' );
  L2P := L2;
  L2.DoubleBuffered := True;
  //L2.Transparent := True;
  //P0.DoubleBuffered := True;
  //L2.Transparent := False; // uncomment to get cyan background
  L2.Font.FontHeight := 28;
  L2.Font.FontName := 'Arial';
  L2.Font.FontStyle := [fsBold];
  L2.Font.FontOrientation := 300;
  //L2.Font.Color := ColorsMix( clRed, clBtnFace );
  L2.Font.Color := clGreen; //Aqua;
  //L2.Font.Color := clYellow;
  L2.Ctl3D := True;
  L2.Brush.Color := ColorsMix( clAqua, cl3DLight );
  {$ELSE}
  L2P := NewPanel( P0, esLowered ).PlaceUnder{.AlignLeft( B2 )}.ResizeParentRight;;
  L2P.Tag := Integer( PChar( 'L2P' ) );
  L2 := NewLabel( L2P, 'Label2' ).SetSize( 150, 0 ).ResizeParent;
  L2.Tag := Integer( PChar( 'L2' ) );
  {$ENDIF}
  L2P.PlaceUnder.{AlignLeft( B2 ).}ResizeParentRight;

  {$IFDEF TEST_POPUPMENU}
  {$IFNDEF TEST_MENU}
  MainMenu :=
  NewMenu( W, 0, [ '' ], nil ); // create dummy menu object to provide next one to be popup menu
  {$ENDIF}
  Popup1 := NewMenu( W, 0, [ 'Popup0', 'Popup1', '-', 'Popup2', '+Popup3', '-', 'Popup4', 'Popup5', '' ],
           TOnMenuItem( MakeMethod( nil, @DoMenuItem ) ) );
  Popup1.ItemAccelerator[ 3 ] := MakeAccelerator( FCONTROL or FVIRTKEY, WORD( '3' ) );
  L2.OnMouseUp := TOnMouse( MakeMethod( nil, @DoL2MouseUp ) );
  {$ENDIF}

  R1 := NewRadiobox( P2, 'Radiobox1' ).SetSize( 104, 0 ).PlaceDown;
  R1.Tag := Integer( PChar( 'R1' ) );

  R2 := NewRadiobox( P2, 'Radiobox2' ).SetSize( 104, 0 )
        .PlaceUnder.ResizeParent;
  R2.Tag := Integer( PChar( 'R2' ) );

  P2.ResizeParent;

  R2.SetRadioChecked;

  P3 := NewPanel( P0, esNone ).SetSize( 0, 10 );
  P3.Tag := Integer( PChar( 'P3' ) );
  P3.Top := P0.Height;

  E1 := NewEditbox( P0, [ ] ).PlaceDown.Shift( 0, 10 ).ResizeParent;
  E1.Tag := Integer( PChar( 'E1' ) );
  E1.Text := 'Edit1';
  {$IFDEF TEST_TRANSPARENT}
    {$DEFINE ED_TRANSPARENT}
  {$ENDIF}
  {$IFDEF TEST_GRADIENT}
    {$DEFINE ED_TRANSPARENT}
  {$ENDIF}
  {$IFDEF TEST_GRADIENT_EX}
    {$DEFINE ED_TRANSPARENT}
  {$ENDIF}
  {$IFDEF ED_TRANSPARENT}
  E1.Ed_Transparent := True;
  {$ENDIF}

  P0.ResizeParent;

  CB := NewCombobox( TC.Pages[ 1 ], [ {coReadOnly} ] )
        .PlaceDown;
  CB.Tag := Integer( PChar( 'CB' ) );
  with CB^ do
  begin
    Add( 'aaa' );
    Add( 'bbb' );
    Add( 'ccc' );
    Add( 'ddd' );
  end;
  {$IFDEF TEST_COMBO_ONDROP_ONCLOSE}
  CB.OnDropDown := O.CBDropDown;
  CB.OnCloseUp := O.CBCloseUp;
  {$ENDIF}
  {$IFDEF TEST_COMBO_ONKEY}
  CB.OnChar := O.CBOnKey;
  {$ENDIF}

  E2 := NewEditBox( TC.Pages[ 1 ], [ eoMultiline, eoNoHScroll, eoNoHideSel ] )
        .PlaceDown.SetSize( 0, 100 ).Shift( 0, 6 );
  E2.Tag := Integer( PChar( 'E2' ) );
  //E2.LookTabFirst := True;
  E2.Text := 'Edit2';
  {$IFDEF TEST_GRADIENT}
  //////-----------------E2.Transparent := False;
  {$ENDIF}

  {$IFDEF TEST_SELECT}
  E2.SelStart := 1;
  E2.SelLength := E2.SelLength + 3;
  //if E2.ItemSelected[ 2 ] then
  //  MsgOK( 'Edit2 - select OK' );
  {$ENDIF}
  {$IFDEF TEST_SELECTALL}
  E2.SelectAll;
  E2.SelLength := 0;
  {$ENDIF}

  {$IFDEF TEST_LISTBOX}
  LB := NewListbox( TC.Pages[ 1 ], [ loSort ] ).PlaceDown.SetSize( 0, 100 );
  LB.Tag := Integer( PChar( 'LB' ) );
  LB.ResizeParentBottom;
  {$IFDEF TEST_GRADIENT}
  //LB.Transparent := False;
  //LB.DoubleBuffered := False;
  {$ENDIF}
  {$IFDEF TEST_DIRLIST}
  {$IFDEF TEST_ADDDIRLIST}
  LB.AddDirList( GetStartDir + '*.pas', DDL_ARCHIVE );
  LB.AddDirList( GetStartDir + '*.inc', DDL_ARCHIVE );
  {$ELSE}
  DL := NewDirListEx( GetStartDir, '^Copy*.*;*.pas;*.inc', FILE_ATTRIBUTE_NORMAL );
  DL.Sort( [ sdrByExt ] );
  for IL := 0 to DL.Count - 1 do
    LB.Add( DL.Names[ IL ] );
  DL.Free;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$IFDEF TEST_DIRCHANGE}
  DCN := NewDirChangeNotifier( GetStartDir, [ ], True, O.DirChanged );
  {$ENDIF}

  {$IFDEF LOAD_TBRES}
      ImgL := NewImageList( W );
      ImgL.ImgWidth := 22;
      ImgL.ImgHeight := 22;
      ImgL.LoadBitmap( PChar( 111 ), $c0c0c0 );
      ImgL.Overlay[ 1 ] := 3;
      ImgL.Overlay[ 7 ] := 4;
    {$ELSE}
      ImgL := nil;
  {$ENDIF}

  {$IFDEF TEST_LISTVIEW}
  LV := NewListView( TC.Pages[ 2 ],
                        //lvsIcon, [lvoGridLines, lvoButton],
                        //lvsDetail, [lvoGridLines],
                        //lvsDetail, [lvoRowSelect,lvoTrackSelect],
                        //lvsDetail, [lvoMultiselect],
                        //lvsDetail, [lvoEditLabel,lvoHideSel],
                        lvsDetailNoHeader, [lvoEditLabel,lvoMultiselect],
                        //lvsDetail, [lvoCheckBoxes,lvoFlatsb],
                        ImgL, nil, ImgL ).PlaceDown.SetSize( 0, 100 );
  LV.Tag := Integer( PChar( 'LV' ) );
  LV.ResizeParent;
  LV.LVColAdd( 'Col0', taLeft, 70 );
  LV.LVColAdd( 'Col1', taLeft, 70 );
  LV.LVColAdd( 'Col2', taLeft, 70 );
  LV.LVAdd( 'I0', 0, [ ], 0, 0, 0 );
  //LV.LVSetItem( 0, 1, 'I0_C1', -3, [ ], 0, 0, 0 ); // works only under Win2K :(
  LV.LVItems[ 0, 1 ] := 'I0_C1';
  LV.LVAdd( 'I1', 0, [ ], 0, 7, 0 );
  LV.LVInsert( 1, 'I2', 0, [ ], 0, 0, 0 );
  //MsgOK( LV.LVItems[ 0, 1 ] ); //+++ tested, OK

  LV.LVColDelete( 1 );
  LV.LVColInsert( 1, 'Col3', taLeft, 70 );

  LV.LVItems[ 1, 1 ] := 'I1_C1';
  //LV.OnMouseDown := O.LVMouseDown;
  //LV.OnMouseUp := O.LVMouseUp;
  //LV.OnClick := O.LVClick;
  LV.LVTextColor := clFuchsia;
  LV.LVBkColor := ColorsMix( clLime, clSilver );
  LV.LVTextBkColor := ColorsMix( clAqua, clSilver );
  LV.LVSelectAll;
  //LV.OnChar := O.LVChar;
  {$IFDEF TEST_LISTVIEW_IMGL}
    //
  {$ENDIF}
  {$IFDEF TEST_GRADIENT}
  //////-------------LV.Transparent := False;
  //////-------------LV.DoubleBuffered := False;
  {$ENDIF}
  {$ENDIF}

  PB := NewPaintBox( TC.Pages[ 2 ] ).PlaceRight.SetSize( 100, 100 ).ResizeParent;
  PB.Tag := Integer( PChar( 'PaintBox' ) );
  PB.Caption := 'Paintbox';
  {$IFDEF TEST_PAINT}
    {$DEFINE TEST_ONPAINT}
  {$ENDIF}
  {$IFDEF TEST_BITMAP}
    {$DEFINE TEST_ONPAINT}
  {$ENDIF}
  {$IFDEF TEST_ICON}
    {$DEFINE TEST_ONPAINT}
  {$ENDIF}
  {$IFDEF TEST_ONPAINT}
  PB.OnPaint := TOnPaint( MakeMethod( nil, @TestPaint ) );
  {$ENDIF}

  //TC := NewTabControl( W, [ 'Tabsheet1', 'Tabsheet2' ] ).PlaceDown.ResizeParent;

  {$IFDEF TEST_PROGRESS_SMOOTH}
  Progressbar := NewProgressBarEx( TC.Pages[ 2 ], [ pboSmooth ] ).PlaceDown.SetSize( 282, 0 ).ResizeParent;
  Progressbar.Tag := Integer( PChar( 'Progressbar' ) );
  {$ELSE}
  ProgressBar := NewProgressBar( TC.Pages[ 2 ] ).PlaceDown.SetSize( 282, 0 ).ResizeParent;
  {$ENDIF}
  {$IFDEF TEST_PROGRESS_COLORS}
  ProgressBar.ProgressColor := clRed;
  ProgressBar.ProgressBkColor := clLime;
  {$ENDIF}

  {$IFDEF TEST_TREEVIEW}
  TV := NewTreeView( TC.Pages[ 2 ], [ tvoLinesRoot ], ImgL, ImgL ).PlaceDown.SetSize( 280, 90 );
  {$IFDEF TEST_ALIGN}
    TV.SetAlign( caBottom );
    NewSplitter( TC.Pages[ 2 ], 0, 0 ).SetAlign( caBottom );
  {$ENDIF}
  Node1 := TV.TVInsert( TVI_ROOT, 0, 'Alpha' );
           //TV.TVItemStateImg[ Node1 ] := 3;
           TV.TVItemOverlay[ Node1 ] := 1;
  Node2 := TV.TVInsert( Node1, TVI_LAST, 'Alph-1' );
           TV.TVInsert( Node1, TVI_LAST, 'Alph-2' );
           TV.TVInsert( Node1, TVI_FIRST, 'Alph-0' );
           TV.TVInsert( Node2, TVI_LAST, 'Alph-1-A' );
           TV.TVInsert( Node2, TVI_LAST, 'Alph-1-B' );
  Node2 := TV.TVInsert( TVI_ROOT, TVI_LAST, 'Betha' );
           TV.TVInsert( Node2, 0, 'Beth-1' );
           TV.TVInsert( Node2, 0, 'Beth-2' );
  TV.TVExpand( Node1, TVE_EXPAND );
  TV.TVExpand( Node2, TVE_EXPAND );
  TV.TVItemVisible[ TV.TVRoot ] := True;
  TV.TVSelected := TV.TVItemChild[ TV.TVRoot ];
  //TV.TVDelete( TV.TVItemNext[ TV.TVSelected ] );
  {$ENDIF}

  {$IFDEF TEST_STATUS_N}
  W.StatusText[ 0 ] := 'Status0';
  {$ELSE}
  {$IFDEF TEST_STATUS}
  W.SimpleStatusText := 'Status sample';
  {$ENDIF}
  {$ENDIF}

  {$IFDEF TEST_ALIGNTEXT}
  B1.TextAlign := taRight; //Succ( Succ( B1.TextAlign ) ); // taCenter;
  //CB.TextAlign := taRight; // nothing must do
  L2.TextAlign := taCenter;
  {$ENDIF}

  {$IFDEF TEST_ALIGNVERT}
  B2.VerticalAlign := vaBottom;
  {$ENDIF}

  {$IFDEF TEST_DISABLED}
  B1.Enabled := False;
  L2.Enabled := False;
  C1.Enabled := False;
  C2.Enabled := False;
  E1.Enabled := False;
  {$ENDIF}

  {$IFDEF TEST_MOUSE}
  L2.OnMouseDown := TOnMouse( MakeMethod( nil, @MouseDn1 ) );
  L2.OnMouseMove := TOnMouse( MakeMethod( nil, @MouseMv1 ) );
  L2.OnMouseDown := TOnMouse( MakeMethod( nil, @Click1 ) );
  E2.OnMouseMove := TOnMouse( MakeMethod( nil, @MouseMv1 ) );
  //E2.OnMouseDown := TOnMouse( MakeMethod( nil, @Click1 ) );
  // if Msg is shown in response to WM_MOUSEDOWN, then after
  // press OK in message box, all mouse clicks are processed
  // by the same edit control - as it is captured mouse.
  E2.OnMouseUp := TOnMouse( MakeMethod( nil, @Click1 ) );
  {$ENDIF}

  {$IFDEF TEST_ITEMS}
    {$DEFINE SET_CLICK2}
  {$ENDIF}
  {$IFDEF TEST_RADIO}
    {$DEFINE SET_CLICK2}
  {$ENDIF}
  {$IFDEF TEST_PROGRESS}
    {$DEFINE SET_CLICK2}
  {$ENDIF}
  {$IFDEF TEST_STATUS}
    {$DEFINE SET_CLICK2}
  {$ENDIF}

  {$IFDEF TEST_FORM2}
    B2.Caption := 'Form2';
    B2.OnClick := O.B2Click;
  {$ELSE}
  {$IFDEF SET_CLICK2}
    B2.OnClick := TOnEvent( MakeMethod( nil, @Click2 ) );
  {$ELSE}
  {$IFDEF TEST_MEDIAPLAYER}
    B2.Caption := 'Play';
    B2.OnClick := O.TestMediaPlayer;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  {$IFDEF TEST_CLICK}
  C1.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  C2.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  R1.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  R2.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  L1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  L2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  //B1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  B1.OnClick := O.B1Click;
  {$IFNDEF TEST_FORM2}
  {$IFNDEF SET_CLICK2}
    B2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  {$ENDIF}
  {$ENDIF}
  BX.OnClick := TOnEvent( MakeMethod( nil, @CloseClick ) );
  //E2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  {$ENDIF}

  {$IFDEF TEST_KEYBD}
  E2.OnChar := TOnChar( MakeMethod( nil, @Char1 ) );
  {$ENDIF}

  {$IFDEF TEST_COLOR}
  L1.Color := clLime;
  {$ENDIF}

  {$IFDEF TEST_FONT}
  with L1.Font^ do
  begin
    Color := clBlue;
    FontName := 'Arial'; //'Times New Roman';
    FontStyle := [  ];
    //FontWeight := 0;
    FontWidth := 5;
  end;
  with L2.Font^ do
  begin
    Color := clRed;
    FontStyle := [fsBold];
  end;
  B1.Font.FontName := 'Times New Roman'; //'Arial';
  B1.Font.FontStyle := [  ];
  with B2.Font^ do
  begin
    Color := clBlue; // has no effect on button
    FontStyle := [ fsBold, fsItalic, fsUnderline ];
  end;
  with C2.Font^ do
  begin
    Color := clGreen;
    FontStyle := [ fsBold, fsUnderline ];
  end;
  {$ENDIF}

  {$IFDEF TEST_CENTER}
  W.CenterOnParent;
  {$ENDIF}

  {$IFDEF TEST_POSITION}
  W.Position := MakePoint( 0, W.Position.y );
  {$ENDIF}

  if Applet = nil then
     Applet := W;

  T := NewTimer( 200 );
  T.OnTimer := TOnEvent( MakeMethod( nil, @TimerTick ) );

  T.Enabled := True;

  {$IFDEF TEST_TRAYICON}
  TrIc := NewTrayIcon( Applet, LoadIcon( hInstance, 'MAINICON' ) );
  Applet.Add2AutoFree( TrIc );
  //TrIc := NewTrayIcon( Applet, 0 );
  //TrIc.Icon := LoadIcon( hInstance, 'MAINICON' );
  TrIc.Tooltip := 'This is test of TTrayIcon object';
  TrIc.OnMouse := TOnTrayIconMouse( MakeMethod( nil, @TrayMouseMsg ) );
  TrIc.AutoRecreate := True;
  {$ENDIF}

  //W.Show;
  //TC.CurIndex := 2;

  Run( Applet );

  T.Free;

  {$IFDEF TEST_TRAYICON}
  //TrIc.Free;
  {$ENDIF}

  {$IFDEF TEST_JUST_ONE}
  END
    else
    W.Free;
  {$ENDIF}

end;
{$STACKFRAMES OFF}

{ TMyObj }

procedure TMyObj.LVMouseUp(Sender: PControl; var MouseData: TMouseEventData);
begin
  MsgOK( 'LVMouseUp: MousePos=(' + Int2Str( MouseData.x ) + ',' + Int2Str( MouseData.y) + ')' );
end;

procedure TMyObj.LVMouseDown(Sender: PControl; var MouseData: TMouseEventData);
begin
  MsgOK( 'LVMouseDown: MousePos=(' + Int2Str( MouseData.x ) + ',' + Int2Str( MouseData.y) + ')' );
end;

procedure TMyObj.LVClick(Sender: PObj);
begin
  MsgOK( 'LVClick' );
end;

  {$IFDEF TEST_TOOLBAR_HIGHLIGHT}
  var HIdx: Integer = 100;
  {$ENDIF}
procedure TMyObj.TBClick(Sender: PObj);
var TB: PControl;
    P : TPoint;
    Item, Idx: Integer;
    S: String;
begin
  TB := PControl( Sender );
  Item := TB.CurItem;
  Idx := TB.CurIndex;
  if Idx < 0 then
  begin
    GetCursorPos( P );
    P := TB.Screen2Client( P );
    Item := TB.TBButtonAtPos( P.x, P.y );
    Idx := TB.TBItem2Index( Item );
  end;
  S := '';
  if TB.RightClick then
    S := 'Right';
  MsgOK( 'TB' + S + 'Click'#13'cmd: ' + Int2Str( Item ) + #13'idx: ' +
                       Int2Str( Idx ) );
  {$IFDEF TEST_TOOLBAR_HIGHLIGHT}
  if TB.CurIndex = 0 then
  begin
    TB.TBButtonMarked[ HIdx ] := not TB.TBButtonMarked[ HIdx ];
    Inc( HIdx );
    if HIdx >= 100 + TB.TBButtonCount then
      HIdx := 100;
  end;
  {$ENDIF}
  {$IFDEF TEST_TOOLBAR_ENABLE}
  if TB.CurIndex = 1 then
    TB.TBButtonEnabled[ 100 ] := not TB.TBButtonEnabled[ 100 ];
  {$ENDIF}
  {$IFDEF TEST_TOOLBAR_PRESS}
  if TB.CurIndex = 2 then
    TB.TBButtonPressed[ TB.TBIndex2Item( 0 ) ] := not
    TB.TBButtonPressed[ TB.TBIndex2Item( 0 ) ];
  {$ENDIF}
end;

procedure TMyObj.TBMouseDown(Sender: PControl;
  var MouseData: TMouseEventData);
begin
  MsgOK( 'Toolbar mouse down: ' + Int2Str( MouseData.X ) + ' ' + Int2Str( MouseData.y ) );
end;

procedure TMyObj.TBDropDown( Sender: PObj );
begin
  MsgOK( 'Toolbar drop down button'#13'cmd: ' + Int2Str( TB.CurItem ) +
         #13'idx: ' + Int2Str( TB.CurIndex ) );
end;

procedure TMyObj.CBDropDown( Sender: PObj );
var CB : PControl;
begin
  CB := PControl( Sender );
  MsgOK( 'Combo dropping down, current: ' + CB.Text );
end;

procedure TMyObj.CBCloseUp( Sender: PObj );
var CB : PControl;
begin
  CB := PControl( Sender );
  MsgOK( 'Combo closed up, current: ' + CB.Text );
end;

procedure TMyObj.B1Click( Sender: PObj );
begin
  if L1.Font.FontWeight < 1000 then
  L1.Font.FontWeight := L1.font.FontWeight + 100
  else
  L1.Font.FontWeight := 0;
  L1.Caption := L1.Font.FontName + ' ' + Int2Str( L1.Font.FontWeight );

  //TC.TC_Delete( 1 );
end;

var Form2: PControl;

procedure Form2BtnClick( Dummy, Sender: PControl );
begin
  Form2.ModalResult := 100;
end;

procedure TMyObj.B2Click( Sender: PObj );
var
    Btn: PControl;
begin
  Form2 := NewForm( Applet, 'Form2' ).SetSize( 100, 100 );
  Form2.Tag := Integer( PChar( 'Form2' ) );
  Btn := NewButton( Form2, 'OK' );
  Btn.Tag := Integer( PChar( 'Btn' ) );
  Btn.OnClick := TOnEvent( MakeMethod( nil, @Form2BtnClick ) );
  {$IFDEF TEST_SHOWMODAL}
  Form2.ShowModal;
  Form2.Free;
  {$ELSE}
  Form2.Show;
  {$ENDIF}
end;

procedure AssertMsg( const Message, Filename: AnsiString; LineNumber: Integer );
begin
  MessageBox( 0, PChar('Error in: '+ Filename + ' in line #' + Int2Str(LineNumber) +
              #13#13 + Message ), 'Error', MB_OK );
  asm
    int 3
  end;
end;

function InitAssert: Boolean;
begin
  Result := not Assigned( AssertErrorProc );
  if Result then
    AssertErrorProc := @AssertMsg;
  Result := TRUE;
end;

procedure TestVolume;
var VLeft, VRight: Integer;
begin
  MsgOK( Int2Str( auxGetNumDevs ) + ' auxilary devices available'#13+
         Int2Str( waveOutGetNumDevs ) + ' wave devices available'  );
  if WaveOutChannels( -1 ) = [ ] then
  begin
    MsgOK( 'Given media device does not support volume control' );
    Exit;
  end;

  VLeft := WaveOutVolume( -1, chLeft, -1 );
  VRight := WaveOutVolume( -1, chRight, -1 );
  MsgOK( 'Current volumes:'#13'Left'#9 + Int2Str( VLeft ) + #13'Right'#9 + Int2Str( VRight ) );

  {
  if VLeft >= VRight then
  begin
    VLeft := Min( 0, VLeft - 2000 );
    VRight := Max( VRight + 2000, $FFFF );
  end
  else
  begin
    VLeft := Max( $FFFF, VLeft + 2000 );
    VRight := Min( VRight - 2000, 0 );
  end;
  }
  if VLeft < 40000 then
    VLeft := Min( VLeft + $1000, $FFFF )
  else
    VLeft := Max( 0, VLeft - $1000 );
  //VRight := VLeft;

  WaveOutVolume( -1, chLeft, VLeft or $10000 );
  //WaveOutVolume( -1, chRight, VRight );
  VLeft := WaveOutVolume( -1, chLeft, -1 );
  VRight := WaveOutVolume( -1, chRight, -1 );
  MsgOK( 'Adjusted volumes:'#13'Left'#9 + Int2Str( VLeft ) + #13'Right'#9 + Int2Str( VRight ) );

end;


var MP: PMediaPlayer;
    StartPlayingTime: DWORD;
    LengthToPlay: DWORD;
procedure TMyObj.TestMediaPlayer(Sender: PObj);
const DeviceTypes: array[ TMPDeviceType ] of PChar = ( 'unknown', 'VCR',
                   'Videodisc', 'Overlay', 'CDAudio', 'DAT',
                   'Scanner', 'AVIVideo', 'DigitalVideo', 'Other',
                   'WaveAudio', 'Sequencer' );
// To play MPEGs (and not only mpegs), correspondend file type extension MUST be
// associated with windows multimedia player.
const // TYPE HERE PATH TO ANY MULTIMEDIA YOU WISH TO PLAY
      MediaPath = //'E:\Program Files\WINAMP\DEMO.MP3';
                  //'E:\Musics\MP3\California.mp3';
                  //'E:\WIN2000\Media\Debussy''s Claire de Lune.RMI';
                  ''; // Leave this line to apply MediaName below
      AVIPath = //'E:\INSTALLS\Compilers\Delphi\InstDelphi5\Runimage\Delphi50\Demos\Coolstuf\COOL.AVI';
                'E:\INSTALLS\Compilers\Delphi\InstDelphi5\Runimage\Delphi50\Demos\Coolstuf\SPEEDIS.AVI';
                //'F:\VIDEO\SAMPLE.AVI';
                //'F:\VIDEO\TEST.MPG';
                //'F:\VIDEO\SEQ2.MPG';
                //'';
      MediaName = //'SNEEZE.WAV';
                  //'canyon.mid';
                  'chimes.wav';
                  //'passport.mid';
                  //'';
var Path: String;
  {$IFDEF TEST_CDAUDIO}
    I, Fr : Integer;
  {$ENDIF}
    Wnd: HWnd;
begin
  {$IFDEF TEST_AVI}
  Path := AVIPath;
  Wnd := PB.Handle;
  {$ELSE}
  Path := MediaPath;
  Wnd := 0;
  {$ENDIF}
  if Path = '' then
    Path := GetWindowsDir + 'Media\' + MediaName;
  if MP = nil then
  begin
    MP := NewMediaPlayer( Path, Wnd );
    if MP.Error <> 0 then
    begin
      MsgOK( 'Error #' + Int2Str( MP.Error ) + #13 +
             MP.ErrorMessage );
      MP.FileName := '';
    end
       else
      MsgOK( 'DeviceType: ' + DeviceTypes[ MP.DeviceType ] );
  end;
  if MP.HasVideo and (Wnd <> 0) then
    MP.DisplayRect := PB.ClientRect;
  MP.OnNotify := nil;
  {$IFDEF TEST_CDAUDIO}
  MP.Close;
  MP.FileName := '';
  MP.DeviceType := mmCDAudio;
  MP.Open;
    if MP.Error <> 0 then
      MsgOK( 'Error #' + Int2Str( MP.Error ) + #13 +
             MP.ErrorMessage );
  MP.Insert;
  MsgOK( 'Tracks: ' + Int2Str( MP.TrackCount ) );
  for I := 1 to MP.TrackCount do
  begin
    if MP.CDTrackNotAudio then continue;
    MP.Track := I;
    LengthToPlay := MP.TrackLength;
    if MP.Error <> 0 then
      MsgOK( 'Error in TrackLength:'#13 + MP.ErrorMessage );
    //MsgOK( 'Playing CDAudio track #' + Int2Str( I ) + ' length ' + Int2Str( L ) + ' milliseconds' );
    Fr := MP.TrackStartPosition;
    if MP.Error <> 0 then
      MsgOK( 'Error in TrackStartPosition:'#13 + MP.ErrorMessage );
    StartPlayingTime := GetTickCount;
    MP.OnNotify := O.Played; // set just before playing - to avoid too many notifications
    MP.Play( Fr, LengthToPlay );
    if MP.Error <> 0 then
      MsgOK( 'Error in Play:'#13 + MP.ErrorMessage );
    break;
  end;
  {$ELSE}
  //MsgOK( 'Test MediaPlayer now' );
  if (MP.FileName = '') and (MP.DeviceType = mmAutoSelect) and
     (MP.DeviceID = 0) then Exit;
  MP.Open;
    if MP.Error <> 0 then
    begin
      MsgOK( 'Error #' + Int2Str( MP.Error ) + #13 +
             MP.ErrorMessage );
      Exit;
    end;
  if MP.State = mpPlaying then
  begin
    MP.Close;
    MP.Open;
    if MP.HasVideo then
      MP.DisplayRect := PB.ClientRect;

    { This does not work with AVI - method above works always.
    MP.Wait := True;
    MP.Stop;
    MP.Wait := False; }
  end;
  //MP.Wait := True;
  MsgOK( 'Playing ' + MP.FileName + ', length: ' + Int2Str( MP.Length ) + ' milliseconds' );
  StartPlayingTime := GetTickCount;
  LengthToPlay := MP.Length;
  {$IFDEF TEST_DGVSPEED}
  if (MP.DeviceType = mmDigitalVideo) and (Wnd <> 0) then
  begin
    MP.DGV_Speed := MP.DGV_Speed div 2;
    LengthToPlay := LengthToPlay * 2;
  end;
  {$ENDIF}
  MP.OnNotify := O.Played; // set just before playing - to avoid too many notifications
  MP.Play( 0, -1 );
  {$ENDIF}
end;

{$DEFINE TEST_SOUNDMEM}

{$IFDEF TEST_SOUNDMEM}
procedure Experiment_PlaySnd;
var Ms: PStream;
begin
  Ms := NewMemoryStream;
  Resource2Stream( Ms, hInstance, 'TSTSOUND', RT_RCDATA );
  PlaySoundMemory( Ms.Memory, [ poWait ] ); // do not remove poWait, or do not destroy Ms stream otherwise.
  Ms.Free;
end;
{$ELSE}
procedure Experiment_PlaySnd;
begin
  //PlaySoundEvent( 'SystemStart', [ poWait ] );
  PlaySoundFile( 'TST.WAV', [ poWait ] );
  PlaySoundResourceName( hInstance, 'TSTSOUND', [ ] );
end;
{$ENDIF}


procedure TMyObj.Played( Sender: PMediaPlayer; Reason: TMPNotifyValue );
begin
  if (MP.State <> mpPlaying)
  or (GetTickCount - StartPlayingTime - 50 > LengthToPlay)
     // (This condition needed for MPEG files only).
  then
    MsgOK( MP.FileName + ' played with exit code ' + Int2Str( Ord( Reason ) ) );
end;

function TMyObj.BitBtn1Draw( Sender: PControl; State: Integer ): Boolean;
begin
  case State of
  0, 3:
    begin
      if State = 3 then // focused
        B1.Font.Color := clBlue
      else
        B1.Font.Color := clBlack;
      B1.Font.FontStyle := [ ];
    end;
  1:begin
      B1.Font.Color := clRed;
      B1.Font.FontStyle := [ fsBold ];
    end;
  2:begin
      B1.Font.Color := clGray;
      B1.Font.FontStyle := [ fsStrikeout ];
    end;
  4:begin
      B1.Font.Color := clBlue;
      B1.Font.FontStyle := [ fsBold, fsItalic ];
    end;
  end;
  Result := False; // draw it!
end;

function TMyObj.TestMouseOverB1( Sender: PControl ): Boolean;
var P: TPoint;
  function Sqr( X: Double ): Double;
  begin
    Result := X * X;
  end;
begin
  GetCursorPos( P );
  P := Sender.Screen2Client( P );
  Result := Sqr( (P.x - Sender.Width / 2) / Sender.Width )  +
            Sqr( (P.y - Sender.Height / 2) / Sender.Height )
            <= 0.25;
end;

procedure Experiment_Clipboard;
begin
  Text2Clipboard( 'Test clipboard OK!' );
  MsgOK( Clipboard2Text );
end;

procedure KOL_ASM_BUG;
const OffX = 64;
      OffY = 24;

var Img: PBitmap;
    S: string;
    Size, R: TRect;
begin
 Img := NewBitmap(1, 1);
   with Img^ do begin
     S:='Some text.';

     with Canvas^ do begin
       Font.Color:=clBtnText;
       ZeroMemory(@Size, sizeof(Size));
       RequiredState(HandleValid or FontValid or BrushValid or
ChangingCanvas );
       DrawTextEx(Handle, PChar(S), -1, Size, DT_CENTER or DT_CALCRECT,
nil);
     end;
     Width:=Size.Right + 2*OffX;
     Height:=Size.Bottom + 2*OffY;
     with Canvas^ do begin
       R := MakeRect(OffX, OffY, OffX+Size.Right, OffY+Size.Bottom);
       Brush.Color:=clBtnFace;
       FillRect( MakeRect(0, 0, Width, Height));
       RequiredState(HandleValid or FontValid or BrushValid or
ChangingCanvas );
       DrawTextEx(Handle, PChar(S), -1, R, DT_CENTER, nil);
     end;
     SaveToFile('test_bug.bmp');
   end;
   Img.Free;
end;

procedure TMyObj.CBOnKey(Sender: PControl; var Key: Char; Shift: DWORD);
begin
  W.Caption := W.Caption + Char( Key );
end;

procedure TMyObj.LVChar( Sender: PControl; var Key: Char; Shift: DWORD );
begin
  if Key = '*' then
  begin
    LV.LVSelectAll;
  end;
end;

begin

  //UseErrorMessageBox;
  {$IFNDEF VER90} {$IFNDEF VER100}
  ASSERT( InitAssert, 'InitAssert failed' );
  {$ENDIF} {$ENDIF}
  //AssertErrorProc := @AssertMsg;

  //KOL_ASM_BUG; //- fixed

  //ShowMessage( 'Trim '''': <' +  Trim( '' ) + '>' );

  {$IFDEF TEST_QUICKSORT}
  TestQuickSort;
  {$ENDIF}
  {$IFDEF TEST_STRLIST}
  Experiment_StrList;
  {$ENDIF}
  {$IFDEF TEST_BITMAP}
  Experiment_Bitmap;
  {$ENDIF}
  {$IFDEF TEST_ICON}
  Experiment_Icon;
  {$ENDIF}
  {$IFDEF TEST_CLIPBOARD}
  Experiment_Clipboard;
  {$ENDIF}

  {$IFDEF TEST_PLAYSOUND}
  {$IFDEF TEST_VOLUME}
  TestVolume;
  {$ENDIF}
  Experiment_PlaySnd;
  {$ENDIF}
  New( O, Create );
  TestObjs;
  O.Free;
  OSDialog.Free;
  ODDialog.Free;
  {$IFDEF TEST_DIRCHANGE}
  DCN.Free;
  {$ENDIF}
  Bmp1.Free;
  {
  if MP <> nil then
    MP.Pause := True;
  }
  MP.Free;
  Ico1.Free;
end.




