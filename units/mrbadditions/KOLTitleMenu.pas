unit KOLTitleMenu;

interface

uses
  Windows,
  KOL,
  Messages;

type
{ Windows.pas's COLOR16 declaration is wrong; It should be a Word instead of ShortInt (This is official) }
  PTitleMenu = ^TTitleMenu;
  TTitleMenu = object(TObj)
    private
      menuFlags: Cardinal;
      hinst_msimg32: HInst;
      m_bCanDoGradientFill: Boolean;
      dllfunc_GradientFill: Pointer;
      fTitleExists: Boolean;
    protected
      fTitle: String;
      fHandle: hWnd;
      fFont: PGraphicTool;
      procedure SetFont( const F: PGraphicTool );
      procedure SetTitle( const S: String );
      function GradientFill(DC : hDC; pVertex : Pointer; dwNumVertex : DWORD;
        pMesh : Pointer; dwNumMesh, dwMode: DWORD) : Bool; stdcall;
      destructor Destroy; virtual;
    public
      clLeft, clRight, clText: DWord;
      bDrawEdge: Boolean;
      EdgeStyle: Cardinal;
      property Font: PGraphicTool read fFont write SetFont;
      property Title: String read fTitle write SetTitle;
      procedure AddMenuTitle( Menu: HMENU; txtTitle: String );
      function DrawTitle(DC: HDC; const Rect: TRect;
        ItemIdx: Integer; DrawAction: TDrawAction;
        ItemState: TDrawState): Boolean;
      function MeasureTitle(Idx: Integer): Integer;
  end;

  TRIVERTEX = packed record
    X, Y : DWORD;
    Red, Green, Blue, Alpha : Word;
  end;

  functGradientFill = function(DC : hDC; pVertex : Pointer; dwNumVertex : DWORD;
    pMesh : Pointer; dwNumMesh, dwMode: DWORD) : Bool; stdcall;

function NewTitleMenu( DrawEdge: Boolean = False; FontHeight: Integer = 0 ): PTitleMenu;

implementation

function NewTitleMenu( DrawEdge: Boolean = False; FontHeight: Integer = 0 ): PTitleMenu;
begin
  New( Result, Create );
  Result.clLeft   := GetSysColor(COLOR_ACTIVECAPTION);
  Result.clRight  := GetSysColor(COLOR_GRADIENTACTIVECAPTION);
  Result.clText   := GetSysColor(COLOR_CAPTIONTEXT);
  Result.fTitleExists := False;
  Result.bDrawEdge := DrawEdge;
  Result.EdgeStyle := BDR_SUNKENINNER;
  Result.fFont := NewFont;
  Result.fFont.FontStyle := [fsBold];
  Result.fFont.FontHeight := FontHeight;
  Result.menuFlags := MF_BYPOSITION or
    MF_DISABLED or MF_OWNERDRAW;
  Result.hinst_msimg32 := LoadLibrary( msimg32 );
  if Result.hinst_msimg32 <> 0 then
  begin
    Result.m_bCanDoGradientFill := True;
    Result.dllfunc_GradientFill := GetProcAddress( Result.hinst_msimg32, 'GradientFill' );
  end else
    Result.m_bCanDoGradientFill := False;
end;

destructor TTitleMenu.Destroy;
begin
  if hinst_msimg32 <> 0 then
    FreeLibrary( hinst_msimg32 );
  inherited;
end;

procedure TTitleMenu.SetFont( const F: PGraphicTool );
begin
  fFont := F;
  ModifyMenu( fHandle, 0,
    menuFlags and not MF_OWNERDRAW, 0, nil );
  ModifyMenu( fHandle, 0, menuFlags, 0, nil );
end;

procedure TTitleMenu.SetTitle( const S: String );
begin
  fTitle := S;
  ModifyMenu( fHandle, 0,
    menuFlags and not MF_OWNERDRAW, 0, nil );
  ModifyMenu( fHandle, 0, menuFlags, 0, nil );
end;

function TTitleMenu.GradientFill(DC : hDC; pVertex : Pointer; dwNumVertex : DWORD;
  pMesh : Pointer; dwNumMesh, dwMode: DWORD) : Bool; stdcall;
begin
  Result := False;
  if m_bCanDoGradientFill then
    Result := functGradientFill(dllfunc_GradientFill)
      ( DC, pVertex, dwNumVertex, pMesh, dwNumMesh, dwMode );
end;

function TTitleMenu.DrawTitle(DC: HDC; const Rect: TRect;
  ItemIdx: Integer; DrawAction: TDrawAction;
  ItemState: TDrawState): Boolean;
var
  pVertex: Array[0..1] of TRIVERTEX;
  pMesh: GRADIENT_RECT;
  crOldBk, crOld: COLORREF;
  modeOld: Integer;
  hfontOld: HFONT;
  ItemRect: TRect;
begin
  Result := True;
  if ItemIdx <> 0 then Exit;

  crOldBk := SetBkColor( DC, clLeft );
  ItemRect := Rect;

  pVertex[0].x      := Rect.Left;
  pVertex[0].y      := Rect.Top;
  pVertex[0].Red    := GetRValue(clLeft) shl 8;
  pVertex[0].Green  := GetGValue(clLeft) shl 8;
  pVertex[0].Blue   := GetBValue(clLeft) shl 8;
  pVertex[0].Alpha  := $0000;

  pVertex[1].x      := Rect.Right;
  pVertex[1].y      := Rect.Bottom;
  pVertex[1].Red    := GetRValue(clRight) shl 8;
  pVertex[1].Green  := GetGValue(clRight) shl 8;
  pVertex[1].Blue   := GetBValue(clRight) shl 8;
  pVertex[1].Alpha  := $0000;

  pMesh.UpperLeft   := 0;
  pMesh.LowerRight  := 1;
  
  if not ( GradientFill( DC, @pVertex, 2, @pMesh, 1,
             GRADIENT_FILL_RECT_H ) )
  then
    ExtTextOut( DC, 0, 0, ETO_OPAQUE, @ItemRect, nil, 0, nil );

  if bDrawEdge then
    DrawEdge( DC, ItemRect, EdgeStyle, BF_RECT);

  modeOld := SetBkMode( DC, TRANSPARENT );
  crOld := SetTextColor( DC, clText );
  hfontOld := SelectObject( DC, fFont.Handle );
  Inc( ItemRect.Left, GetSystemMetrics(SM_CXMENUCHECK) + 8 );
  DrawText( DC, PChar(fTitle), -1, ItemRect,
    DT_SINGLELINE or DT_VCENTER or DT_LEFT);

  SelectObject( DC, hfontOld );
  SetBkMode( DC, modeOld );
  SetBkColor( DC, crOldBk );
  SetTextColor( DC, crOld );

  Result := False;
end;

function TTitleMenu.MeasureTitle(Idx: Integer): Integer;
const
  nBorderSize: Integer = 2;
var
  screenDC, memDC: HDC;
  hfontOld: HFONT;
  Size: TSize;
begin
  Result := 0;
  if Idx <> 0 then Exit;
  if fTitleExists then Exit;
  screenDC:=GetDC( 0 );
  memDC:=CreateCompatibleDC(screenDC);

  hfontOld := SelectObject( memDC, fFont.Handle );
  GetTextExtentPoint32( memDC, PChar(fTitle), Length(fTitle),
    Size );
  SelectObject( memDC, hfontOld );
  DeleteDC( memDC );
  ReleaseDC( 0, screenDC );

  Inc( Size.cx, GetSystemMetrics(SM_CXMENUCHECK) + 8 );
  Inc( Size.cx, nBorderSize );
  Inc( Size.cy, nBorderSize );

  Result := (Size.cy and $00FF) or (Size.cx shl 16);
end;

procedure TTitleMenu.AddMenuTitle( Menu: HMENU; txtTitle: String );
begin
  fHandle := Menu;
  fTitle := txtTitle;
  InsertMenu( Menu, 0, menuFlags, 0, nil );
end;

end.
