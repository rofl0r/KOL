{
  Some tests for KOL (mainly Align property).

  Comment/uncomment define directives below
  and compile in different test configurations.
  Tags are used for debug purposes only - just ignore.

  (C) by Kladov Vladimir, 2000
}

program TestKOL4;

uses
  windows,
  messages,
  kol;

{$R *.res}
{
  To test application icon make resource file
  (just copy it from any other project and rename to TestKOL.res,
  do not forget uncomment line above).
}

type
  PMyObj = ^TMyObj;
  TMyObj = object( TObj )
  private
  protected
  public
    procedure RichEdChange( Sender: PObj );
    procedure RichEdSelChg( Sender: PObj );
    procedure B1Click( Sender: PObj );
    procedure RichEdResize( Sender: PObj );
    function FormMessage( var Msg: TMsg; var Rslt: Integer ): Boolean;
    procedure URLClick( Sender: PObj );
  end;

var O: PMyObj;
var NNN : Integer;
var F1, W, P1, P2, P3, B1, B2, BX, L1, CB1, Ed1, Sp1, Sp2, Sp3, RE : PControl;

procedure Click1( Dummy : Pointer; Sender : PControl );
begin
  Dec( NNN );
  MsgOK( 'Hello! ' + Sender.Caption + ' ' + Int2Str( NNN ) );
end;

procedure MouseDn1( Dummy : Pointer; Sender : PControl; var Mouse : TMouseEventData );
begin
  with Mouse do
  L1.Caption := 'X:' + Int2Str( X ) + ' Y:' + Int2Str( Y );
end;

procedure MouseMv1( Dummy : Pointer; Sender : PControl; var Mouse : TMouseEventData );
begin
  with Mouse do
  L1.Caption := 'X:' + Int2Str( X ) + ' Y:' + Int2Str( Y );
end;

procedure CloseClick( Dummy : Pointer; Sender : PControl );
begin
  PostQuitMessage( 0 );
end;

procedure CB1CloseUp( Sender: PObj );
begin
  {
  if GetKeyState( VK_ESCAPE ) < 0 then
  begin
    MsgOK( 'CloseUp with cancel operation...' );
  end;
  }
end;

//{$DEFINE USE_APPBUTTON}
//{$DEFINE TEST_APPLETINVISIBLE}
//{$DEFINE CREATEVISIBLE}
{$DEFINE TEST_SAVEBITS_STYLE}
//{$DEFINE CREATE_INVISIBLE}
{$DEFINE TEST_CLICK}
{$DEFINE TEST_MOUSE}
//{$DEFINE TEST_PARENTFONTCOLOR}
//{$DEFINE TEST_COLOR}
//{$DEFINE TEST_FONT}
//{$DEFINE TEST_NOCAPTION}
//{$DEFINE TEST_NOBORDER}
//{$DEFINE TEST_NORESIZE}
//{$DEFINE TEST_ONTOP}
{$DEFINE TEST_POSITION}
//{$DEFINE TEST_CENTER}
{$DEFINE TEST_TABULATE}
{$DEFINE TEST_SPLITTER}
{$DEFINE TEST_DOUBLEBUF}
//{$DEFINE TEST_TRANSPARENT}
//  {$DEFINE TEST_GRADIENT} // Turn on TEST_TRANSPARENT also to get effect
//{$DEFINE TEST_EDIT_NOTRANSPARENT}
{$DEFINE TEST_PREVENTRESIZEFLICKS}
//{$DEFINE TEST_STATUSBAR}
//{$DEFINE TEST_DEFAULTBTN}
{$DEFINE TEST_SETCURSOR}
{$DEFINE TEST_SETICON}
//{$DEFINE TEST_SETWINDOWSTATE}
//{$DEFINE TEST_GETWINDOWSTATE}

