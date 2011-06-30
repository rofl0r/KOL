{
  Some tests for KOL. Comment/uncomment define directives below
  and compile in different test configurations.

  Now TEST_ONTOP seems not working, I'll fix it later.

  (C) by Kladov Vladimir, 2000
}

program TestKOL2;

uses
  windows,
  messages,
  kol;

//{$DEFINE USE_RESOURCE}
//{$DEFINE USE_APPBUTTON}
//{$DEFINE TEST_APPLETINVISIBLE}
//{$DEFINE CREATE_VISIBLE}
//{$DEFINE TEST_CLICK}
//{$DEFINE TEST_MOUSE}
//{$DEFINE TEST_PARENTFONTCOLOR}
//{$DEFINE TEST_DISABLED}
//{$DEFINE TEST_COLOR}
//{$DEFINE TEST_FONT}
//{$DEFINE TEST_NOCAPTION}
//{$DEFINE TEST_NOBORDER}
//{$DEFINE TEST_NORESIZE}
//{$DEFINE TEST_ONTOP}
//{$DEFINE TEST_CENTER}
//{$DEFINE TEST_POSITION}
//{$DEFINE TEST_LIST}
//{$DEFINE TEST_RECT}
//{$DEFINE TEST_GROUP}
//{$DEFINE TEST_SELECT}

{$IFDEF USE_RESOURCE}
{$R *.res}
{$ENDIF}
{
  To test application icon make resource file
  (just copy it from any other project and rename to TestKOL.res,
  do not forget uncomment line above.
}

var NNN : Integer;
var W, P1, P2, P3, B1, B2, BX, L1, L2, C1, C2, R1, R2, E1, E2, LB, CB : PControl;

procedure Click1( Dummy : Pointer; Sender : PControl );
begin
  Dec( NNN );
  MsgBox( 'Hello! ' + Sender.Caption + ' ' + Int2Str( NNN ), MB_OK );
  //ReleaseCapture;
  //SetFocus( Sender.Handle );
end;

procedure Click2( Dummy: Pointer; Sender: PControl );
begin
  R2.SetRadioChecked;
  E2.Items[ 2 ] := 'Line2';
  LB.Add( 'Item' + Int2Str( LB.Count ) );
  CB.Add( 'Item' + Int2Str( CB.Count ) );
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

procedure TestObjs;
begin

{$IFDEF USE_SYSDCUREPLACE}
  UseErrorMessageBox;
{$ENDIF}

{$IFDEF USE_APPBUTTON}
  Applet := NewApplet( 'TstApp' );
  {$IFDEF TEST_APPLETINVISIBLE}
  Applet.Visible := False;
  {$ENDIF}
  {$IFNDEF USE_RESOURCE}
  Applet.Icon := THandle(-1);
  {$ENDIF}
{$ENDIF}

  {$IFDEF TEST_LIST}
  Experiment_TList;
  {$ENDIF}

  {$IFDEF TEST_RECT}
  Experiment_TRect;
  {$ENDIF}

  W := NewForm( Applet, 'Test' );
  {$IFNDEF USE_APPBUTTON}
  {$IFNDEF USE_RESOURCE}
  W.Icon := THandle(-1);
  {$ENDIF}
  {$ENDIF}

  {$IFDEF CREATE_VISIBLE}
  W.CreateVisible := True;
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
  W.Font.Color := clHighlight;
  W.Font.FontStyle := [ fsBold, fsItalic ];
  {$ENDIF}

  P1 := NewPanel( W, esRaised );

  L1 := NewLabel( P1, 'Label1' );

  B1 := NewButton( P1, 'Button1' ).PlaceUnder;//.SetSize( 80, 0 );

  C1 := NewCheckbox( P1, 'Checkbox1' ).PlaceUnder.SetSize( 110, 0 );

  C2 := NewCheckbox( P1, 'Checkbox2' ).PlaceUnder.SetSize( 110, 0 );
  C2.Checked := True;

  C2.ResizeParent;

  P1.ResizeParent;

  B2 := NewButton( W, 'Button2' ).PlaceRight;

  BX := NewButton( W, 'X' ).SetSize( 18, 0 ).PlaceRight.ResizeParentRight;

  L2 := NewLabel( W, 'Label2' ).PlaceUnder.AlignLeft( B2 );

  {$IFDEF TEST_GROUP}
  P2 := NewGroupbox( W, 'Group1' ).PlaceUnder;
  {$ELSE}
  P2 := NewPanel( W, esLowered ).PlaceUnder;
  {$ENDIF}

  R1 := NewRadiobox( P2, 'Radiobox1' ).SetSize( 104, 0 );
  R2 := NewRadiobox( P2, 'Radiobox2' ).SetSize( 104, 0 )
        .PlaceUnder.ResizeParent;
  P2.ResizeParentRight;

  P3 := NewPanel( W, esNone ).PlaceDown.Shift( 0, 4 ).SetSize( 0, 1 );

  E1 := NewEditbox( W, [ ] ).PlaceDown;
  E1.Text := 'Edit1';
  //E1.ResizeParentBottom;

  CB := NewCombobox( W, [ {coReadOnly} ] )
        .PlaceRight; //.ResizeParent;
  {
  with CB^ do
  begin
    Add( 'aaa' );
    Add( 'bbb' );
    Add( 'ccc' );
    Add( 'ddd' );
  end;
  }

  E2 := NewEditBox( W, [ eoMultiline, eoNoHScroll, eoNoHideSel ] )
        .PlaceDown.SetSize( 0, 100 ).Shift( 0, 6 );
  E2.Text := 'Edit2';
  //E2.ResizeParentBottom;

  {$IFDEF TEST_SELECT}
  E2.SelStart := 1;
  E2.SelLength := 100;
  {$ENDIF}

  LB := NewListbox( W, [ loMultiselect ] ).PlaceDown.SetSize( 0, 100 );
  LB.ResizeParentBottom;


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

  {$IFDEF TEST_CLICK}
  C1.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  C2.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  R1.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  R2.OnClick := TOnEvent( MakeMethod( nil, @ClickChk ) );
  L1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  L2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  B1.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  //B2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
  B2.OnClick := TOnEvent( MakeMethod( nil, @Click2 ) );
  BX.OnClick := TOnEvent( MakeMethod( nil, @CloseClick ) );
  //E2.OnClick := TOnEvent( MakeMethod( nil, @Click1 ) );
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
  W.Position := MakePoint( 20, W.Position.y );
  {$ENDIF}

  //{$IFDEF CREATE_INVISIBLE}
  //W.Show;
  //{$ENDIF}

  //SetWindowPos( W.Handle, HWND_TOPMOST, 0,0,0,0, SWP_NOSIZE or SWP_NOMOVE );

{$IFDEF USE_APPBUTTON}
  Run( Applet );
{$ELSE}
  Run( W );
{$ENDIF}

end;

begin
  TestObjs;
end.

