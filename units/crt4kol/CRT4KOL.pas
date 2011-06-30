{
  CRT for KOL. (C) by Vladimir Kladov, 2003

  This unit provides very low level functions and objects to work with
  "windows" in text mode console window. This version is for Win32
  console only.
}

unit CRT4KOL;

interface

uses KOL, Windows;

const
  colorBlack   = 0;
  colorBlue    = 1;
  colorGreen   = 2;
  colorCyan    = 3;
  colorRed     = 4;
  colorMagenta = 5;
  colorYellow  = 6;
  colorWhite   = 7;
  colorLight   = 8;

var Console: THandle;

// Low-level routines to work with current Console
function getforeground: Integer;
function getbackground: Integer;
procedure foreground( Color: Byte );
procedure background( Color: Byte );
procedure attributes( fore, back: Byte );
function whereX: Integer;
function whereY: Integer;
procedure gotoXY( X, Y: Integer );
function getwidth: Integer;
function getheight: Integer;
function getsize: TCoord;

procedure cls;
procedure outc( ch: Char );
procedure outch( ch: Char );
procedure outs( const s: String );
procedure outsh( const s: String );

type
  TInputMode = ( imEcho, imEchoChar, imNoEcho );

procedure inputmode( Con: THandle; mode: TInputMode );
function inputch: Char;
function inputc: Char;
function chk_key: Char;
function chk_mouse: Boolean;

type
  PScr = ^TScr;

// Object to bufferizy video buffer content
  PBuffer = ^TBuffer;
  TBuffer = object( TObj )
  private
    function GetCharAttr(Xpos, Ypos: Integer): Word;
    procedure SetCharAttr(Xpos, Ypos: Integer; const Value: Word);
  protected
    FBuffer: PList;
    FBackColor: Byte;
    procedure Init; virtual;
  public
    destructor Destroy; virtual;
    property CharAttr[ Xpos, Ypos: Integer ]: Word read GetCharAttr write SetCharAttr;
  end;

  TFrameStyle = ( fsSingle, fsDouble, fsSolid, fsHash1, fsHash2, fsHash3,
    fsNone );
  TFrameDef = packed record
    LU, U, RU, L, R, LB, B, RB, L1, R1: Char;
  end;

  TFrameButton = ( fbMinimize, fbMaximize, fbClose );
  TFrameButtons = set of TFrameButton;

// Object to work with a window
  PWindow = ^TWindow;
  TWindow = object( TObj )
  private
    FScr: PScr;
    FFrameButtons: TFrameButtons;
    FFrameStyle: TFrameStyle;
    FTitle: String;
    FFrameDef: TFrameDef;
    FBackColor: Byte;
    procedure SetBounds(const Value: TRect);
    procedure SetFrameButtons(const Value: TFrameButtons);
    procedure SetFrameStyle(const Value: TFrameStyle);
    procedure SetScr(const Value: PScr);
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetTitle(const Value: String);
    procedure SetFrameDef(const Value: TFrameDef);
    procedure SetBackground(const Value: Byte);
    function GetHeight: SmallInt;
    function GetWidth: SmallInt;
  protected
    FBounds: TRect;
    FLines: PStrList;
    FUpdating: Boolean;
    FBuf: PBuffer;
    procedure Init; virtual;
    procedure InitFrame;
  public
    destructor Destroy; virtual;
    property OwnerScr: PScr read FScr write SetScr;
    property Bounds: TRect read FBounds write SetBounds;
    property Width: SmallInt read GetWidth;
    property Height: SmallInt read GetHeight;
    property FrameStyle: TFrameStyle read FFrameStyle write SetFrameStyle;
    property FrameButtons: TFrameButtons read FFrameButtons write SetFrameButtons;
    property BackColor: Byte read FBackColor write SetBackground;
    procedure Update;
    procedure UpdateFrame;
    property Active: Boolean read GetActive write SetActive;
    property Title: String read FTitle write SetTitle;
    property FrameDef: TFrameDef read FFrameDef write SetFrameDef;
  end;