//{$DEFINE TEST_RICH_OVRDISABLE}
//{$DEFINE TEST_RICH_SHOWOVR}
//{$DEFINE TEST_RICH_TRANSPARENT}
//{$DEFINE TEST_RICH_URLDETECT}
{$DEFINE TEST_RICH_URLCLICK}
//{$DEFINE TEST_RICH_NODROP}
{$DEFINE TEST_RICH_FMTSTANDARD}
//{$DEFINE TEST_RICH_AUTOKEYBOARD} // if switched on, "lovely feature" of changing
                                   // keyboard layout is active.
{$DEFINE TEST_RICH_SEARCH}

const SamplePath1 = 'C:\BBB\AAA.TXT';
      SamplePath2 = 'C:AAA.TXT';
      SamplePath3 = 'AAA.TXT';
      SamplePath4 = 'AAA';

procedure TestObjs;
//var F: THandle;
{$IFDEF TEST_RICH_SEARCH}
var RichFound: Integer;
{$ENDIF}
var ChrFmt: TCharFormat;
begin

  {
  MsgOK( ExtractFilePath( SamplePath1 ) + #13 +
         ExtractFileName( SamplePath1 ) + #13 +
         ExtractFileNameWOExt( SamplePath1 ) + #13 +
         ExtractFileExt( SamplePath1 ) );
  MsgOK( ExtractFilePath( SamplePath2 ) + #13 +
         ExtractFileName( SamplePath2 ) + #13 +
         ExtractFileNameWOExt( SamplePath2 ) + #13 +
         ExtractFileExt( SamplePath2 ) );
  MsgOK( ExtractFilePath( SamplePath3 ) + #13 +
         ExtractFileName( SamplePath3 ) + #13 +
         ExtractFileNameWOExt( SamplePath3 ) + #13 +
         ExtractFileExt( SamplePath3 ) );
  MsgOK( ExtractFilePath( SamplePath4 ) + #13 +
         ExtractFileName( SamplePath4 ) + #13 +
         ExtractFileNameWOExt( SamplePath4 ) + #13 +
         ExtractFileExt( SamplePath4 ) );
  }


{$IFDEF USE_APPBUTTON}
  Applet := NewApplet( 'TestKOL4 applet' );
  {$IFDEF TEST_APPLETINVISIBLE}
  Applet.Visible := False;
  {$ENDIF}
{$ENDIF}

  F1 := NewForm( Applet, 'TestKOL4 form' ).Size( 100, 300 );
  if Applet = nil then Applet := F1;
  F1.Tag := Integer( PChar('F1'));
  W := F1;

