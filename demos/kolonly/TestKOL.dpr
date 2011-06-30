{
  Some tests for KOL. Comment/uncomment define directives below
  and compile in different test configurations.

  Now TEST_PARENTFONTCOLOR seems not working working,
  and TEST_ONTOP. I'll fix it later.

  (C) by Kladov Vladimir, 2000
}

program TestKOL;

uses
  windows,
  messages,
  kol;

//{$DEFINE USE_RESOURCE}
{$IFDEF USE_RESOURCE}
{$R *.res}
{$ENDIF}
{
  To test application icon make resource file
  (just copy it from any other project and rename to TestKOL.res,
  do not forget uncomment line above.
}

var NNN : Integer;
var W, P1, B1, B2, BX, L1, L2 : PControl;

procedure Click1( Dummy : Pointer; Sender : PControl );
begin
  Dec( NNN );
  MsgOK( 'Hello! ' + Sender.Caption + ' ' + Int2Str( NNN ) );
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

//{$DEFINE USE_APPBUTTON}
//{$DEFINE TEST_APPLETINVISIBLE}
//{$DEFINE CREATE_INVISIBLE}
//{$DEFINE TEST_CLICK}
//{$DEFINE TEST_MOUSE}
//{$DEFINE TEST_PARENTFONTCOLOR}
//{$DEFINE TEST_COLOR}
//{$DEFINE TEST_FONT}
//{$DEFINE TEST_NOCAPTION}
//{$DEFINE TEST_NOBORDER}
//{$DEFINE TEST_NORESIZE}
//{$DEFINE TEST_ONTOP}
//{$DEFINE TEST_POSITION}
//{$DEFINE TEST_CENTER}
//{$DEFINE TEST_LIST}
{$DEFINE TEST_EMPTY_FORM_ONLY}

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

procedure TestObjs;
begin

{$IFDEF USE_APPBUTTON}
  Applet := NewApplet( 'TstApp' );
  {$IFNDEF USE_RESOURCE}
  Applet.Icon := -1;
  {$ENDIF}
  {$IFDEF TEST_APPLETINVISIBLE}
  Applet.Visible := False;
  {$ENDIF}
{$ENDIF}

  {$IFDEF TEST_LIST}
  Experiment_TList;
  {$ENDIF}

  W := NewForm( Applet, 'Test' );
  {$IFNDEF USE_APPBUTTON}
  {$IFNDEF USE_RESOURCE}
  W.Icon := THandle( -1 );
  {$ENDIF}
  {$ENDIF}


  {$IFDEF CREATE_INVISIBLE}
  W.Visible := False;
  W.CreateWindow;
  {$ENDIF}

  {$IFDEF TEST_NOCAPTION}
  W.HasCaption := False;
  {$ENDIF}

  {$IFDEF TEST_NOBORDER}
  W.HasBorder := False;
  W.Margin := 0;
  {$ENDIF}

  {$IFDEF TEST_ONTOP}
  W.ExStyle := W.ExStyle or WS_EX_TOPMOST;
  {$ENDIF}

  {$IFDEF TEST_NORESIZE}
  W.CanResize := False;
  {$ENDIF}

  {$IFDEF TEST_PARENTFONTCOLOR}
  W.Font.Color := clHighlightText;
  W.Font.FontStyle := [ fsBold, fsItalic ];
  {$ENDIF}

  {$IFNDEF TEST_EMPTY_FORM_ONLY}
  P1 := NewPanel( W, esRaised );

  L1 := NewLabel( P1, 'Label1' );

  B1 := NewButton( P1, 'Button1' ).PlaceDown;//.SetSize( 80, 0 );
  B1.ResizeParent;

  P1.ResizeParent;

  B2 := NewButton( W, 'Button2' ).PlaceRight;

  BX := NewButton( W, 'X' ).SetSize( 18, 0 ).PlaceRight.ResizeParentRight;

  L2 := NewLabel( W, 'Label2' )
    .PlaceDown.AlignLeft( B2 );

  {$IFDEF TEST_MOUSE}
  L2.OnMouseDown := TOnMouse( MakeMethod( nil, @MouseDn1 ) );
  L2.OnMouseMove := TOnMouse( MakeMethod( nil, @MouseMv1 ) );
  {$ENDIF}

  {$IFDEF TEST_CLICK}
  L1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  B1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
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
  W.CenterOnParent;
  {$ENDIF}

  {$IFDEF TEST_POSITION}
  W.Position := MakePoint( 20, W.Position.y );
  {$ENDIF}

  {$IFDEF CREATE_INVISIBLE}
  W.Show;
  {$ENDIF}

  {$ENDIF}

{$IFDEF USE_APPBUTTON}
  Run( Applet );
{$ELSE}
  Run( W );
{$ENDIF}

end;

begin
  TestObjs;
end.