// Object to work with all the windows
  TScr = object( TObj )
  private
    FInactiveFrameAttrs: Byte;
    FTitleAttrs: Byte;
    FFrameAttrs: Byte;
    FInactiveTitleAttrs: Byte;
    FShadow: Boolean;
    FInactiveDark: Boolean;
    FBackColor: Byte;
    procedure SetFrameAttrs(const Value: Byte);
    procedure SetInactiveFrameAttrs(const Value: Byte);
    procedure SetInactiveTitleAttrs(const Value: Byte);
    procedure SetTitleAttrs(const Value: Byte);
    function GetActiveWindow: PWindow;
    procedure SetActiveWindow(const Value: PWindow);
    procedure SetInactiveDark(const Value: Boolean);
    procedure SetShadow(const Value: Boolean);
    function GetFrameBtnAttrs(Btn: TFrameButton): Byte;
    procedure SetFrameBtnAttrs(Btn: TFrameButton; const Value: Byte);
    procedure SetBackColor(const Value: Byte);
    function GetHeight: SmallInt;
    function GetWidth: SmallInt;
  protected
    FConsole: THandle;
    FWindows: PList;
    FDestroying: Boolean;
    FFrameBtnAttrs: array[ TFrameButton ] of Byte;
    FUpdating: Boolean;
    procedure SetConsole(const Value: THandle);
    procedure Init; virtual;
  protected
    FAttrs: Byte;
    FCoords: TCoord;
    FUpdCount: Integer;
    FWantUpdate: Boolean;
  public
    property Destroying: Boolean read FDestroying;
    destructor Destroy; virtual;
    property OwnerConsole: THandle read FConsole; // write SetConsole;
    property Handle: THandle read FConsole;
    property FrameAttrs: Byte read FFrameAttrs write SetFrameAttrs;
    property TitleAttrs: Byte read FTitleAttrs write SetTitleAttrs;
    property InactiveFrameAttrs: Byte read FInactiveFrameAttrs write SetInactiveFrameAttrs;
    property InactiveTitleAttrs: Byte read FInactiveTitleAttrs write SetInactiveTitleAttrs;
    property FrameButtonsAttrs[ Btn: TFrameButton ]: Byte read GetFrameBtnAttrs write SetFrameBtnAttrs;
    property InactiveDark: Boolean read FInactiveDark write SetInactiveDark;
    property Shadow: Boolean read FShadow write SetShadow;
    property BackColor: Byte read FBackColor write SetBackColor;
    property ActiveWindow: PWindow read GetActiveWindow write SetActiveWindow;
    property Width: SmallInt read GetWidth;
    property Height: SmallInt read GetHeight;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Update;
  end;

function NewWindow( OwnScr: PScr; Left, Top, Width, Height: Integer; BkColor: Byte ): PWindow;
function scr: PScr;