{$IFDEF CREATEVISIBLE}
  F1.CreateVisible := True;
{$ENDIF}

  {$IFDEF TEST_PREVENTRESIZEFLICKS}
  F1.PreventResizeFlicks;
  {$ENDIF}

  {$IFDEF TEST_TABULATE}
  F1.Tabulate;
  {$ENDIF}

  {$IFDEF TEST_SAVEBITS_STYLE}
  F1.ClsStyle := F1.ClsStyle or CS_SAVEBITS;
  {$ENDIF}

  {$IFDEF TEST_DOUBLEBUF}
  F1.DoubleBuffered := True;
  {$ENDIF}

  {$IFDEF CREATE_INVISIBLE}
  F1.Visible := False;
  F1.CreateWindow;
  {$ENDIF}

  {$IFDEF TEST_NOCAPTION}
  F1.HasCaption := False;
  {$ENDIF}

  {$IFDEF TEST_NOBORDER}
  F1.HasBorder := False;
  F1.Margin := 0;
  {$ENDIF}

  {$IFDEF TEST_ONTOP}
  F1.ExStyle := F1.ExStyle or WS_EX_TOPMOST;
  {$ENDIF}

  {$IFDEF TEST_NORESIZE}
  F1.CanResize := False;
  {$ENDIF}

  {$IFDEF TEST_PARENTFONTCOLOR}
  F1.Font.Color := clHighlightText;
  F1.Font.FontStyle := [ fsBold, fsItalic ];
  {$ENDIF}

  {$IFDEF TEST_DEFAULTBTN}
  F1.OnMessage := O.FormMessage;
  {$ENDIF}

  {$IFDEF TEST_SETWINDOWSTATE}
  F1.WindowState := wsMinimized;
  {$ENDIF}

  {$IFDEF TEST_GETWINDOWSTATE}
  MsgOK( Int2Str( Ord( F1.WindowState ) ) );
  {$ENDIF}

  {$IFDEF TEST_GRADIENT}
  //W := NewPanel( F1, esNone ).SetAlign( caClient );
  W := NewGradientPanelEx( F1, clGreen, clYellow, gsHorizontal, glLeft );
  W.Tag := Pointer(PChar('W'));
  {$ENDIF}

  {$IFDEF TEST_TRANSPARENT}
  W.Transparent := True;
  {$ENDIF}

  P1 := NewPanel( W, esRaised ).SetAlign( caLeft );
  P1.Tag := Integer( PChar('P1') );
    L1 := NewLabel( P1, 'Label1' ).SetAlign( caTop );
    L1.Tag := Integer( PChar('L1'));
    B1 := NewButton( P1, 'Button1' ).SetAlign( caBottom ); //.ResizeParent;
    B1.Tag := (Integer( PChar('B1')) );
    //B1.Style := B1.Style or BS_DEFPUSHBUTTON;
    {$IFDEF TEST_SETCURSOR}
    B1.Cursor := LoadCursor( 0, IDC_HAND );
    {$ENDIF}
    {$IFDEF TEST_SETICON}
    W.IconLoadCursor( 0, IDC_HAND );
    {$ENDIF}

    RE := NewRichEdit1( P1, [ eoNoHideSel {, eoNoHScroll} ] );
    //RE.Ctl3D := False;
    //RE.ExStyle := RE.ExStyle - WS_EX_CLIENTEDGE;
    RE.HasBorder := False;
    //RE.ResizeParent;
    RE.SetAlign( caClient );
    RE.Size( 220, 200 );
    RE.Tag := (Integer( PChar('RichEdit')) );
    //RE.OnResize := O.RichEdResize;
    {$IFDEF TEST_RICH_URLDETECT}
    RE.RE_AutoURLDetect := True;
    {$ENDIF}
    {$IFDEF TEST_RICH_URLCLICK}
    RE.OnRE_URLClick := O.UrlClick;
    {$ENDIF}
    {
      RE.Text := 'Sample text'#13#10' Sample text'#13#10'  Sample text'#13#10'   SampleText';
    }
    {
    F := FileCreate( 'tst.rtf', ofOpenRead or ofOpenExisting or ofShareDenyWrite );
    RE.RE_Text[ reRTF, False ] := File2Str( F );
    FileClose( F );
    }
    RE.RE_LoadFromFile( GetStartDir + 'tst.rtf', reRTF, False );
    {RE.RE_Text[ reText, FALSE ] := 'This is a sample text only.'#13'It is added to a rich ' +
                         'edit control programmatically.'#13'CTRL ReplaceSelection ' +
                         'method is used.';}

    B1.OnClick := O.B1Click;
    B1.Caption := 'Save';

    RE.TabOrder := 1;
    RE.Focused := True;
    RE.OnChange := O.RichEdChange; // works fine
    RE.MaxTextSize := MaxInt; // seems working
    //RE.OnSelChange := O.RichEdSelChg; // works now

    {$IFDEF TEST_RICH_FMTSTANDARD}
      RE.RE_FmtStandard;
    {$ENDIF}
    {$IFDEF TEST_RICH_AUTOKEYBOARD}
      RE.RE_AutoKeyboard := True;
    {$ENDIF}
    {$IFDEF TEST_RICH_OVRDISABLE}
      RE.RE_DisableOverwriteChange := True;
    {$ENDIF}
    {$IFDEF TEST_RICH_SHOWOVR}
      RE.RE_OverwriteMode;
      RE.OnRE_InsOvrMode_Change := O.RichEdChange;
    {$ENDIF}

    {$IFDEF TEST_RICH_NODROP}
    RE.RE_NoOLEDragDrop; // works, but only for drop
    {$ENDIF}

    {$IFDEF TEST_RICH_TRANSPARENT}
    RE.RE_Transparent := True;
    {$ENDIF}

    {$IFDEF TEST_RICH_SEARCH}
    RichFound := RE.RE_SearchText( 'CTRL', False, False, True, 0, -1 {RE.RE_TextSize[ [rtsBytes] ]} );
    if RichFound >= 0 then
    begin
      RE.SelStart := RichFound;
      RE.SelLength := 4;
      ChrFmt := RE.RE_CharFormat;
      ChrFmt.crTextColor := $7F00;
      RE.RE_CharFormat := ChrFmt;
    end;
    {$ENDIF}

  //P1.ResizeParent;
  Sp1 := nil;
  Sp2 := nil;
  Sp3 := nil;
  {$IFDEF TEST_SPLITTER}
  Sp1 := NewSplitter( W, 0, 0 ).SetAlign( caLeft );//.PlaceRight;
  Sp1.Tag := (Integer( PChar('Sp1')) );
  {$ENDIF}

  P2 := NewPanel( W, esLowered );
  //P2.PlaceRight;
  //P2.ResizeParent;
  P2.SetAlign( caClient );
  P2.Size( 120, 0 );
  P2.Tag := (Integer( PChar('P2')) );
    P3 := NewPanel( P2, esNone ).SetAlign( caTop ).Size( 0, 20 );
    P3.Tag := (Integer( PChar('P3')) );
      B2 := NewButton( P3, 'Button2' );//.ResizeParentBottom
      B2.SetAlign( caClient );
      B2.Tag := (Integer( PChar('B2')) );
    //B2.HasBorder := False;
      BX := NewButton( P3, 'X' ).SetAlign( caRight ).Size( 18, 0 );
      BX.Tag := (Integer( PChar('BX')) );
    //P3.ResizeParent;
    {$IFDEF TEST_SPLITTER}
    Sp2 := NewSplitter( P2, 0, 0 );
    Sp2.Tag := (Integer( PChar('Sp2')) );
    {$ENDIF}
    CB1 := //NewComboBox( P2, [ coSort ] )//.PlaceDown.ResizeParent;
           NewListBox( P2, [ loSort, loNoIntegralHeight ] )//.ResizeParent
                                  .SetAlign( caBottom ).Size( 0, 50 );
    CB1.Style := CB1.Style or WS_HSCROLL;
    CB1.Perform( LB_SETHORIZONTALEXTENT, 100, 0 );
    CB1.Tag := (Integer( PChar('CB1')) );

    //CB1.HasBorder := False;

    CB1.AddDirList( 'C:\*.*', DDL_DIRECTORY or DDL_EXCLUSIVE );
    //CB1.add( 'aaa' );
    //CB1.add( 'bbb' );
    //CB1.add( 'ccc' );

    CB1.OnCloseUp := TOnEvent( MakeMethod( nil, @CB1CloseUp ) );
    {$IFDEF TEST_SPLITTER}
    Sp3 := NewSplitter( P2, 0, 0 );
    Sp3.Tag := (Integer( PChar('Sp3')) );
    {$ENDIF}

    Ed1 := NewEditbox( P2, [ eoMultiline, eoNoHScroll, eoWantReturn, eoNoHideSel ] ).SetAlign( caClient );
    Ed1.Tag := (Integer( PChar('Ed1')) );
    Ed1.Text := 'Sample text'#13#10' Sample text'#13#10'  Sample text'#13#10'   SampleText';
    Ed1.TabOrder := CB1.TabOrder;
    //Ed1.HasBorder := False;
    //Ed1.SelectAll;
    {$IFDEF TEST_SPLITTER}
    Sp2.SecondControl := Ed1;
    Sp3.SecondControl := Ed1;
    {$ENDIF}

  //P2.ResizeParent;
  {$IFDEF TEST_MOUSE}
  L1.OnMouseDown := TOnMouse( MakeMethod( nil, @MouseDn1 ) );
  L1.OnMouseMove := TOnMouse( MakeMethod( nil, @MouseMv1 ) );
  {$ENDIF}

  {$IFDEF TEST_CLICK}
  L1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  //B1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  B2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  BX.OnClick := TOnEvent( MakeMethod( nil, @CloseClick ) );
  {$ENDIF}

  {$IFDEF TEST_COLOR}
  L1.Color := clLime;
  {$ENDIF}

  {$IFDEF TEST_FONT}
  with L1.Font^ do
  begin
    Color := clBlue;
    FontStyle := [ fsBold, fsItalic, fsUnderline ]
  end;
  with L2.Font^ do
  begin
    Color := clRed;
    FontStyle := [fsBold];
  end;
  B1.Font.FontName := 'Times';
  with B2.Font^ do
  begin
    Color := clBlue; // has no effect on button
    FontStyle := [ fsBold, fsItalic, fsUnderline ];
  end;
  {$ENDIF}

  {$IFDEF TEST_CENTER}
  F1.CenterOnParent;
  {$ENDIF}

  {$IFDEF TEST_TRANSPARENT}
  {$IFDEF TEST_EDIT_NOTRANSPARENT}
  Ed1.Transparent := False;
  //Ed1.DoubleBuffered := False;
  {$ENDIF}
  {$ENDIF}

  //W.ResizeParentRight;
  if W.Parent = F1 then
    W.SetAlign( caClient );
  {$IFDEF TEST_POSITION}
  F1.Position := MakePoint( 0, 100 );
  {$ENDIF}

  {$IFDEF TEST_STATUSBAR}
  F1.SimpleStatusText := 'Test status bar';
  {$ENDIF}

  //F1.DoubleBuffered := False;
  //F1.Transparent := False;

  {$IFDEF CREATE_INVISIBLE}
  F1.Show;
  {$ENDIF}



{$IFDEF USE_APPBUTTON}
  Run( Applet );
{$ELSE}
  Run( F1 );
{$ENDIF}

end;

{ TMyObj }

procedure TMyObj.RichEdChange(Sender: PObj);
begin
  F1.Caption := //F1.Caption + '!';
                'RichText size = ' + Int2Str( RE.RE_TextSize[ [ rtsBytes ] ]);
  {$IFDEF TEST_RICH_SHOWOVR}
  if RE.RE_OverwriteMode then
    F1.Caption := F1.Caption + ' Overwrite'
  else
    F1.Caption := F1.Caption + ' Insert';
  {$ENDIF}
end;

procedure TMyObj.RichEdSelChg( Sender: PObj );
begin
  F1.Caption := F1.Caption + '/';
end;

procedure TMyObj.B1Click( Sender: PObj );
begin
  if RE.SelLength = 0 then
    RE.RE_SaveToFile( GetStartDir + 'tst.rtf', reRTF, False )
  else
    RE.RE_SaveToFile( GetStartDir + 'tst1.rtf', reRTF, True );
  // if something selected, save selection only,
  // otherwise save entire text
end;
{
var F: THandle;
    Buf: String;
begin
  F := FileCreate( 'tst.rtf', ofOpenWrite or ofOpenAlways );
  Buf := RE.RE_Text[ reRTF, False ];
  FileWrite( F, Buf[ 1 ], Length( Buf ) );
  FileClose( F );
end;
}

procedure TMyObj.RichEdResize( Sender: PObj );
begin
  RE.RE_RightIndent := RE.ClientWidth;
end;

function TMyObj.FormMessage( var Msg: TMsg; var Rslt: Integer ): Boolean;
begin
  Result := False;
  if (GetKeyState( VK_CONTROL ) or GetKeyState( VK_SHIFT ) or GetKeyState( VK_MENU )) < 0 then
    Exit;
  if Msg.wParam = VK_RETURN then
  begin
    if Msg.message = WM_KEYDOWN then
    begin
      B1.Perform( WM_LBUTTONDOWN, 0, 0 );
      Rslt := 0;
      Result := True;
    end;
    if Msg.message = WM_KEYUP then
    begin
      B1.Perform( WM_LBUTTONUP, 0, 0 );
      Rslt := 0;
      Result := True;
    end;
  end;
end;

procedure TMyObj.URLClick( Sender: PObj );
begin
  MsgOK( 'URL=' + RE.RE_URL );
end;

begin
  New( O, Create );
  TestObjs;
  O.Free;
end.