const
  StdFrameDefs: array[ TFrameStyle ] of TFrameDef = (
  ( LU:#$DA; U:#$C4; RU:#$BF; L:#$B3; R:#$B3; LB:#$C0; B:#$C4; RB:#$D9; L1:#$B4; R1:#$C3 ),
  ( LU:#$C9; U:#$CD; RU:#$BB; L:#$BA; R:#$BA; LB:#$C8; B:#$CD; RB:#$BC; L1:#$B5; R1:#$C6 ),
  ( LU:#$DB; U:#$DB; RU:#$DB; L:#$DB; R:#$DB; LB:#$DB; B:#$DB; RB:#$DB; L1:#$DD; R1:#$DE ),
  ( LU:#$B0; U:#$B0; RU:#$B0; L:#$B0; R:#$B0; LB:#$B0; B:#$B0; RB:#$B0; L1:#$B0; R1:#$B0 ),
  ( LU:#$B1; U:#$B1; RU:#$B1; L:#$B1; R:#$B1; LB:#$B1; B:#$B1; RB:#$B1; L1:#$B1; R1:#$B1 ),
  ( LU:#$B2; U:#$B2; RU:#$B2; L:#$B2; R:#$B2; LB:#$B2; B:#$B2; RB:#$B2; L1:#$B2; R1:#$B2 ),
  ( LU:#0; U:#0; RU:#0; L:#0; R:#0; LB:#0; B:#0; RB:#0; L1:#0; R1:#0 )
  );
  MinimizeChar: Char = #31;
  MaximizeChar: Char = #30;
  CloseBtnChar: Char = #254;

implementation

function ScrByCon( Con: THandle ): PScr; forward;

function GetConsole: THandle;
begin
  if Console = 0 then
  begin
    Console := CreateConsoleScreenBuffer(
      GENERIC_WRITE or GENERIC_READ,
      FILE_SHARE_WRITE or FILE_SHARE_READ,
      nil,
      CONSOLE_TEXTMODE_BUFFER,
      nil
    );
    SetConsoleActiveScreenBuffer( Console );
  end;
  Result := Console;
end;

////////////////////////////////////////////////////////////////////////////////
//                               COORDINATES                                  //
////////////////////////////////////////////////////////////////////////////////

var Xcoord, Ycoord: SmallInt;
    Attrs: Byte = colorWhite;

function whereX: Integer;
begin
  Result := Xcoord;
end;

function whereY: Integer;
begin
  Result := Ycoord;
end;

procedure gotoXY( X, Y: Integer );
begin
  Xcoord := X;
  Ycoord := Y;
  SetConsoleCursorPosition( GetConsole, TCoord( (Ycoord shl 16) or Xcoord ) )
end;

procedure IncXY( dx, dy: SmallInt );
var SBI: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo( GetConsole, SBI );
  Inc( Xcoord, dx );
  if Xcoord >= SBI.dwSize.X then
  begin
    Xcoord := 0;
    Inc( Ycoord );
    if Ycoord >= SBI.dwSize.Y then
      Ycoord := 0;
  end;
  SetConsoleCursorPosition( Console, TCOORD( (Ycoord shl 16) or Xcoord ) );
end;

////////////////////////////////////////////////////////////////////////////////
//                                  SIZE                                      //
////////////////////////////////////////////////////////////////////////////////

function getwidth: Integer;
begin
  Result := getsize.X;
end;

function getheight: Integer;
begin
  Result := getsize.Y;
end;

function getsize: TCoord;
var SBI: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo( GetConsole, SBI );
  Result := SBI.dwSize;
end;

////////////////////////////////////////////////////////////////////////////////
//                                ATTRIBUTES                                  //
////////////////////////////////////////////////////////////////////////////////

function getforeground: Integer;
begin
  Result := Attrs and 15;
end;

function getforeground2( Con: THandle ): Integer;
var ScrObj: PScr;
begin
  Result := Attrs and 15;
  ScrObj := ScrByCon( Con );
  if ScrObj <> nil then
    Result := ScrObj.FAttrs and 15;
end;

function getbackground: Integer;
begin
  Result := Attrs shr 4;
end;

function getbackground2( Con: THandle ): Integer;
var ScrObj: PScr;
begin
  Result := Attrs shr 4;
  ScrObj := ScrByCon( Con );
  if ScrObj <> nil then
    Result := ScrObj.FAttrs shr 4;
end;

procedure foreground( Color: Byte );
begin
  attributes( Color, getbackground );
end;

procedure background( Color: Byte );
begin
  attributes( getforeground, Color );
end;

procedure attributes( fore, back: Byte );
var newattr: Word;
begin
  newattr := fore and 15 or (back and 15 shl 4);
  if newattr = Attrs then Exit;
  Attrs := newattr;
  SetConsoleTextAttribute( GetConsole, Attrs );
end;

////////////////////////////////////////////////////////////////////////////////
//                                 OUTPUT                                     //
////////////////////////////////////////////////////////////////////////////////

procedure cls;
var ncw: DWORD;
    size: TCoord;
    n: Integer;
begin
  size := getsize;
  n := size.X * size.Y;
  size.X := 0;
  size.Y := 0;
  FillConsoleOutputCharacter( GetConsole, ' ', n, size, ncw );
  FillConsoleOutputAttribute( Console, Attrs, n, size, ncw );
  gotoXY( 0, 0 );
end;

procedure outch( ch: Char );
var ncw: DWORD;
    Buf: Char;
begin
  if (Xcoord < getwidth) and (Ycoord < getheight) then
  begin
    Buf := ch;
    SetConsoleTextAttribute( GetConsole, Attrs );
    SetConsoleCursorPosition( Console, TCOORD( Ycoord shl 16 or Xcoord ) );
    WriteConsole( Console, @ Buf, 1, ncw, nil );
  end;
  Inc( Xcoord );
end;

procedure outc( ch: Char );
var ncw: DWORD;
    Buf: Char;
begin
  SetConsoleTextAttribute( GetConsole, Attrs );
  SetConsoleCursorPosition( Console, TCOORD( Ycoord shl 16 or Xcoord ) );
  Buf := ch;
  WriteConsole( Console, @ Buf, 1, ncw, nil );
  IncXY( 1, 0 );
end;

procedure outs( const s: String );
var ncw: DWORD;
    I: Integer;
begin
  SetConsoleTextAttribute( GetConsole, Attrs );
  for I := 1 to Length( s ) do
  begin
    SetConsoleCursorPosition( Console, TCOORD( Ycoord shl 16 or Xcoord ) );
    WriteConsole( Console, @ s[ I ], 1, ncw, nil );
    IncXY( 1, 0 );
  end;
end;

procedure outsh( const s: String );
var I: Integer;
begin
  for I := 1 to Length( s ) do
    outch( s[ I ] );
end;

////////////////////////////////////////////////////////////////////////////////
//                                 INPUT                                      //
////////////////////////////////////////////////////////////////////////////////

procedure inputmode( Con: THandle; mode: TInputMode );
var std_in: THandle;
begin
  std_in := GetStdHandle( STD_INPUT_HANDLE );
  if mode in [ imEcho, imEchoChar ] then
  begin
    SetConsoleMode( Con, ENABLE_PROCESSED_INPUT or ENABLE_WRAP_AT_EOL_OUTPUT );
    if mode = imEcho then
      SetConsoleMode( std_in, ENABLE_LINE_INPUT or ENABLE_ECHO_INPUT or
                ENABLE_MOUSE_INPUT or ENABLE_WINDOW_INPUT or
                ENABLE_PROCESSED_INPUT )
    else
      SetConsoleMode( std_in, ENABLE_ECHO_INPUT or
                ENABLE_MOUSE_INPUT or ENABLE_WINDOW_INPUT or
                ENABLE_PROCESSED_INPUT );
  end
  else
  begin
    SetConsoleMode( std_in,
              ENABLE_MOUSE_INPUT or ENABLE_WINDOW_INPUT or
              ENABLE_PROCESSED_INPUT );
    SetConsoleMode( Con, 0 );
  end;
end;

function inputch: Char;
begin
  Result := inputc;
  outch( Result );
end;

function inputc: Char;
var InBuf: TInputRecord;
    er: DWORD;
begin
  while TRUE do
  begin
    ReadConsoleInput( GetStdHandle( STD_INPUT_HANDLE ), InBuf, 1, er );
    CASE InBuf.EventType and 15 OF
    1: /// KEY_EVENT
      begin
        if InBuf.Event.KeyEvent.bKeyDown then
        begin
          CASE InBuf.Event.KeyEvent.wVirtualKeyCode OF
          VK_CONTROL, VK_SHIFT, VK_MENU: ;
          else begin
                  Result := InBuf.Event.KeyEvent.AsciiChar;
                  Exit;
               end;
          END;
        end;
      end;
    2: /// _MOUSE_EVENT
      begin

      end;
    4: /// WINDOW_BUFFER_SIZE_EVENT
      begin

      end;
    8: /// MENU_EVENT
      begin

      end;
    16: /// FOCUS_EVENT
      begin

      end;
    END;
  end;
end;

function chk_key: Char;
var InBuf: TInputRecord;
    er: DWORD;
begin
  Result := #0;
  if PeekConsoleInput( GetStdHandle( STD_INPUT_HANDLE ), InBuf, 1, er ) and
     (InBuf.EventType and 1 <> 0) then
     Result := InBuf.Event.KeyEvent.AsciiChar;
end;

function chk_mouse: Boolean;
var InBuf: TInputRecord;
    er: DWORD;
begin
  Result := FALSE;
  if PeekConsoleInput( GetStdHandle( STD_INPUT_HANDLE ), InBuf, 1, er ) and
     (InBuf.EventType and 2 <> 0) then
     Result := TRUE;
end;


////////////////////////////////////////////////////////////////////////////////
//                                 WINDOW                                     //
////////////////////////////////////////////////////////////////////////////////

function NewWindow( OwnScr: PScr; Left, Top, Width, Height: Integer;
  BkColor: Byte ): PWindow;
var W: PWindow;
begin
  new( Result, Create );
  if OwnScr = nil then
    OwnScr := scr;
  Result.FScr := OwnScr;
  Result.FBackColor := BkColor;
  W := OwnScr.ActiveWindow;
  OwnScr.FWindows.Insert( 0, Result );
  if W <> nil then
    W.InitFrame;
  OwnScr.BeginUpdate;
  Result.FrameStyle := fsSingle;
  Result.Bounds := MakeRect( Left, Top, Left + Width, Top + Height );
  Result.Active := TRUE;
  OwnScr.EndUpdate;
end;

{ TWindow }

destructor TWindow.Destroy;
begin
  FTitle := '';
  FLines.Free;
  FScr.FWindows.Remove( @ Self );
  if not FScr.Destroying then
    FScr.Update;
  FBuf.Free;
  inherited;
end;

function TWindow.GetActive: Boolean;
begin
  Result := FScr.FWindows.IndexOf( @ Self ) = 0;
end;

function TWindow.GetHeight: SmallInt;
begin
  Result := Bounds.Bottom - Bounds.Top;
end;

function TWindow.GetWidth: SmallInt;
begin
  Result := Bounds.Right - Bounds.Left;
end;

procedure TWindow.Init;
begin
  FFrameButtons := [ fbMinimize, fbMaximize, fbClose ];
  new( FBuf, Create );
end;

procedure TWindow.InitFrame;
var W, H, X2, X, Y: Integer;
    FrmColor, TitColor: Word;
    S: String;

    procedure OutBtn( var X: Integer; BtnChar: Char );
    begin
      FBuf.CharAttr[ X, 0 ] := Byte( ']' ) or FrmColor;
      FBuf.CharAttr[ X-1, 0 ] := Byte( BtnChar ) or TitColor;
      FBuf.CharAttr[ X-2, 0 ] := Byte( '[' ) or FrmColor;
      Dec( X, 4 );
    end;
begin
  W := FBounds.Right - FBounds.Left;
  H := FBounds.Bottom - FBounds.Top;
  if (W <= 0) or (H <= 0) then Exit;
  if Active then
  begin
    FrmColor := (FScr.FFrameAttrs or (FBackColor shl 4)) shl 8;
    TitColor := (FScr.FTitleAttrs or (FBackColor shl 4)) shl 8;
  end
    else
  begin
    FrmColor := (FScr.FInactiveFrameAttrs or (FBackColor and 7 shl 4)) shl 8;
    TitColor := (FScr.FInactiveTitleAttrs or (FBackColor and 7 shl 4)) shl 8;
  end;
  X2 := W - 1;
  if fbClose in FrameButtons then Dec( X2, 4 );
  if fbMaximize in FrameButtons then Dec( X2, 4 );
  if fbMinimize in FrameButtons then Dec( X2, 4 );
  for X := 1 to W - 2 do
  begin
    FBuf.CharAttr[ X, 0 ] := Byte( FFrameDef.U ) or FrmColor;
    FBuf.CharAttr[ X, H-1 ] := Byte( FFrameDef.B ) or FrmColor;
  end;
  if Title <> '' then
  begin
    FBuf.CharAttr[ 2, 0 ] := Byte( FFrameDef.L1 ) or FrmColor;
    S := Title;
    if Length( S ) + 3 >= X2 - 1 then
      S := Copy( S, 1, X2 - 4 );
    for X := 3 to Length( S ) + 2 do
      FBuf.CharAttr[ X, 0 ] := Byte( S[ X - 2 ] ) or TitColor;
    FBuf.CharAttr[ 3 + Length( S ), 0 ] := Byte( FFrameDef.R1 ) or FrmColor;
  end;
  X := W - 2;
  if fbClose in FrameButtons then OutBtn( X, CloseBtnChar );
  if fbMaximize in FrameButtons then OutBtn( X, MaximizeChar );
  if fbMinimize in FrameButtons then OutBtn( X, MinimizeChar );

  FBuf.CharAttr[ 0, 0 ] := Byte( FFrameDef.LU ) or FrmColor;
  FBuf.CharAttr[ W-1, 0 ] := Byte( FFrameDef.RU ) or FrmColor;

  for Y := 1 to H-2 do
  begin
    FBuf.CharAttr[ 0, Y ] := Byte( FFrameDef.L ) or FrmColor;
    FBuf.CharAttr[ W - 1, Y ] := Byte( FFrameDef.R ) or FrmColor;
  end;
  FBuf.CharAttr[ 0, H-1 ] := Byte( FFrameDef.LB ) or FrmColor;
  FBuf.CharAttr[ W - 1, H-1 ] := Byte( FFrameDef.RB ) or FrmColor;
end;

procedure TWindow.SetActive(const Value: Boolean);
var W: PWindow;
begin
  //if Value = Active then Exit;
  if Value then
  begin
    W := FScr.ActiveWindow;
    if not Active then
      FScr.FWindows.MoveItem( FScr.FWindows.IndexOf( @ Self ), 0 );
  end
  else
  begin
    if Active then
      FScr.FWindows.MoveItem( 0, FScr.FWindows.Count );
    W := FScr.ActiveWindow;
  end;
  if (W <> @ Self) and (W <> nil) then
    W.InitFrame;
  InitFrame;
  FScr.Update;
  if FrameStyle = fsNone then
    gotoXY( Bounds.Left, Bounds.Top )
  else
    gotoXY( Bounds.Left+1, Bounds.Top+1 );
end;

procedure TWindow.SetBackground(const Value: Byte);
begin
  FBackColor := Value;
  Update;
end;

procedure TWindow.SetBounds(const Value: TRect);
var OldBuf: PBuffer;
    I, J, C: Integer;
begin
  OldBuf := FBuf;
  FBounds := Value;
  TRY
    new( FBuf, Create );
    for I := 0 to FBounds.Bottom - FBounds.Top - 1 do
      for J := 0 to FBounds.Right - FBounds.Left - 1 do
      begin
        C := Integer( OldBuf.CharAttr[ I, J ] );
        if C = 0 then
          C := Byte( ' ' ) or FBackColor shl 12;
        FBuf.CharAttr[ J, I ] := C;
      end;
  FINALLY
    OldBuf.Free;
  END;
  FScr.Update;
end;

procedure TWindow.SetFrameButtons(const Value: TFrameButtons);
begin
  FFrameButtons := Value;
  InitFrame;
  UpdateFrame;
end;

procedure TWindow.SetFrameDef(const Value: TFrameDef);
begin
  FFrameDef := Value;
  InitFrame;
  UpdateFrame;
end;

procedure TWindow.SetFrameStyle(const Value: TFrameStyle);
begin
  FFrameStyle := Value;
  FrameDef := StdFrameDefs[ Value ];
end;

procedure TWindow.SetScr(const Value: PScr);
begin
  if FScr = Value then Exit;
  FScr.FWindows.Remove( @ Self );
  FScr.Update;
  FScr := Value;
  FScr.FWindows.Add( @ Self );
  FScr.Update;
end;

procedure TWindow.SetTitle(const Value: String);
begin
  if FTitle = Value then Exit;
  FTitle := Value;
  InitFrame;
  UpdateFrame;
end;

procedure TWindow.Update;
var //CurCon: THandle;
    //FC: Byte;
    X, Y, W, H: Integer;
    CA: Word;
    OutBuf, P: PCharInfo;
    WRect: TSmallRect;
    C0: TCoord;
begin
  //CurCon := Console;
  if not FScr.FUpdating then
  begin
    if not Active then
    begin
      FScr.Update;
      Exit;
    end;
    //Console := FScr.OwnerConsole;
  end;
  //FC := getforeground;
  W := Width;
  H := Height;
  GetMem( OutBuf, Sizeof( TCharInfo ) * W * H );
  TRY
    {UpdateFrame;
    D := 1;
    if FrameStyle = fsNone then D := 0;
    for Y := Bounds.Top+D to Bounds.Bottom-1-D do
    begin
      gotoXY( Bounds.Left+D, Y );
      for X := Bounds.Left+D to Bounds.Right-1-D do
      begin
        CA := FBuf.CharAttr[ X - Bounds.Left, Y-Bounds.Top ];
        attributes( CA shr 8, CA shr 12 );
        outch( Char( CA ) );
      end;
    end;}

    P := OutBuf;
    for Y := Bounds.Top to Bounds.Bottom-1 do
      for X := Bounds.Left to Bounds.Right-1 do
      begin
        CA := FBuf.CharAttr[ X - Bounds.Left, Y-Bounds.Top ];
        P^.AsciiChar := Char( CA );
        P^.Attributes := CA shr 8;
        Inc( P );
      end;

    C0.X := 0;
    C0.Y := 0;
    WRect.Left := Bounds.Left;
    WRect.Top := Bounds.Top;
    WRect.Right := Bounds.Right;
    WRect.Bottom := Bounds.Bottom;
    WriteConsoleOutput( FScr.FConsole, OutBuf, TCoord( (H shl 16) or W ),
      C0, WRect );

    if Active then
      if FrameStyle = fsNone then
        gotoXY( Bounds.Left, Bounds.Top )
      else
        gotoXY( Bounds.Left+1, Bounds.Top+1 );
  FINALLY
    {if not FScr.FUpdating then
      if CurCon <> 0 then
        Console := CurCon;
    attributes( FC, FScr.FBackColor );}
    FreeMem( OutBuf );
  END;
end;

procedure TWindow.UpdateFrame;
var X, Y: Integer;
    CA: Word;
    OutBuf, P: PCharInfo;
    C0: TCoord;
    WRect: TSmallRect;
begin
  if (Width <= 0) or (Height <= 0) then Exit;
  GetMem( OutBuf, Max( Width, Height ) * Sizeof( TCharInfo ) );
  TRY
    C0.X := 0;
    C0.Y := 0;
    WRect.Left := Bounds.Left;
    WRect.Top := Bounds.Top;
    P := OutBuf;
    for X := Bounds.Left to Bounds.Right-1 do
    begin
      CA := FBuf.CharAttr[ X - Bounds.Left, 0 ];
      P^.AsciiChar := Char( CA );
      P^.Attributes := CA shr 8;
      Inc( P );
    end;
    WRect.Right := Bounds.Right;
    WRect.Bottom := Bounds.Top + 1;
    WriteConsoleOutput( FScr.FConsole, OutBuf, TCoord( 1 shl 16 or Width ),
      C0, WRect );

    if Height > 1 then
    begin
      WRect.Top := Bounds.Top + 1;
      P := OutBuf;
      for Y := Bounds.Top+1 to Bounds.Bottom-1 do
      begin
        CA := FBuf.CharAttr[ 0, Y - Bounds.Top ];
        P^.AsciiChar := Char( CA );
        P^.Attributes := CA shr 8;
        Inc( P );
      end;
      WRect.Right := WRect.Left + 1;
      WRect.Bottom := Bounds.Bottom;
      WriteConsoleOutput( FScr.FConsole, OutBuf, TCoord( (Height-1) shl 16 or 1 ),
        C0, WRect );

      WRect.Left := Bounds.Right-1;
      P := OutBuf;
      for Y := Bounds.Top+1 to Bounds.Bottom-1 do
      begin
        CA := FBuf.CharAttr[ Width - 1, Y - Bounds.Top ];
        P^.AsciiChar := Char( CA );
        P^.Attributes := CA shr 8;
        Inc( P );
      end;
      WRect.Right := WRect.Left + 1;
      WriteConsoleOutput( FScr.FConsole, OutBuf, TCoord( (Height-1) shl 16 or 1 ),
        C0, WRect );
    end;

    if Width > 2 then
    begin
      P := OutBuf;
      for X := Bounds.Left+1 to Bounds.Right-2 do
      begin
        CA := FBuf.CharAttr[ X - Bounds.Left, Height-1 ];
        P^.AsciiChar := Char( CA );
        P^.Attributes := CA shr 8;
        Inc( P );
      end;
      WRect.Left := Bounds.Left+1;
      WRect.Right := Bounds.Right-2;
      WRect.Top := Bounds.Bottom-1;
      WRect.Bottom := Bounds.Bottom;
      WriteConsoleOutput( FScr.FConsole, OutBuf, TCoord( 1 shl 16 or (Width-2) ),
        C0, WRect );
    end;

  FINALLY
    {if not FScr.FUpdating and not FUpdating then
    begin
      background( FScr.FBackColor );
      if CurCon <> 0 then
        Console := CurCon;
    end;
    gotoXY( SaveCoords.X, SaveCoords.Y );}
    FreeMem( OutBuf );
  END;
end;

////////////////////////////////////////////////////////////////////////////////
//                                 SCREEN                                     //
////////////////////////////////////////////////////////////////////////////////

var
  CurScreen: PScr;
  Screens: PList;

function scr: PScr;
var I: Integer;
begin
  if (CurScreen = nil) or (CurScreen.OwnerConsole <> GetConsole) then
  begin
    CurScreen := nil;
    if Screens = nil then
      Screens := NewList;
    for I := 0 to Screens.Count-1 do
    begin
      CurScreen := Screens.Items[ I ];
      if CurScreen.OwnerConsole = Console then break
      else CurScreen := nil;
    end;
    if CurScreen = nil then
    begin
      new( CurScreen, Create );
      CurScreen.FConsole := Console;
      Screens.Add( CurScreen );
    end;
  end;
  Result := CurScreen;
end;

function ScrByCon( Con: THandle ): PScr;
var I: Integer;
begin
  Result := nil;
  if Screens = nil then Exit;
  for I := 0 to Screens.Count-1 do
  begin
    Result := Screens.Items[ I ];
    if Result.FConsole = Con then Exit;
    Result := nil;
  end;
end;

{ TScr }

procedure TScr.BeginUpdate;
begin
  Inc( FUpdCount );
end;

destructor TScr.Destroy;
begin
  FDestroying := TRUE;
  CloseHandle( FConsole );
  if FConsole = Console then
    Console := 0;
  FWindows.ReleaseObjects;
  inherited;
end;

procedure TScr.EndUpdate;
begin
  Dec( FUpdCount );
  if FUpdCount = 0 then
    if FWantUpdate then
      Update;
  FWantUpdate := FALSE;
end;

function TScr.GetActiveWindow: PWindow;
begin
  Result := nil;
  if FWindows.Count > 0 then
    Result := FWindows.Items[ 0 ];
end;

function TScr.GetFrameBtnAttrs(Btn: TFrameButton): Byte;
begin
  Result := FFrameBtnAttrs[ Btn ];
end;

function TScr.GetHeight: SmallInt;
var SBI: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo( GetConsole, SBI );
  Result := SBI.dwSize.Y;
end;

function TScr.GetWidth: SmallInt;
var SBI: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo( GetConsole, SBI );
  Result := SBI.dwSize.X;
end;

procedure TScr.Init;
begin
  FFrameAttrs := colorGreen or colorLight;
  FTitleAttrs := colorCyan or colorLight;
  FInactiveFrameAttrs := colorGreen;
  FInactiveTitleAttrs := colorCyan;
  FWindows := NewList;
end;

procedure TScr.SetActiveWindow(const Value: PWindow);
var Idx: Integer;
begin
  Idx := FWindows.IndexOf( Value );
  if Idx < 0 then Exit;
  FWindows.MoveItem( Idx, 0 );
  Update;
end;

procedure TScr.SetBackColor(const Value: Byte);
begin
  FBackColor := Value;
  Update;
end;

procedure TScr.SetConsole(const Value: THandle);
begin
  FConsole := Value;
  Update;
end;

procedure TScr.SetFrameAttrs(const Value: Byte);
begin
  FFrameAttrs := Value;
  Update;
end;

procedure TScr.SetFrameBtnAttrs(Btn: TFrameButton; const Value: Byte);
begin
  FFrameBtnAttrs[ Btn ] := Value;
  Update;
end;

procedure TScr.SetInactiveDark(const Value: Boolean);
begin
  FInactiveDark := Value;
  Update;
end;

procedure TScr.SetInactiveFrameAttrs(const Value: Byte);
begin
  FInactiveFrameAttrs := Value;
  Update;
end;

procedure TScr.SetInactiveTitleAttrs(const Value: Byte);
begin
  FInactiveTitleAttrs := Value;
  Update;
end;

procedure TScr.SetShadow(const Value: Boolean);
begin
  FShadow := Value;
  Update;
end;

procedure TScr.SetTitleAttrs(const Value: Byte);
begin
  FTitleAttrs := Value;
  Update;
end;

procedure TScr.Update;
var //CurCon: THandle;
    I, X, Y: Integer;
    W: PWindow;
    OutBuf, P: PCharInfo;
    CA: Integer;
    C0: TCoord;
    WRect: TSmallRect;
begin
  if FUpdCount > 0 then
  begin
    FWantUpdate := TRUE;
    Exit;
  end;
  //CurCon := Console;
  FUpdating := TRUE;

  GetMem( OutBuf, Sizeof( TCharInfo ) * Width * Height );
  P := OutBuf;
  for I := 1 to Width * Height do
  begin
    P^.AsciiChar := ' ';
    P^.Attributes := FBackColor shl 4;
    Inc( P );
  end;
  TRY
    {Console := FConsole;
    background( BackColor );
    cls;
    for I := FWindows.Count-1 downto 0 do
    begin
      W := FWindows.Items[ I ];
      W.Update;
    end;}

    for I := FWindows.Count-1 downto 0 do
    begin
      W := FWindows.Items[ I ];
      for Y := W.FBounds.Top to W.FBounds.Bottom-1 do
      begin
        P := Pointer( Integer( OutBuf ) + ( Y * Width + W.FBounds.Left ) * Sizeof( TCharInfo ) );
        for X := W.FBounds.Left to W.FBounds.Right-1 do
        begin
          CA := W.FBuf.CharAttr[ X - W.FBounds.Left, Y - W.FBounds.Top ];
          P^.AsciiChar := Char( CA );
          P^.Attributes := CA shr 8;
          Inc( P );
        end;
      end;
    end;

    C0.X := 0;
    C0.Y := 0;
    WRect.Left := 0;
    WRect.Top := 0;
    WRect.Right := Width;
    WRect.Bottom := Height;
    WriteConsoleOutput( FConsole, OutBuf, TCoord( (Height shl 16) or Width ),
      C0, WRect );

  FINALLY
    {if CurCon <> 0 then
      Console := CurCon;}
    FUpdating := FALSE;
    FreeMem( OutBuf );
  END;
  //background( BackColor );
end;

{ TBuffer }

destructor TBuffer.Destroy;
begin
  FBuffer.ReleaseObjects;
  inherited;
end;

function TBuffer.GetCharAttr(Xpos, Ypos: Integer): Word;
var Row: PList;
begin
  Result := 0;
  if Ypos >= FBuffer.Count then Exit;
  Row := FBuffer.Items[ Ypos ];
  if Xpos >= Row.Count then Exit;
  Result := Word( Row.Items[ Xpos ] );
end;

procedure TBuffer.Init;
begin
  FBuffer := NewList;
end;

procedure TBuffer.SetCharAttr(Xpos, Ypos: Integer; const Value: Word);
var Row: PList;
    I: Integer;
    ForeColor: Byte;
begin
  while Ypos >= FBuffer.Count do
  begin
    Row := NewList;
    FBuffer.Add( Row );
  end;
  Row := FBuffer.Items[ Ypos ];
  ForeColor := getforeground;
  while Xpos >= Row.Count do
  begin
    I := Integer( ' ' ) or (FBackColor shl 4 or ForeColor) shl 8;
    Row.Add( Pointer( I ) );
  end;
  Row.Items[ Xpos ] := Pointer( Value );
end;

initialization
finalization

  if Screens <> nil then
  begin
    Screens.ReleaseObjects;
    Screens := nil;
  end;

  if Console <> 0 then
    CloseHandle( Console );
  Console := 0;

end.
