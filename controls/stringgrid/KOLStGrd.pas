unit KOLStGrd;                                                                                           

interface

uses Windows, Messages, KOL;

const
  MaxCustomExtents = Maxint div 16;
  MaxShortInt = High(ShortInt);

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxCustomExtents] of Integer;
               
  PStrListArray = ^TStrListArray;
  TStrListArray = array of PStrList;
  
  // TMyEvent = procedure(Sender: PControl; Str: String; const Error: Boolean; var Retry: Boolean) of object;

  TScrollStyle = (ssNone, ssHorizontal, ssVertical, ssBoth);

  TGetExtentsFunc = function(Index: Longint): Integer of object;

  TGridAxisDrawInfo = record
    EffectiveLineWidth: Integer;
    FixedBoundary: Integer;
    GridBoundary: Integer;
    GridExtent: Integer;
    LastFullVisibleCell: Longint;
    FullVisBoundary: Integer;
    FixedCellCount: Integer;
    FirstGridCell: Integer;
    GridCellCount: Integer;
    GetExtent: TGetExtentsFunc;
  end;

  TGridDrawInfo = record
    Horz, Vert: TGridAxisDrawInfo;
  end;

  TGridState = (gsNormal, gsSelecting, gsRowSizing, gsColSizing,
    gsRowMoving, gsColMoving);
  TGridMovement = gsRowMoving..gsColMoving;

  TGridOption = (goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
    goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing, goRowMoving,
    goColMoving, goEditing, goTabs, goRowSelect,
    goAlwaysShowEditor, goThumbTracking);
  TGridOptions = set of TGridOption;
  TGridDrawState = set of (gdSelected, gdFocused, gdFixed);
  TGridScrollDirection = set of (sdLeft, sdRight, sdUp, sdDown);

  TGridCoord = record
    X: Longint;
    Y: Longint;
  end;

  TGridRect = record
    case Integer of
      0: (Left, Top, Right, Bottom: Longint);
      1: (TopLeft, BottomRight: TGridCoord);
  end;

  TEditStyle =  (esSimple, esEllipsis, esPickList);

  TSelectCellEvent = procedure (Sender: PControl; ACol, ARow: Longint;
    var CanSelect: Boolean) of object;
  TDrawCellEvent = procedure (Sender: PControl; Cnv: PCanvas; ACol, ARow: Longint;
    Rect: TRect; State: TGridDrawState) of object;

  PStGrd = ^TStGrd;
  TStGrd = object(TControl)
  private
    function GetColWidths(Index: Integer): Integer;
    function GetGridHeight: Integer;
    function GetGridWidth: Integer;
    function GetRowHeights(Index: Integer): Integer;
    function GetSelection: TGridRect;
//    function GetTabStops(Index: Integer): Boolean;
    function GetVisibleColCount: Integer;
    function GetVisibleRowCount: Integer;
    procedure SetCol(const Value: Longint);
    procedure SetColCount(Value: Longint);
    procedure SetColWidths(Index: Integer; const Value: Integer);
    procedure SetDefaultColWidth(const Value: Integer);
    procedure SetDefaultRowHeight(const Value: Integer);
    procedure SetFixedCols(const Value: Integer);
    procedure SetFixedRows(const Value: Integer);
    procedure SetLeftCol(const Value: Longint);
    procedure SetOptions(Value: TGridOptions);
    procedure SetRow(const Value: Longint);
    procedure SetRowCount(Value: Longint);
    procedure SetRowHeights(Index: Integer; const Value: Integer);
    procedure SetScrollBars(const Value: TScrollStyle);
    procedure SetSelection(const Value: TGridRect);
//    procedure SetTabStops(Index: Integer; const Value: Boolean);
    procedure SetTopRow(const Value: Longint);
    function GetCol: Longint;
    function GetLeftCol: Longint;
    function GetRow: Longint;
    function GetTopRow: Longint;
    function GetColCount: Longint;
    function GetDefaultColWidth: Integer;
    function GetDefaultDrawing: Boolean;
    function GetHitTest: TPoint;
    procedure SetDefaultDrawing(const Value: Boolean);
    function GetDefaultRowHeight: Integer;
    function GetFixedCols: Integer;
    function GetFixedRows: Integer;
    function GetOptions: TGridOptions;
    function GetRowCount: Longint;
    function GetScrollBars: TScrollStyle;

    function CalcCoordFromPoint(X, Y: Integer; const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CalcDrawInfoXY(var DrawInfo: TGridDrawInfo; UseWidth, UseHeight: Integer);
    procedure GridRectToScreenRect(GridRect: TGridRect; var ScreenRect: TRect; IncludeLine: Boolean);
    function IsActiveControl: Boolean;
    procedure MoveCurrent(ACol, ARow: Longint; _MoveAnchor, _Show: Boolean);
    procedure ClampInView(const Coord: TGridCoord);
    function CalcMaxTopLeft(const Coord: TGridCoord; const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure SelectionMoved(const OldSel: TGridRect);
    procedure InvalidateRect(ARect: TGridRect);
    procedure ChangeSize(NewColCount, NewRowCount: Longint);
    procedure MoveAnchor(const NewAnchor: TGridCoord);
    procedure MoveTopLeft(ALeft, ATop: Longint);
    procedure DrawSizingLine(const DrawInfo: TGridDrawInfo);
    procedure DrawMove;
    procedure MoveAndScroll(Mouse, CellHit: Integer; var DrawInfo: TGridDrawInfo;
      var Axis: TGridAxisDrawInfo; Scrollbar: Integer; const MousePt: TPoint);
    procedure ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal; UseRightToLeft: Boolean);
    procedure ScrollDataInfo(DX, DY: Integer; var DrawInfo: TGridDrawInfo);
    procedure UpdateScrollPos;
    procedure UpdateScrollRange;
    procedure MoveAdjust(var CellPos: Longint; FromIndex, ToIndex: Longint);
    procedure CancelMode;

    procedure WMTimer;
    procedure WMSetCursor(_HitTest: Word);
    function GetOnDrawCell: TDrawCellEvent;
    procedure SetOnDrawCell(const Value: TDrawCellEvent);
    function GetCells(ACol, ARow: Integer): string;
    procedure SetCells(ACol, ARow: Integer; const Value: string);

   // function GetMyEvent: TMyEvent;
   // procedure SetMyEvent(const Value: TMyEvent);

   // procedure OnNewLVData(Sender: PControl; Idx, SubItem: Integer; var Txt: String;
   //			    var ImgIdx: Integer; var State: DWORD; var Store: Boolean);
//  protected
    procedure CalcDrawInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcFixedInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcSizingState(X, Y: Integer; var State: TGridState; var Index: Longint; var SizingPos, SizingOfs: Integer; var FixedInfo: TGridDrawInfo);// virtual;
    procedure DrawCell(Cnv: PCanvas; ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);// virtual;
    procedure FocusCell(ACol, ARow: Longint; _MoveAnchor: Boolean);
    procedure InvalidateCell(ACol, ARow: Longint);
    function BoxRect(ALeft, ATop, ARight, ABottom: Longint): TRect;
    procedure Paint(DC: HDC);
    procedure KeyDown(var Key: Integer);
    procedure MouseDown({Button: TMouseButton; Shift: TShiftState;} X, Y: Integer);
    procedure MouseMove({Shift: TShiftState;} X, Y: Integer);
    procedure MouseUp({Button: TMouseButton; Shift: TShiftState;} X, Y: Integer);
    procedure WheelDown{(Shift: TShiftState; MousePos: TPoint): Boolean};
    procedure WheelUp{(Shift: TShiftState; MousePos: TPoint): Boolean};
    procedure TimedScroll(Direction: TGridScrollDirection);
    procedure ScrollData(DX, DY: Integer);
    function SelectCell(ACol, ARow: Longint): Boolean;
    procedure MoveColumn(FromIndex, ToIndex: Longint);
    procedure MoveRow(FromIndex, ToIndex: Longint);
    procedure TopLeftMoved(const OldTopLeft: TGridCoord);
    function GetRows(Index: Integer): pStrList;
    procedure SetRows(Index: Integer; const Value: pStrList);
    function GetOnSelectCell: TSelectCellEvent;
    procedure SetOnSelectCell(const Value: TSelectCellEvent);
  public
    // property MyEvent: TMyEvent read GetMyEvent write SetMyEvent;
    property OnDrawCell: TDrawCellEvent read GetOnDrawCell write SetOnDrawCell;
    property OnSelectCell: TSelectCellEvent read GetOnSelectCell write SetOnSelectCell;

    // property OnLVData: Boolean read FNotAvailable;
    property Col: Longint read GetCol write SetCol;
//    property Color;
    property ColCount: Longint read GetColCount write SetColCount;
    property ColWidths[Index: Longint]: Integer read GetColWidths write SetColWidths;
    property DefaultColWidth: Integer read GetDefaultColWidth write SetDefaultColWidth;
    property DefaultDrawing: Boolean read GetDefaultDrawing write SetDefaultDrawing;
    property DefaultRowHeight: Integer read GetDefaultRowHeight write SetDefaultRowHeight;
    property FixedCols: Integer read GetFixedCols write SetFixedCols;
    property FixedRows: Integer read GetFixedRows write SetFixedRows;
    property GridHeight: Integer read GetGridHeight;
    property GridWidth: Integer read GetGridWidth;
    property HitTest: TPoint read GetHitTest;
    property LeftCol: Longint read GetLeftCol write SetLeftCol;
    property Options: TGridOptions read GetOptions write SetOptions;
    property Row: Longint read GetRow write SetRow;
    property RowCount: Longint read GetRowCount write SetRowCount;
    property RowHeights[Index: Longint]: Integer read GetRowHeights write SetRowHeights;
    property Rows[Index: Longint]: pStrList read GetRows write SetRows;
    property ScrollBars: TScrollStyle read GetScrollBars write SetScrollBars;
    property Selection: TGridRect read GetSelection write SetSelection;
//    property TabStops[Index: Longint]: Boolean read GetTabStops write SetTabStops;
    property TopRow: Longint read GetTopRow write SetTopRow;
    property VisibleColCount: Integer read GetVisibleColCount;
    property VisibleRowCount: Integer read GetVisibleRowCount;

    property Cells[ACol,ARow: Longint]: string read GetCells write SetCells;
  end;

  TKOLStGrd = PStGrd;

  TXorRects = array[0..3] of TRect;

const
  GridLineWidth = 1;

function NewStGrd(Sender: PControl;CCount,RCount,FCols,FRows,DefCW,DefRH: Longint; Options: TGridOptions; DefDraw,c3D,hasBrdr: Boolean; sBars: TScrollStyle): PStGrd;

function PointInGridRect(Col, Row: Longint; const Rect: TGridRect): Boolean;
procedure XorRects(const R1, R2: TRect; var XorRects: TXorRects);

implementation

uses KOLMath;

{$R Cursors.res}

const
  IDC_HSPLIT =    PChar(32765);
  IDC_VSPLIT =    PChar(32764);

{ ƒ¿ÕÕ€≈ ƒÀﬂ Õ¿ÿ≈√Œ Œ¡⁄≈ “¿ (—¬Œ…—“¬¿ » Œ¡–¿¡Œ“◊» ») }
type
  PStGrdData = ^TStGrdData;
  TStGrdData = object(TObj)
    fControl: PControl;
    //MyEvent: TMyEvent;
    fOnDrawCell: TDrawCellEvent;
    fOnSelectCell: TSelectCellEvent;
    
    fAnchor: TGridCoord;
    fColCount: Longint;
    fColWidths: Pointer;
    fCtl3D: Boolean;
//    fTabStops: Pointer;
    fCurrent: TGridCoord;
    fDefaultColWidth: Integer;
    fDefaultRowHeight: Integer;
    fFixedCols: Integer;
    fFixedRows: Integer;
    fOptions: TGridOptions;
    fRowCount: Longint;
    fRowHeights: Pointer;
    fScrollBars: TScrollStyle;
    fTopLeft: TGridCoord;
    fSizingIndex: Longint;
    fSizingPos, fSizingOfs: Integer;
    fMoveIndex, fMovePos: Longint;
    fHitTest: TPoint;
    fColOffset: Integer;
    fDefaultDrawing: Boolean;
    fGridState: TGridState;
    fSaveCellExtents: Boolean;

    fCells: Pointer;

    destructor Destroy; virtual;
  end;

{ Allocate a section and set all its items to nil. Returns: Pointer to start of
  section. }
function  MakeSec(SecIndex: Integer; SectionSize: Word): Pointer;
var
  SecP: Pointer;
  Size: Word;
begin
  Size := SectionSize * SizeOf(Pointer);
  GetMem(secP, size);
  FillChar(secP^, size, 0);
  MakeSec := SecP
end;


function GridRect(Coord1, Coord2: TGridCoord): TGridRect;
begin
  with Result do
  begin
    Left := Coord2.X;
    if Coord1.X < Coord2.X then Left := Coord1.X;
    Right := Coord1.X;
    if Coord1.X < Coord2.X then Right := Coord2.X;
    Top := Coord2.Y;
    if Coord1.Y < Coord2.Y then Top := Coord1.Y;
    Bottom := Coord1.Y;
    if Coord1.Y < Coord2.Y then Bottom := Coord2.Y;
  end;
end;

function PointInGridRect(Col, Row: Longint; const Rect: TGridRect): Boolean;
begin
  Result := (Col >= Rect.Left) and (Col <= Rect.Right) and (Row >= Rect.Top)
    and (Row <= Rect.Bottom);
end;

procedure XorRects(const R1, R2: TRect; var XorRects: TXorRects);
var
  Intersect, Union: TRect;

  function PtInRect(X, Y: Integer; const Rect: TRect): Boolean;
  begin
    with Rect do Result := (X >= Left) and (X <= Right) and (Y >= Top) and
      (Y <= Bottom);
  end;

  function Includes(const P1: TPoint; var P2: TPoint): Boolean;
  begin
    with P1 do
    begin
      Result := PtInRect(X, Y, R1) or PtInRect(X, Y, R2);
      if Result then P2 := P1;
    end;
  end;

  function Build(var R: TRect; const P1, P2, P3: TPoint): Boolean;
  begin
    Build := True;
    with R do
      if Includes(P1, TopLeft) then
      begin
        if not Includes(P3, BottomRight) then BottomRight := P2;
      end
      else if Includes(P2, TopLeft) then BottomRight := P3
      else Build := False;
  end;

begin
  FillChar(XorRects, SizeOf(XorRects), 0);
  if not Bool(IntersectRect(Intersect, R1, R2)) then
  begin
    { Don't intersect so its simple }
    XorRects[0] := R1;
    XorRects[1] := R2;
  end
  else
  begin
    UnionRect(Union, R1, R2);
    if Build(XorRects[0],
      MakePoint(Union.Left, Union.Top),
      MakePoint(Union.Left, Intersect.Top),
      MakePoint(Union.Left, Intersect.Bottom)) then
      XorRects[0].Right := Intersect.Left;
    if Build(XorRects[1],
      MakePoint(Intersect.Left, Union.Top),
      MakePoint(Intersect.Right, Union.Top),
      MakePoint(Union.Right, Union.Top)) then
      XorRects[1].Bottom := Intersect.Top;
    if Build(XorRects[2],
      MakePoint(Union.Right, Intersect.Top),
      MakePoint(Union.Right, Intersect.Bottom),
      MakePoint(Union.Right, Union.Bottom)) then
      XorRects[2].Left := Intersect.Right;
    if Build(XorRects[3],
      MakePoint(Union.Left, Union.Bottom),
      MakePoint(Intersect.Left, Union.Bottom),
      MakePoint(Intersect.Right, Union.Bottom)) then
      XorRects[3].Top := Intersect.Bottom;
  end;
end;

procedure ModifyExtents(var Extents: Pointer; Index, Amount: Longint;
  Default: Integer);
var
  LongSize, OldSize: LongInt;
  NewSize: Integer;
  I: Integer;
begin
  if Amount <> 0 then
  begin
    if not Assigned(Extents)
      then OldSize := 0
      else OldSize := PIntArray(Extents)^[0];
    if (Index < 0) or (OldSize < Index) then exit;//InvalidOp(SIndexOutOfRange);
    LongSize := OldSize + Amount;
    if LongSize < 0
      then exit//InvalidOp(STooManyDeleted)
      else if LongSize >= MaxCustomExtents - 1 then exit;//InvalidOp(SGridTooLarge);
    NewSize := Cardinal(LongSize);
    if NewSize > 0 then Inc(NewSize);
    ReallocMem(Extents, NewSize * SizeOf(Integer));
    if Assigned(Extents) then begin
      I := Index + 1;
      while I < NewSize do begin
        PIntArray(Extents)^[I] := Default;
        Inc(I);
      end;
      PIntArray(Extents)^[0] := NewSize-1;
    end;
  end;
end;

procedure UpdateExtents(var Extents: Pointer; NewSize: Longint;
  Default: Integer);
var
  OldSize: Integer;
begin
  OldSize := 0;
  if Assigned(Extents) then OldSize := PIntArray(Extents)^[0];
  ModifyExtents(Extents, OldSize, NewSize - OldSize, Default);
end;

procedure MoveExtent(var Extents: Pointer; FromIndex, ToIndex: Longint);
var
  Extent: Integer;
begin
  if Assigned(Extents) then
  begin
    Extent := PIntArray(Extents)^[FromIndex];
    if FromIndex < ToIndex then
      Move(PIntArray(Extents)^[FromIndex + 1], PIntArray(Extents)^[FromIndex],
        (ToIndex - FromIndex) * SizeOf(Integer))
    else if FromIndex > ToIndex then
      Move(PIntArray(Extents)^[ToIndex], PIntArray(Extents)^[ToIndex + 1],
        (FromIndex - ToIndex) * SizeOf(Integer));
    PIntArray(Extents)^[ToIndex] := Extent;
  end;
end;

function CompareExtents(E1, E2: Pointer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if E1 <> nil then
  begin
    if E2 <> nil then
    begin
      for I := 0 to PIntArray(E1)^[0] do
        if PIntArray(E1)^[I] <> PIntArray(E2)^[I] then Exit;
      Result := True;
    end
  end
  else Result := E2 = nil;
end;

function LongMulDiv(Mult1, Mult2, Div1: Longint): Longint; stdcall;
  external 'kernel32.dll' name 'MulDiv';

procedure KillMessage(Wnd: HWnd; Msg: Integer);
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, pm_Remove) and (M.Message = WM_QUIT) then
    PostQuitMessage(M.wparam);
end;

{-------------------------}
{ Destructor Õ¿ÿ»’ ƒ¿ÕÕ€’ }
{-------------------------}
destructor TStGrdData.Destroy;
var i: Longint;
begin
// All Strings := '';
// Free_And_Nil(All PObj);
  for i := fColCount-1 downto 0 do
    PStrListArray(fCells)^[i].Free;
  SetLength(PStrListArray(fCells)^,0);
  Dispose(PStrListArray(fCells));
  fCells := nil;
  inherited Destroy;
  FreeMem(fColWidths);
  FreeMem(fRowHeights);
//  FreeMem(fTabStops);
end;
////////////////////////////////////////////////////////////////////////////////

{--------------------}
{ Œ¡–¿¡Œ“◊»  Œ¡⁄≈ “¿ }
{--------------------}
function WndProcStGrd(Ctl: PControl; var Msg: TMsg; var Rslt: Integer): Boolean;
var
  S: PStGrd;
  D: PStGrdData;
  p: TPoint;
  r: TRect;
  t_dc: hDC;
//  LV: PNMLISTVIEW;
begin
  S := PStGrd(Ctl);
  D := Pointer(S.CustomObj);
  Result := False;

  with S^,Msg do case Msg.message of
    WM_KEYDOWN: KeyDown(wParam);
    WM_LBUTTONDOWN: begin MouseDown(LOWORD(lParam),HIWORD(lParam)); SetCapture(Handle); end;
    WM_LBUTTONUP: begin MouseUp(LoWord(lParam),HiWord(lParam)); ReleaseCapture; end;
    WM_MOUSEMOVE: begin
      GetCursorPos(p);
      GetWindowRect(Handle,r);
      InflateRect(r,-2,-2);
      if PtInRect(r,p) then MouseMove(LOWORD(lParam),HIWORD(lParam));
    end;
    WM_SIZE: UpdateScrollRange;
    WM_GETDLGCODE: begin
      Rslt := DLGC_WANTARROWS;
      if goRowSelect in D.fOptions then Exit;
      if goTabs in D.fOptions then Rslt := Rslt or DLGC_WANTTAB;
      if goEditing in D.fOptions then Rslt := Rslt or DLGC_WANTCHARS;
    end;
    WM_KILLFOCUS: InvalidateRect(Selection);
    WM_SETFOCUS: InvalidateRect(Selection);
    WM_NCHITTEST: D.fHitTest := Screen2Client(MakePoint(LOWORD(lParam),HIWORD(lParam)));
    WM_TIMER: WMTimer;
    WM_PAINT: begin
      t_dc := GetDC(Handle);
      Paint(t_dc);
      ReleaseDC(Handle,t_dc);
    end;
    WM_VSCROLL: ModifyScrollBar(SB_VERT, LOWORD(wParam), HIWORD(wParam), True);
    WM_HSCROLL: ModifyScrollBar(SB_HORZ, LOWORD(wParam), HIWORD(wParam), True);
    WM_MOUSEWHEEL: if smallint(HIWORD(wParam)) > 0 then WheelUp else WheelDown;
    WM_SETCURSOR: WMSetCursor(LOWORD(lParam));
    WM_CANCELMODE: CancelMode;
// ≈ÒÎË Result := TRUE, ÚÓ ‰‡Î¸¯Â ÒÓÓ·˘ÂÌËÂ ÍÓÌÚÓÎÛ ÌÂ ÔÂÂ‰‡ÂÚÒˇ.
end; { case Msg }
end;
////////////////////////////////////////////////////////////////////////////////

{-----------------------------}
{  ŒÕ—“–” “Œ– ƒÀﬂ KOL Œ¡⁄≈ “¿ }
{-----------------------------}
function NewStGrd;
var D: PStGrdData;
    i,j: Longint;
begin
  New(D, Create);

  i := WS_CHILD {or WS_CLIPCHILDREN or WS_CLIPSIBLINGS} or WS_TABSTOP or WS_VISIBLE;
  if (sBars in [ssVertical,ssBoth]) then i := i or WS_VSCROLL;
  if (sBars in [ssHorizontal,ssBoth]) then i := i or WS_HSCROLL;

  Result := PStGrd(_NewControl(Sender,'TStGrd',i,false,nil));

  Result.ExStyle := Result.ExStyle and not WS_EX_CLIENTEDGE;
  Result.Style := Result.Style and not WS_BORDER;
  if hasBrdr then
    if c3D then Result.ExStyle := Result.ExStyle or WS_EX_CLIENTEDGE
           else Result.Style := Result.Style or WS_BORDER;

  Result.CustomObj := D;
  D.fControl := Result;

  D.fDefaultColWidth := DefCW;
  D.fDefaultRowHeight := DefRH;
  D.fDefaultDrawing := DefDraw;
  D.fSaveCellExtents := True;
  D.fColCount := CCount;
  D.fRowCount := RCount;
  D.fFixedCols := FCols;
  D.fFixedRows := FRows;
  D.fTopLeft.X := D.fFixedCols;
  D.fTopLeft.Y := D.fFixedRows;
  D.fCurrent := D.fTopLeft;
  D.fAnchor := D.fCurrent;
  D.fOptions := Options;
  if goRowSelect in D.fOptions then D.fAnchor.X := D.fColCount - 1;
  D.fScrollBars := sBars;
  D.fGridState := gsNormal;
  D.fCtl3D := c3D;

  New(PStrListArray(D.fCells));//,D.fColCount*D.fRowCount*SizeOf(PAnsiString));
  SetLength(PStrListArray(D.fCells)^,D.fColCount);
  for i := 0 to D.fColCount-1 do begin
    PStrListArray(D.fCells)^[i] := NewStrList;//.Create;
    for j := 0 to D.fRowCount-1 do
      PStrListArray(D.fCells)^[i].Add('');
  end;

//  Result.TabStop := True;

// Code

{ ”ÒÚ‡ÌÓ‚Í‡ Ó·‡·ÓÚ˜ËÍÓ‚ }
  Result.AttachProc(WndProcStGrd);

{ ”ÒÚ‡ÌÓ‚Í‡ ÌÓ‚Ó„Ó Ó·‡·ÓÚ˜ËÍ‡ }
// Result.SetOnLVData(Result.OnNewLVData);
end;
////////////////////////////////////////////////////////////////////////////////

{--------------------}
{ Œ¡–¿¡Œ“◊»  MyEvent }
{--------------------}
{ procedure TStGrd.SetMyEvent;
var D: PStGrdData;
begin
D := Pointer(CustomObj);
D.MyEvent := Value;
end;

function TStGrd.GetMyEvent;
var D: PStGrdData;
begin
D := Pointer(CustomObj);
Result := D.MyEvent;
end; }

{ TStGrd }

function TStGrd.BoxRect(ALeft, ATop, ARight, ABottom: Integer): TRect;
var
  GridRect: TGridRect;
begin
  GridRect.Left := ALeft;
  GridRect.Right := ARight;
  GridRect.Top := ATop;
  GridRect.Bottom := ABottom;
  GridRectToScreenRect(GridRect, Result, False);
end;

function TStGrd.CalcCoordFromPoint(X, Y: Integer; const DrawInfo: TGridDrawInfo): TGridCoord;

  function DoCalc(const AxisInfo: TGridAxisDrawInfo; N: Integer): Integer;
  var
    I, Start, Stop: Longint;
    Line: Integer;
  begin
    with AxisInfo do
    begin
      if N < FixedBoundary then
      begin
        Start := 0;
        Stop :=  FixedCellCount - 1;
        Line := 0;
      end
      else
      begin
        Start := FirstGridCell;
        Stop := GridCellCount - 1;
        Line := FixedBoundary;
      end;
      Result := -1;
      for I := Start to Stop do
      begin
        Inc(Line, GetExtent(I) + EffectiveLineWidth);
        if N < Line then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

  function DoCalcRightToLeft(const AxisInfo: TGridAxisDrawInfo; N: Integer): Integer;
  var
    I, Start, Stop: Longint;
    Line: Integer;
  begin
    N := ClientWidth - N;
    with AxisInfo do
    begin
      if N < FixedBoundary then
      begin
        Start := 0;
        Stop :=  FixedCellCount - 1;
        Line := ClientWidth;
      end
      else
      begin
        Start := FirstGridCell;
        Stop := GridCellCount - 1;
        Line := FixedBoundary;
      end;
      Result := -1;
      for I := Start to Stop do
      begin
        Inc(Line, GetExtent(I) + EffectiveLineWidth);
        if N < Line then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

begin
//  if not UseRightToLeftAlignment then
    Result.X := DoCalc(DrawInfo.Horz, X);
//  else
//    Result.X := DoCalcRightToLeft(DrawInfo.Horz, X);
  Result.Y := DoCalc(DrawInfo.Vert, Y);
end;

procedure TStGrd.CalcDrawInfo(var DrawInfo: TGridDrawInfo);
begin
  CalcDrawInfoXY(DrawInfo, ClientWidth, ClientHeight);
end;

procedure TStGrd.CalcDrawInfoXY(var DrawInfo: TGridDrawInfo; UseWidth, UseHeight: Integer);

  procedure CalcAxis(var AxisInfo: TGridAxisDrawInfo; UseExtent: Integer);
  var I: Integer;
  begin
    with AxisInfo do begin
      GridExtent := UseExtent;
      GridBoundary := FixedBoundary;
      FullVisBoundary := FixedBoundary;
      LastFullVisibleCell := FirstGridCell;
      for I := FirstGridCell to GridCellCount - 1 do begin
        Inc(GridBoundary, GetExtent(I) + EffectiveLineWidth);
        if GridBoundary > GridExtent + EffectiveLineWidth then begin
          GridBoundary := GridExtent;
          Break;
        end;
        LastFullVisibleCell := I;
        FullVisBoundary := GridBoundary;
      end;
    end;
  end;

begin
  CalcFixedInfo(DrawInfo);
  CalcAxis(DrawInfo.Horz, UseWidth);
  CalcAxis(DrawInfo.Vert, UseHeight);
end;

procedure TStGrd.CalcFixedInfo(var DrawInfo: TGridDrawInfo);

  procedure CalcFixedAxis(var Axis: TGridAxisDrawInfo; LineOptions: TGridOptions; FixedCount, FirstCell, CellCount: Integer; GetExtentFunc: TGetExtentsFunc);
  var I: Integer;
  begin
    with Axis do begin
      if LineOptions * Options = []
        then EffectiveLineWidth := 0
        else EffectiveLineWidth := GridLineWidth;

      FixedBoundary := 0;
      for I := 0 to FixedCount - 1 do
        Inc(FixedBoundary, GetExtentFunc(I) + EffectiveLineWidth);

      FixedCellCount := FixedCount;
      FirstGridCell := FirstCell;
      GridCellCount := CellCount;
      GetExtent := GetExtentFunc;
    end;
  end;

var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  CalcFixedAxis(DrawInfo.Horz, [goFixedVertLine, goVertLine], D.fFixedCols, D.fTopLeft.X, D.fColCount, GetColWidths);
  CalcFixedAxis(DrawInfo.Vert, [goFixedHorzLine, goHorzLine], D.fFixedRows, D.fTopLeft.Y, D.fRowCount, GetRowHeights);
end;

function TStGrd.CalcMaxTopLeft(const Coord: TGridCoord; const DrawInfo: TGridDrawInfo): TGridCoord;

  function CalcMaxCell(const Axis: TGridAxisDrawInfo; Start: Integer): Integer;
  var
    Line: Integer;
    I, Extent: Longint;
  begin
    Result := Start;
    with Axis do
    begin
      Line := GridExtent + EffectiveLineWidth;
      for I := Start downto FixedCellCount do
      begin
        Extent := GetExtent(I);
        if Extent > 0 then
        begin
          Dec(Line, Extent);
          Dec(Line, EffectiveLineWidth);
          if Line < FixedBoundary then
          begin
            if (Result = Start) and (GetExtent(Start) <= 0) then
              Result := I;
            Break;
          end;
          Result := I;
        end;
      end;
    end;
  end;

begin
  Result.X := CalcMaxCell(DrawInfo.Horz, Coord.X);
  Result.Y := CalcMaxCell(DrawInfo.Vert, Coord.Y);
end;

procedure TStGrd.CalcSizingState(X, Y: Integer; var State: TGridState; var Index, SizingPos, SizingOfs: Integer; var FixedInfo: TGridDrawInfo);

  procedure CalcAxisState(const AxisInfo: TGridAxisDrawInfo; Pos: Integer; NewState: TGridState);
  var I, Line, Back, Range: Integer;
  begin
//    if (NewState = gsColSizing) and UseRightToLeftAlignment then
//      Pos := ClientWidth - Pos;
    with AxisInfo do begin
      Line := FixedBoundary;
      Range := EffectiveLineWidth;
      Back := 0;
      if Range < 7 then begin
        Range := 7;
        Back := (Range - EffectiveLineWidth) shr 1;
      end;
      for I := FirstGridCell to GridCellCount - 1 do begin
        Inc(Line, GetExtent(I));
        if Line > GridBoundary then Break;
        if (Pos >= Line - Back) and (Pos <= Line - Back + Range) then begin
          State := NewState;
          SizingPos := Line;
          SizingOfs := Line - Pos;
          Index := I;
          Exit;
        end;
        Inc(Line, EffectiveLineWidth);
      end;
      if (GridBoundary = GridExtent) and (Pos >= GridExtent - Back) and (Pos <= GridExtent) then begin
        State := NewState;
        SizingPos := GridExtent;
        SizingOfs := GridExtent - Pos;
        Index := LastFullVisibleCell + 1;
      end;
    end;
  end;

  function XOutsideHorzFixedBoundary: Boolean;
  begin
    with FixedInfo do
//      if not UseRightToLeftAlignment then
        Result := X > Horz.FixedBoundary
//      else
//        Result := X < ClientWidth - Horz.FixedBoundary;
  end;

  function XOutsideOrEqualHorzFixedBoundary: Boolean;
  begin
    with FixedInfo do
//      if not UseRightToLeftAlignment then
        Result := X >= Horz.FixedBoundary
//      else
//        Result := X <= ClientWidth - Horz.FixedBoundary;
  end;


var
  EffectiveOptions: TGridOptions;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  State := gsNormal;
  Index := -1;
  EffectiveOptions := D.fOptions;
//  if csDesigning in ComponentState then
//    EffectiveOptions := EffectiveOptions + DesignOptionsBoost;
  if [goColSizing, goRowSizing] * EffectiveOptions <> [] then
    with FixedInfo do begin
      Vert.GridExtent := ClientHeight;
      Horz.GridExtent := ClientWidth;
      if (XOutsideHorzFixedBoundary) and (goColSizing in EffectiveOptions) then begin
        if Y >= Vert.FixedBoundary then Exit;
        CalcAxisState(Horz, X, gsColSizing);
      end else if (Y > Vert.FixedBoundary) and (goRowSizing in EffectiveOptions) then begin
        if XOutsideOrEqualHorzFixedBoundary then Exit;
        CalcAxisState(Vert, Y, gsRowSizing);
      end;
    end;
end;

procedure TStGrd.CancelMode;
var
  DrawInfo: TGridDrawInfo;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  try
    case D.fGridState of
      gsSelecting:
        KillTimer(Handle, 1);
      gsRowSizing, gsColSizing:
        begin
          CalcDrawInfo(DrawInfo);
          DrawSizingLine(DrawInfo);
        end;
      gsColMoving, gsRowMoving:
        begin
          DrawMove;
          KillTimer(Handle, 1);
        end;
    end;
  finally
    D.fGridState := gsNormal;
  end;
end;

procedure TStGrd.ChangeSize(NewColCount, NewRowCount: Integer);
var
  OldColCount, OldRowCount: Longint;
  OldDrawInfo: TGridDrawInfo;
  D: PStGrdData;

  procedure MinRedraw(const OldInfo, NewInfo: TGridAxisDrawInfo; Axis: Integer);
  var
    R: TRect;
    First: Integer;
  begin
    First := Min(OldInfo.LastFullVisibleCell, NewInfo.LastFullVisibleCell);
    // Get the rectangle around the leftmost or topmost cell in the target range.
    R := BoxRect(First and not Axis, First and Axis,First and not Axis, First and Axis);
    R.Bottom := Height;
    R.Right := Width;
    Windows.InvalidateRect(Handle, @R, False);
  end;

  procedure DoChange;
  var
    Coord: TGridCoord;
    NewDrawInfo: TGridDrawInfo;
  begin
    if D.fColWidths <> nil then
      UpdateExtents(D.fColWidths, D.fColCount, D.fDefaultColWidth);
{    if D.fTabStops <> nil then
      UpdateExtents(D.fTabStops, D.fColCount, Integer(True));}
    if D.fRowHeights <> nil then
      UpdateExtents(D.fRowHeights, D.fRowCount, D.fDefaultRowHeight);
    Coord := D.fCurrent;
    if Row >= D.fRowCount then Coord.Y := D.fRowCount - 1;
    if Col >= D.fColCount then Coord.X := D.fColCount - 1;
    if (D.fCurrent.X <> Coord.X) or (D.fCurrent.Y <> Coord.Y) then
      MoveCurrent(Coord.X, Coord.Y, True, True);
    if (D.fAnchor.X <> Coord.X) or (D.fAnchor.Y <> Coord.Y) then
      MoveAnchor(Coord);
    if //VirtualView or
      (LeftCol <> OldDrawInfo.Horz.FirstGridCell) or
      (TopRow <> OldDrawInfo.Vert.FirstGridCell) then
      Invalidate//Grid
    else begin
      CalcDrawInfo(NewDrawInfo);
      MinRedraw(OldDrawInfo.Horz, NewDrawInfo.Horz, 0);
      MinRedraw(OldDrawInfo.Vert, NewDrawInfo.Vert, -1);
    end;
    UpdateScrollRange;
//    SizeChanged(OldColCount, OldRowCount);
  end;

begin
  D := Pointer(CustomObj);
  CalcDrawInfo(OldDrawInfo);
  OldColCount := D.fColCount;
  OldRowCount := D.fRowCount;
  D.fColCount := NewColCount;
  D.fRowCount := NewRowCount;
  if D.fFixedCols > NewColCount then D.fFixedCols := NewColCount - 1;
  if D.fFixedRows > NewRowCount then D.fFixedRows := NewRowCount - 1;
  try
    DoChange;
  except
    { Could not change size so try to clean up by setting the size back }
    D.fColCount := OldColCount;
    D.fRowCount := OldRowCount;
    DoChange;
    Invalidate//Grid;
//    raise;
  end;
end;

procedure TStGrd.ClampInView(const Coord: TGridCoord);
var
  DrawInfo: TGridDrawInfo;
  MaxTopLeft: TGridCoord;
  OldTopLeft: TGridCoord;
  D: PStGrdData;
begin
  CalcDrawInfo(DrawInfo);
  with DrawInfo, Coord do begin
    if (X > Horz.LastFullVisibleCell) or
      (Y > Vert.LastFullVisibleCell) or (X < LeftCol) or (Y < TopRow) then begin
      D := Pointer(CustomObj);
      OldTopLeft := d.fTopLeft;
      MaxTopLeft := CalcMaxTopLeft(Coord, DrawInfo);
      Update;
      if X < LeftCol then d.fTopLeft.X := X
      else if X > Horz.LastFullVisibleCell then d.fTopLeft.X := MaxTopLeft.X;
      if Y < TopRow then d.fTopLeft.Y := Y
      else if Y > Vert.LastFullVisibleCell then d.fTopLeft.Y := MaxTopLeft.Y;
      TopLeftMoved(OldTopLeft);
    end;
  end;
end;

procedure TStGrd.DrawCell(Cnv: PCanvas; ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if Assigned(D.fOnDrawCell) and (not D.fDefaultDrawing)
    then D.fOnDrawCell(@Self,Cnv,ACol,ARow,ARect,AState);
{    else if D.fDefaultDrawing then begin
      InflateRect(ARect,-2,-2);
      Cnv.TextRect(ARect,ARect.Left,ARect.Top,Cells[ACol,ARow]);
    end;}
end;

procedure TStGrd.DrawMove;
var
  OldPen: PGraphicTool;
  Pos: Integer;
  R: TRect;
  D: PStGrdData;
begin
  OldPen := NewPen;
  D := Pointer(CustomObj);
  try
    with Canvas^ do begin
      OldPen.Assign(Pen);
      try
        Pen.PenStyle := psDot;
        Pen.PenMode := pmXor;
        Pen.Color := $0FFFF00;
        Pen.PenWidth := 3;
        if D.fGridState = gsRowMoving then begin
          R := BoxRect(0, D.fMovePos, 0, D.fMovePos);
          if D.fMovePos > D.fMoveIndex then
            Pos := R.Bottom else
            Pos := R.Top - 1;
          MoveTo(0, Pos);
          LineTo(ClientWidth, Pos);
        end else begin
          R := BoxRect(D.fMovePos, 0, D.fMovePos, 0);
          if D.fMovePos > D.fMoveIndex
            then {if not UseRightToLeftAlignment
              then} Pos := R.Right
              //else Pos := R.Left
            else {if not UseRightToLeftAlignment
              then} Pos := R.Left - 1;
              //else Pos := R.Right;
          MoveTo(Pos, 0);
          LineTo(Pos, ClientHeight);
        end;
      finally
        Pen.Assign(OldPen);
      end;
    end;
  finally
    OldPen.Free;
  end;
end;

procedure TStGrd.DrawSizingLine(const DrawInfo: TGridDrawInfo);
var
  OldPen: PGraphicTool;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  OldPen := NewPen;
  try
    with Canvas^, DrawInfo do begin
      OldPen.Assign(Pen);
      Pen.PenStyle := psSolid;
      Pen.PenMode := pmXor;
      Pen.Color := $0FFFF00;
      Pen.PenWidth := 1;
      try
        if D.fGridState = gsRowSizing then begin
{          if UseRightToLeftAlignment then
          begin
            MoveTo(Horz.GridExtent, FSizingPos);
            LineTo(Horz.GridExtent - Horz.GridBoundary, FSizingPos);
          end
          else
          begin}
            MoveTo(0, D.fSizingPos);
            LineTo(Horz.GridBoundary, D.fSizingPos);
          //end;
        end else begin
          MoveTo(D.fSizingPos, 0);
          LineTo(D.fSizingPos, Vert.GridBoundary);
        end;
      finally
        Pen.Assign(OldPen);
      end;
    end;
  finally
    OldPen.Free;
  end;
end;

procedure TStGrd.FocusCell(ACol, ARow: Integer; _MoveAnchor: Boolean);
begin
  MoveCurrent(ACol, ARow, _MoveAnchor, True);
//  Click;
end;

function TStGrd.GetCells(ACol, ARow: Integer): string;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if (ACol < 0) or (ARow < 0) or (ACol > D.fColCount-1) or (ARow > D.fRowCount - 1) then exit;
{  if PStrArray(D.fCells)^[ACol,ARow] = nil
    then Result := ''
    else Result := PStrArray(D.fCells)^[ACol,ARow];}
  Result := PStrListArray(D.fCells)^[ACol].Items[ARow];
end;

function TStGrd.GetCol: Longint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fCurrent.X;
end;

function TStGrd.GetColCount: Longint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fColCount;
end;

function TStGrd.GetColWidths(Index: Integer): Integer;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if (D.fColWidths = nil) or (Index >= D.fColCount) then
    Result := D.fDefaultColWidth
  else
    Result := PIntArray(D.fColWidths)^[Index + 1];
end;

function TStGrd.GetDefaultColWidth: Integer;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fDefaultColWidth;
end;

function TStGrd.GetDefaultDrawing: Boolean;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fDefaultDrawing;
end;

function TStGrd.GetDefaultRowHeight: Integer;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fDefaultRowHeight;
end;

function TStGrd.GetFixedCols: Integer;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fFixedCols;
end;

function TStGrd.GetFixedRows: Integer;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fFixedRows;
end;

function TStGrd.GetGridHeight: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Vert.GridBoundary;
end;

function TStGrd.GetGridWidth: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Horz.GridBoundary;
end;

function TStGrd.GetHitTest: TPoint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fHitTest;
end;

function TStGrd.GetLeftCol: Longint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fTopLeft.X;
end;

function TStGrd.GetOnDrawCell: TDrawCellEvent;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fOnDrawCell;
end;

function TStGrd.GetOnSelectCell: TSelectCellEvent;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fOnSelectCell;
end;

function TStGrd.GetOptions: TGridOptions;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fOptions;
end;

function TStGrd.GetRow: Longint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fCurrent.Y;
end;

function TStGrd.GetRowCount: Longint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fRowCount;
end;

function TStGrd.GetRowHeights(Index: Integer): Integer;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if (d.fRowHeights = nil) or (Index >= d.fRowCount)
    then Result := D.fDefaultRowHeight
    else Result := PIntArray(d.fRowHeights)^[Index + 1];
end;

function TStGrd.GetRows(Index: Integer): pStrList;
var D: PStGrdData;
    i: Longint;
begin
  Result := NewStrList;
  D := Pointer(CustomObj);
  for i := 0 to D.fColCount-1 do
    Result.Add(PStrListArray(D.fCells)^[i].Items[Index])
end;

function TStGrd.GetScrollBars: TScrollStyle;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fScrollBars;
end;

function TStGrd.GetSelection: TGridRect;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := GridRect(D.fCurrent, D.fAnchor);
end;
{
function TStGrd.GetTabStops(Index: Integer): Boolean;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if D.fTabStops = nil then Result := True
  else Result := Boolean(PIntArray(D.fTabStops)^[Index + 1]);
end;
}
function TStGrd.GetTopRow: Longint;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := D.fTopLeft.Y;
end;

function TStGrd.GetVisibleColCount: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Horz.LastFullVisibleCell - LeftCol + 1;
end;

function TStGrd.GetVisibleRowCount: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Vert.LastFullVisibleCell - TopRow + 1;
end;

procedure TStGrd.GridRectToScreenRect(GridRect: TGridRect; var ScreenRect: TRect; IncludeLine: Boolean);

  function LinePos(const AxisInfo: TGridAxisDrawInfo; Line: Integer): Integer;
  var
    Start, I: Longint;
  begin
    with AxisInfo do begin
      Result := 0;
      if Line < FixedCellCount
        then Start := 0
        else begin
          if Line >= FirstGridCell then
            Result := FixedBoundary;
          Start := FirstGridCell;
        end;
      for I := Start to Line - 1 do begin
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
        if Result > GridExtent then begin
          Result := 0;
          Exit;
        end;
      end;
    end;
  end;

  function CalcAxis(const AxisInfo: TGridAxisDrawInfo;
    GridRectMin, GridRectMax: Integer;
    var ScreenRectMin, ScreenRectMax: Integer): Boolean;
  begin
    Result := False;
    with AxisInfo do begin
      if (GridRectMin >= FixedCellCount) and (GridRectMin < FirstGridCell) then
        if GridRectMax < FirstGridCell then begin
          FillChar(ScreenRect, SizeOf(ScreenRect), 0); { erase partial results }
          Exit;
        end else
          GridRectMin := FirstGridCell;
      if GridRectMax > LastFullVisibleCell then begin
        GridRectMax := LastFullVisibleCell;
        if GridRectMax < GridCellCount - 1 then Inc(GridRectMax);
        if LinePos(AxisInfo, GridRectMax) = 0 then
          Dec(GridRectMax);
      end;

      ScreenRectMin := LinePos(AxisInfo, GridRectMin);
      ScreenRectMax := LinePos(AxisInfo, GridRectMax);
      if ScreenRectMax = 0
        then ScreenRectMax := ScreenRectMin + GetExtent(GridRectMin)
        else Inc(ScreenRectMax, GetExtent(GridRectMax));
      if ScreenRectMax > GridExtent then ScreenRectMax := GridExtent;
      if IncludeLine then Inc(ScreenRectMax, EffectiveLineWidth);
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
//  Hold: Integer;
begin
  FillChar(ScreenRect, SizeOf(ScreenRect), 0);
  if (GridRect.Left > GridRect.Right) or (GridRect.Top > GridRect.Bottom) then Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do begin
    if GridRect.Left > Horz.LastFullVisibleCell + 1 then Exit;
    if GridRect.Top > Vert.LastFullVisibleCell + 1 then Exit;

    if CalcAxis(Horz, GridRect.Left, GridRect.Right, ScreenRect.Left, ScreenRect.Right) then
       CalcAxis(Vert, GridRect.Top, GridRect.Bottom, ScreenRect.Top, ScreenRect.Bottom);
  end;

{  if UseRightToLeftAlignment and (Canvas.CanvasOrientation = coLeftToRight) then
  begin
    Hold := ScreenRect.Left;
    ScreenRect.Left := ClientWidth - ScreenRect.Right;
    ScreenRect.Right := ClientWidth - Hold;
  end;}
end;

procedure TStGrd.InvalidateCell(ACol, ARow: Integer);
var
  Rect: TGridRect;
begin
  Rect.Top := ARow;
  Rect.Left := ACol;
  Rect.Bottom := ARow;
  Rect.Right := ACol;
  InvalidateRect(Rect);
end;

procedure TStGrd.InvalidateRect(ARect: TGridRect);
var
  InvalidRect: TRect;
begin
  GridRectToScreenRect(ARect, InvalidRect, True);
  Windows.InvalidateRect(Handle, @InvalidRect, False);
end;

function TStGrd.IsActiveControl: Boolean;
var
  H: Hwnd;
  PForm: PControl;
begin
  Result := False;
  PForm := ParentForm;
  if Assigned(PForm) then begin
    if (PForm.ActiveControl = @Self) then
      Result := True
  end else begin
    H := GetFocus;
    while IsWindow(H) and (Result = False) do begin
      if H = PForm.Handle
        then Result := True
        else H := GetParent(H);
    end;
  end;
end;

procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI
end;

function StackAlloc(Size: Integer): Pointer; register;
asm
  POP   ECX          { return address }
  MOV   EDX, ESP
  ADD   EAX, 3
  AND   EAX, not 3   // round up to keep ESP dword aligned
  CMP   EAX, 4092
  JLE   @@2
@@1:
  SUB   ESP, 4092
  PUSH  EAX          { make sure we touch guard page, to grow stack }
  SUB   EAX, 4096
  JNS   @@1
  ADD   EAX, 4096
@@2:
  SUB   ESP, EAX
  MOV   EAX, ESP     { function result = low memory address of block }
  PUSH  EDX          { save original SP, for cleanup }
  MOV   EDX, ESP
  SUB   EDX, 4
  PUSH  EDX          { save current SP, for sanity check  (sp = [sp]) }
  PUSH  ECX          { return to caller }
end;

procedure StackFree(P: Pointer); register;
asm
  POP   ECX                     { return address }
  MOV   EDX, DWORD PTR [ESP]
  SUB   EAX, 8
  CMP   EDX, ESP                { sanity check #1 (SP = [SP]) }
  JNE   @@1
  CMP   EDX, EAX                { sanity check #2 (P = this stack block) }
  JNE   @@1
  MOV   ESP, DWORD PTR [ESP+4]  { restore previous SP  }
@@1:
  PUSH  ECX                     { return to caller }
end;

procedure TStGrd.KeyDown(var Key: Integer);
var
  NewTopLeft, NewCurrent, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  PageWidth, PageHeight: Integer;
//  RTLFactor: Integer;
//  NeedsInvalidating: Boolean;
  D: PStGrdData;

  procedure CalcPageExtents;
  begin
    CalcDrawInfo(DrawInfo);
    PageWidth := DrawInfo.Horz.LastFullVisibleCell - LeftCol;
    if PageWidth < 1 then PageWidth := 1;
    PageHeight := DrawInfo.Vert.LastFullVisibleCell - TopRow;
    if PageHeight < 1 then PageHeight := 1;
  end;

  procedure Restrict(var Coord: TGridCoord; MinX, MinY, MaxX, MaxY: Longint);
  begin
    with Coord do
    begin
      if X > MaxX then X := MaxX
      else if X < MinX then X := MinX;
      if Y > MaxY then Y := MaxY
      else if Y < MinY then Y := MinY;
    end;
  end;

begin
  D := Pointer(CustomObj);
//  NeedsInvalidating := False;
//  if not CanGridAcceptKey(Key, Shift) then Key := 0;
{  if not UseRightToLeftAlignment then
    RTLFactor := 1
  else
    RTLFactor := -1;}
  NewCurrent := D.fCurrent;
  NewTopLeft := D.fTopLeft;
  CalcPageExtents;
  if (GetAsyncKeyState(vk_Control) < 0) then //ssCtrl in Shift then
    case Key of
      VK_UP: Dec(NewTopLeft.Y);
      VK_DOWN: Inc(NewTopLeft.Y);
      VK_LEFT:
        if not (goRowSelect in Options) then
        begin
          Dec(NewCurrent.X, PageWidth);
          Dec(NewTopLeft.X, PageWidth);
        end;
      VK_RIGHT:
        if not (goRowSelect in Options) then
        begin
          Inc(NewCurrent.X, PageWidth);
          Inc(NewTopLeft.X, PageWidth);
        end;
      VK_PRIOR: NewCurrent.Y := TopRow;
      VK_NEXT: NewCurrent.Y := DrawInfo.Vert.LastFullVisibleCell;
      VK_HOME:
        begin
          NewCurrent.X := FixedCols;
          NewCurrent.Y := FixedRows;
        end;
      VK_END:
        begin
          NewCurrent.X := ColCount - 1;
          NewCurrent.Y := RowCount - 1;
        end;
    end
  else
    case Key of
      VK_UP: Dec(NewCurrent.Y);
      VK_DOWN: Inc(NewCurrent.Y);
      VK_LEFT:
        if goRowSelect in D.fOptions then
          Dec(NewCurrent.Y) else
          Dec(NewCurrent.X);
      VK_RIGHT:
        if goRowSelect in D.fOptions then
          Inc(NewCurrent.Y) else
          Inc(NewCurrent.X);
      VK_NEXT:
        begin
          Inc(NewCurrent.Y, PageHeight);
          Inc(NewTopLeft.Y, PageHeight);
        end;
      VK_PRIOR:
        begin
          Dec(NewCurrent.Y, PageHeight);
          Dec(NewTopLeft.Y, PageHeight);
        end;
      VK_HOME:
        if goRowSelect in D.fOptions then
          NewCurrent.Y := D.fFixedRows else
          NewCurrent.X := D.fFixedCols;
      VK_END:
        if goRowSelect in D.fOptions then
          NewCurrent.Y := D.fRowCount - 1 else
          NewCurrent.X := D.fColCount - 1;
{      VK_TAB:
        if not (ssAlt in Shift) then
        repeat
          if ssShift in Shift then
          begin
            Dec(NewCurrent.X);
            if NewCurrent.X < FixedCols then
            begin
              NewCurrent.X := ColCount - 1;
              Dec(NewCurrent.Y);
              if NewCurrent.Y < FixedRows then NewCurrent.Y := RowCount - 1;
            end;
            Shift := [];
          end
          else
          begin
            Inc(NewCurrent.X);
            if NewCurrent.X >= D.fColCount then
            begin
              NewCurrent.X := D.fFixedCols;
              Inc(NewCurrent.Y);
              if NewCurrent.Y >= RowCount then NewCurrent.Y := D.fFixedRows;
            end;
          end;
        until TabStops[NewCurrent.X] or (NewCurrent.X = D.fCurrent.X);}
//      VK_F2: EditorMode := True;
    end;
  MaxTopLeft.X := D.fColCount - 1;
  MaxTopLeft.Y := D.fRowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  Restrict(NewTopLeft, D.fFixedCols, D.fFixedRows, MaxTopLeft.X, MaxTopLeft.Y);
  if (NewTopLeft.X <> LeftCol) or (NewTopLeft.Y <> TopRow) then
    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
  Restrict(NewCurrent, D.fFixedCols, D.fFixedRows, D.fColCount - 1, D.fRowCount - 1);
  if (NewCurrent.X <> D.fCurrent.X) or (NewCurrent.Y <> D.fCurrent.Y) then
    FocusCell(NewCurrent.X, NewCurrent.Y, not (GetAsyncKeyState(vk_Shift) < 0){(ssShift in Shift)});
//  if NeedsInvalidating then Invalidate;
end;

procedure TStGrd.ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal; UseRightToLeft: Boolean);
var
  NewTopLeft, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
//  RTLFactor: Integer;
  D: PStGrdData;

  function Min: Longint;
  begin
    if ScrollBar = SB_HORZ then Result := FixedCols
    else Result := FixedRows;
  end;

  function Max: Longint;
  begin
    if ScrollBar = SB_HORZ then Result := MaxTopLeft.X
    else Result := MaxTopLeft.Y;
  end;

  function PageUp: Longint;
  var
    MaxTopLeft: TGridCoord;
  begin
    MaxTopLeft := CalcMaxTopLeft(D.fTopLeft, DrawInfo);
    if ScrollBar = SB_HORZ then
      Result := D.fTopLeft.X - MaxTopLeft.X else
      Result := D.fTopLeft.Y - MaxTopLeft.Y;
    if Result < 1 then Result := 1;
  end;

  function PageDown: Longint;
  var
    DrawInfo: TGridDrawInfo;
  begin
    CalcDrawInfo(DrawInfo);
    with DrawInfo do
      if ScrollBar = SB_HORZ then
        Result := Horz.LastFullVisibleCell - D.fTopLeft.X else
        Result := Vert.LastFullVisibleCell - D.fTopLeft.Y;
    if Result < 1 then Result := 1;
  end;

  function CalcScrollBar(Value{, ARTLFactor}: Longint): Longint;
  begin
    Result := Value;
    case ScrollCode of
      SB_LINEUP:
        Dec(Result{, ARTLFactor});
      SB_LINEDOWN:
        Inc(Result{, ARTLFactor});
      SB_PAGEUP:
        Dec(Result, PageUp{ * ARTLFactor});
      SB_PAGEDOWN:
        Inc(Result, PageDown{ * ARTLFactor});
      SB_THUMBPOSITION, SB_THUMBTRACK:
        if (goThumbTracking in Options) or (ScrollCode = SB_THUMBPOSITION) then
        begin
//          if (not UseRightToLeftAlignment) or (ARTLFactor = 1) then
            Result := Min + LongMulDiv(Pos, Max - Min, MaxShortInt)
//          else
//            Result := Max - LongMulDiv(Pos, Max - Min, MaxShortInt);
        end;
      SB_BOTTOM:
        Result := Max;
      SB_TOP:
        Result := Min;
    end;
  end;

  procedure ModifyPixelScrollBar(Code, Pos: Cardinal);
  var
    NewOffset: Integer;
    OldOffset: Integer;
    R: TGridRect;
    GridSpace, ColWidth: Integer;
  begin
    NewOffset := D.fColOffset;
    ColWidth := ColWidths[DrawInfo.Horz.FirstGridCell];
    GridSpace := ClientWidth - DrawInfo.Horz.FixedBoundary;
    case Code of
      SB_LINEUP: Dec(NewOffset, Canvas.TextWidth('0') {* RTLFactor});
      SB_LINEDOWN: Inc(NewOffset, Canvas.TextWidth('0') {* RTLFactor});
      SB_PAGEUP: Dec(NewOffset, GridSpace {* RTLFactor});
      SB_PAGEDOWN: Inc(NewOffset, GridSpace {* RTLFactor});
      SB_THUMBPOSITION,
      SB_THUMBTRACK:
        if (goThumbTracking in Options) or (Code = SB_THUMBPOSITION) then
//        begin
//          if not UseRightToLeftAlignment then
            NewOffset := Pos;
//          else
//            NewOffset := Max - Integer(Pos);
//        end;
      SB_BOTTOM: NewOffset := 0;
      SB_TOP: NewOffset := ColWidth - GridSpace;
    end;
    if NewOffset < 0 then
      NewOffset := 0
    else if NewOffset >= ColWidth - GridSpace then
      NewOffset := ColWidth - GridSpace;
    if NewOffset <> D.fColOffset then
    begin
      OldOffset := D.fColOffset;
      D.fColOffset := NewOffset;
      ScrollData(OldOffset - NewOffset, 0);
      FillChar(R, SizeOf(R), 0);
      R.Bottom := FixedRows;
      InvalidateRect(R);
      Update;
      UpdateScrollPos;
    end;
  end;

var
  Temp: Longint;
begin
  D := Pointer(CustomObj);
//  if (not UseRightToLeftAlignment) or (not UseRightToLeft) then
//    RTLFactor := 1
//  else
//    RTLFactor := -1;
  if Visible and {CanFocus and} TabStop {and not (csDesigning in ComponentState)} then
    SetFocused(True);
  CalcDrawInfo(DrawInfo);
  if (ScrollBar = SB_HORZ) and (ColCount = 1) then
  begin
    ModifyPixelScrollBar(ScrollCode, Pos);
    Exit;
  end;
  MaxTopLeft.X := ColCount - 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  NewTopLeft := D.fTopLeft;
  if ScrollBar = SB_HORZ then
    repeat
      Temp := NewTopLeft.X;
      NewTopLeft.X := CalcScrollBar(NewTopLeft.X{, RTLFactor});
    until (NewTopLeft.X <= D.fFixedCols) or (NewTopLeft.X >= MaxTopLeft.X)
      or (ColWidths[NewTopLeft.X] > 0) or (Temp = NewTopLeft.X)
  else
    repeat
      Temp := NewTopLeft.Y;
      NewTopLeft.Y := CalcScrollBar(NewTopLeft.Y{, 1});
    until (NewTopLeft.Y <= D.fFixedRows) or (NewTopLeft.Y >= MaxTopLeft.Y)
      or (RowHeights[NewTopLeft.Y] > 0) or (Temp = NewTopLeft.Y);
  NewTopLeft.X := KOLMath.Max(D.fFixedCols, KOLMath.Min(MaxTopLeft.X, NewTopLeft.X));
  NewTopLeft.Y := KOLMath.Max(D.fFixedRows, KOLMath.Min(MaxTopLeft.Y, NewTopLeft.Y));
  if (NewTopLeft.X <> D.fTopLeft.X) or (NewTopLeft.Y <> D.fTopLeft.Y) then
    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
end;

procedure TStGrd.MouseDown(X, Y: Integer);
var
  CellHit: TGridCoord;
  DrawInfo: TGridDrawInfo;
//  MoveDrawn: Boolean;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
//  MoveDrawn := False;
//  HideEdit;
//  if not (csDesigning in ComponentState) and
//    (CanFocus or (GetParentForm(Self) = nil)) then
//  begin
    SetFocused(True);
//    if not IsActiveControl then
//    begin
//      MouseCapture := False;
//      Exit;
//    end;
//  end;
//  if (Button = mbLeft) and (ssDouble in Shift) then
//    DblClick
//  else if Button = mbLeft then
  begin
    CalcDrawInfo(DrawInfo);
    { Check grid sizing }
    CalcSizingState(X, Y, D.fGridState, D.fSizingIndex, D.fSizingPos, D.fSizingOfs, DrawInfo);
    if D.fGridState <> gsNormal then
    begin
//      if (D.fGridState = gsColSizing) and UseRightToLeftAlignment then
//        FSizingPos := ClientWidth - FSizingPos;
      DrawSizingLine(DrawInfo);
      Exit;
    end;
    CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
    if (CellHit.X >= D.fFixedCols) and (CellHit.Y >= D.fFixedRows) then begin
      if goEditing in Options then begin
        if (CellHit.X = D.fCurrent.X) and (CellHit.Y = D.fCurrent.Y) then
//          ShowEditor
        else begin
          MoveCurrent(CellHit.X, CellHit.Y, True, True);
//          UpdateEdit;
        end;
//        Click;
      end else begin
        D.fGridState := gsSelecting;
        SetTimer(Handle, 1, 60, nil);
        if (GetAsyncKeyState(vk_Shift) < 0) then
          MoveAnchor(CellHit)
        else
          MoveCurrent(CellHit.X, CellHit.Y, True, True);
      end;
    end else if (goRowMoving in D.fOptions) and (CellHit.X >= 0) and
      (CellHit.X < D.fFixedCols) and (CellHit.Y >= D.fFixedRows) then begin
      D.fMoveIndex := CellHit.Y;
      D.fMovePos := D.fMoveIndex;
//      if BeginRowDrag(FMoveIndex, FMovePos, Point(X,Y)) then
      begin
        D.fGridState := gsRowMoving;
        Update;
        DrawMove;
//        MoveDrawn := True;
        SetTimer(Handle, 1, 60, nil);
      end;
    end else if (goColMoving in D.fOptions) and (CellHit.Y >= 0) and
      (CellHit.Y < D.fFixedRows) and (CellHit.X >= D.fFixedCols) then begin
      D.fMoveIndex := CellHit.X;
      D.fMovePos := D.fMoveIndex;
//      if BeginColumnDrag(FMoveIndex, FMovePos, Point(X,Y)) then
//      begin
        D.fGridState := gsColMoving;
        Update;
        DrawMove;
//        MoveDrawn := True;
        SetTimer(Handle, 1, 60, nil);
//      end;
    end;
  end;
//  try
//    inherited MouseDown(Button, Shift, X, Y);
//  except
//    if MoveDrawn then DrawMove;
//  end;
end;

procedure TStGrd.MouseMove(X, Y: Integer);
var
  DrawInfo: TGridDrawInfo;
  CellHit: TGridCoord;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  CalcDrawInfo(DrawInfo);
  case D.fGridState of
    gsSelecting, gsColMoving, gsRowMoving:
      begin
        CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
        if (CellHit.X >= D.fFixedCols) and (CellHit.Y >= D.fFixedRows) and
          (CellHit.X <= DrawInfo.Horz.LastFullVisibleCell+1) and
          (CellHit.Y <= DrawInfo.Vert.LastFullVisibleCell+1) then
          case D.fGridState of
            gsSelecting:
              if ((CellHit.X <> D.fAnchor.X) or (CellHit.Y <> D.fAnchor.Y)) then
                MoveAnchor(CellHit);
            gsColMoving:
              MoveAndScroll(X, CellHit.X, DrawInfo, DrawInfo.Horz, SB_HORZ, MakePoint(X,Y));
            gsRowMoving:
              MoveAndScroll(Y, CellHit.Y, DrawInfo, DrawInfo.Vert, SB_VERT, MakePoint(X,Y));
          end;
      end;
    gsRowSizing, gsColSizing:
      begin
        DrawSizingLine(DrawInfo); { XOR it out }
        if D.fGridState = gsRowSizing then
          D.fSizingPos := Y + D.fSizingOfs else
          D.fSizingPos := X + D.fSizingOfs;
        DrawSizingLine(DrawInfo); { XOR it back in }
      end;
  end;
//  inherited MouseMove(Shift, X, Y);
end;

procedure TStGrd.MouseUp(X, Y: Integer);
var
  DrawInfo: TGridDrawInfo;
  NewSize: Integer;
  D: PStGrdData;

  function ResizeLine(const AxisInfo: TGridAxisDrawInfo): Integer;
  var
    I: Integer;
  begin
    with AxisInfo do
    begin
      Result := FixedBoundary;
      for I := FirstGridCell to D.fSizingIndex - 1 do
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
      Result := D.fSizingPos - Result;
    end;
  end;

begin
  D := Pointer(CustomObj);
  try
    case D.fGridState of
      gsSelecting:
        begin
          MouseMove({Shift,} X, Y);
          KillTimer(Handle, 1);
//          UpdateEdit;
          if Assigned(OnClick) then OnClick(@self);
        end;
      gsRowSizing, gsColSizing:
        begin
          CalcDrawInfo(DrawInfo);
          DrawSizingLine(DrawInfo);
//          if (D.fGridState = gsColSizing) and UseRightToLeftAlignment then
//            D.fSizingPos := ClientWidth - D.fSizingPos;
          if D.fGridState = gsColSizing then begin
            NewSize := ResizeLine(DrawInfo.Horz);
            if (NewSize > 1) then ColWidths[D.fSizingIndex] := NewSize;
          end else begin
            NewSize := ResizeLine(DrawInfo.Vert);
            if (NewSize > 1) then RowHeights[D.fSizingIndex] := NewSize;
          end;
        end;
      gsColMoving:
        begin
          DrawMove;
          KillTimer(Handle, 1);
          if //EndColumnDrag(FMoveIndex, FMovePos, Point(X,Y)) and
            (D.fMoveIndex <> D.fMovePos) then
          begin
            MoveColumn(D.fMoveIndex, D.fMovePos);
//            UpdateDesigner;
          end;
//          UpdateEdit;
        end;
      gsRowMoving:
        begin
          DrawMove;
          KillTimer(Handle, 1);
          if //EndRowDrag(FMoveIndex, FMovePos, Point(X,Y)) and 
            (D.fMoveIndex <> D.fMovePos) then
          begin
            MoveRow(D.fMoveIndex, D.fMovePos);
//            UpdateDesigner;
          end;
//          UpdateEdit;
        end;
    else
//      UpdateEdit;
    end;
//    inherited MouseUp(Button, Shift, X, Y);
  finally
    D.fGridState := gsNormal;
  end;
//  invalidate;
end;

procedure TStGrd.MoveAdjust(var CellPos: Integer; FromIndex, ToIndex: Integer);
var
  Min, Max: Longint;
begin
  if CellPos = FromIndex then CellPos := ToIndex
  else
  begin
    Min := FromIndex;
    Max := ToIndex;
    if FromIndex > ToIndex then
    begin
      Min := ToIndex;
      Max := FromIndex;
    end;
    if (CellPos >= Min) and (CellPos <= Max) then
      if FromIndex > ToIndex then
        Inc(CellPos) else
        Dec(CellPos);
  end;
end;

procedure TStGrd.MoveAnchor(const NewAnchor: TGridCoord);
var
  OldSel: TGridRect;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if [goRangeSelect, goEditing] * D.fOptions = [goRangeSelect] then begin
    OldSel := Selection;
    D.fAnchor := NewAnchor;
    if goRowSelect in D.fOptions then D.fAnchor.X := D.fColCount - 1;
    ClampInView(NewAnchor);
    SelectionMoved(OldSel);
  end
  else MoveCurrent(NewAnchor.X, NewAnchor.Y, True, True);
end;

procedure TStGrd.MoveAndScroll(Mouse, CellHit: Integer; var DrawInfo: TGridDrawInfo;
  var Axis: TGridAxisDrawInfo; Scrollbar: Integer; const MousePt: TPoint);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
//  if UseRightToLeftAlignment and (ScrollBar = SB_HORZ) then
//    Mouse := ClientWidth - Mouse;
  if (CellHit <> D.fMovePos) and
    not((D.fMovePos = Axis.FixedCellCount) and (Mouse < Axis.FixedBoundary)) and
    not((D.fMovePos = Axis.GridCellCount-1) and (Mouse > Axis.GridBoundary)) then
  begin
    DrawMove;
    if (Mouse < Axis.FixedBoundary) then
    begin
      if (D.fMovePos > Axis.FixedCellCount) then
      begin
        ModifyScrollbar(ScrollBar, SB_LINEUP, 0, False);
        Update;
        CalcDrawInfo(DrawInfo);
      end;
      CellHit := Axis.FirstGridCell;
    end
    else if (Mouse >= Axis.FullVisBoundary) then
    begin
      if (D.fMovePos = Axis.LastFullVisibleCell) and
        (D.fMovePos < Axis.GridCellCount -1) then
      begin
        ModifyScrollBar(Scrollbar, SB_LINEDOWN, 0, False);
        Update;
        CalcDrawInfo(DrawInfo);
      end;
      CellHit := Axis.LastFullVisibleCell;
    end
    else if CellHit < 0 then CellHit := D.fMovePos;
    if {(}(D.fGridState = gsColMoving) {and CheckColumnDrag(D.fMoveIndex, CellHit, MousePt))}
      or {(}(D.fGridState = gsRowMoving) {and CheckRowDrag(D.fMoveIndex, CellHit, MousePt))} then
      D.fMovePos := CellHit;
    DrawMove;
  end;
end;

procedure TStGrd.MoveColumn(FromIndex, ToIndex: Integer);
var
  Rect: TGridRect;
  D: PStGrdData;
  S: PStrList;
  i: Longint;
begin
  if FromIndex = ToIndex then Exit;
  D := Pointer(CustomObj);
  if Assigned(D.fColWidths) then
  begin
    MoveExtent(D.fColWidths, FromIndex + 1, ToIndex + 1);
//    MoveExtent(D.fTabStops, FromIndex + 1, ToIndex + 1);
  end;
  MoveAdjust(D.fCurrent.X, FromIndex, ToIndex);
  MoveAdjust(D.fAnchor.X, FromIndex, ToIndex);
//  MoveAdjust(FInplaceCol, FromIndex, ToIndex);
  Rect.Top := 0;
  Rect.Bottom := VisibleRowCount;
  if FromIndex < ToIndex then
  begin
    Rect.Left := FromIndex;
    Rect.Right := ToIndex;
  end
  else
  begin
    Rect.Left := ToIndex;
    Rect.Right := FromIndex;
  end;

  S := NewStrList;
  S.Assign(PStrListArray(D.fCells)^[FromIndex]);
  if FromIndex < ToIndex
    then for i := FromIndex to ToIndex-1 do PStrListArray(D.fCells)^[i].Assign(PStrListArray(D.fCells)^[i+1])
    else for i := FromIndex downto ToIndex+1 do PStrListArray(D.fCells)^[i].Assign(PStrListArray(D.fCells)^[i-1]);
  PStrListArray(D.fCells)^[ToIndex].Assign(S);
  S.Free;

  InvalidateRect(Rect);
//  ColumnMoved(FromIndex, ToIndex);
  if Assigned(D.fColWidths) then
    UpdateScrollRange;//ColWidthsChanged;
//  UpdateEdit;
end;

procedure TStGrd.MoveCurrent(ACol, ARow: Integer; _MoveAnchor, _Show: Boolean);
var
  OldSel: TGridRect;
  OldCurrent: TGridCoord;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if (ACol < 0) or (ARow < 0) or (ACol >= d.fColCount) or (ARow >= d.fRowCount) then
    exit;//InvalidOp(SIndexOutOfRange);
  if SelectCell(ACol, ARow) then begin
    OldSel := Selection;
    OldCurrent := d.fCurrent;
    d.fCurrent.X := ACol;
    d.fCurrent.Y := ARow;
//    if not (goAlwaysShowEditor in d.fOptions) then HideEditor;
    if _MoveAnchor or not (goRangeSelect in d.fOptions) then begin
      d.fAnchor := d.fCurrent;
      if goRowSelect in d.fOptions then d.fAnchor.X := d.fColCount - 1;
    end;
    if goRowSelect in d.fOptions then d.fCurrent.X := d.fFixedCols;
    if _Show then ClampInView(d.fCurrent);
    SelectionMoved(OldSel);
    with OldCurrent do InvalidateCell(X,Y);
    with d.fCurrent do InvalidateCell(X,Y);
  end;
end;

procedure TStGrd.MoveRow(FromIndex, ToIndex: Integer);
var Rect: tGridRect;
    D: PStGrdData;
    S: PStrList;
    i,j: Longint;
begin
  D := Pointer(CustomObj);
  if Assigned(D.fRowHeights) then
    MoveExtent(D.fRowHeights, FromIndex + 1, ToIndex + 1);
  MoveAdjust(D.fCurrent.Y, FromIndex, ToIndex);
  MoveAdjust(D.fAnchor.Y, FromIndex, ToIndex);

  S := NewStrList;
  S.Clear;
  for i := 0 to D.fColCount-1 do S.Add(PStrListArray(D.fCells)^[i].Items[FromIndex]);
  if FromIndex < ToIndex
    then for i := FromIndex to ToIndex-1 do
      for j := 0 to D.fColCount-1 do PStrListArray(D.fCells)^[j].Items[i] := PStrListArray(D.fCells)^[j].Items[i+1]
    else for i := FromIndex downto ToIndex+1 do
      for j := 0 to D.fColCount-1 do PStrListArray(D.fCells)^[j].Items[i] := PStrListArray(D.fCells)^[j].Items[i-1];
  for i := 0 to D.fColCount-1 do PStrListArray(D.fCells)^[i].Items[ToIndex] := S.Items[i];
  S.Free;

  Rect.Left := 0;
  Rect.Right := VisibleColCount;
  if FromIndex < ToIndex then begin
    Rect.Top := FromIndex;
    Rect.Bottom := ToIndex;
  end else begin
    Rect.Top := ToIndex;
    Rect.Bottom := FromIndex;
  end;

  InvalidateRect(Rect);
//  MoveAdjust(D.fInplaceRow, FromIndex, ToIndex);
//  RowMoved(FromIndex, ToIndex);
  if Assigned(D.fRowHeights) then
    UpdateScrollRange;//RowHeightsChanged;
//  UpdateEdit;
end;

procedure TStGrd.MoveTopLeft(ALeft, ATop: Integer);
var
  OldTopLeft: TGridCoord;
  D: PStGrdData;
begin
  D := PStGrdData(CustomObj);
  if (ALeft = D.fTopLeft.X) and (ATop = D.fTopLeft.Y) then Exit;
  Update;
  OldTopLeft := D.fTopLeft;
  D.fTopLeft.X := ALeft;
  D.fTopLeft.Y := ATop;
  TopLeftMoved(OldTopLeft);
end;

procedure TStGrd.Paint(DC: HDC);
var
  LineColor: TColor;
  DrawInfo: TGridDrawInfo;
  Sel: TGridRect;
  UpdateRect: TRect;
  {AFocRect,} FocRect: TRect;
  PointsList: PIntArray;
  StrokeList: PIntArray;
  MaxStroke: Integer;
  FrameFlags1, FrameFlags2: DWORD;
  D: PStGrdData;

//  r: TRect;
  tmDC, tmBmp, tmObj: Cardinal;
  c: PCanvas;

  procedure DrawLines(DoHorz, DoVert: Boolean; Col, Row: Longint; const CellBounds: array of Integer; OnColor, OffColor: TColor);
//  const
//    FlatPenStyle = PS_Geometric or PS_Solid or PS_EndCap_Flat or PS_Join_Miter;

    procedure DrawAxisLines(const AxisInfo: TGridAxisDrawInfo; Cell, MajorIndex: Integer; UseOnColor: Boolean);
    var
      Line: Integer;
//      LogBrush: TLOGBRUSH;
      Index: Integer;
      Points: PIntArray;
      StopMajor, StartMinor, StopMinor, StopIndex: Integer;
      LineIncr: Integer;
    begin
      with c^, AxisInfo do begin
        if (EffectiveLineWidth <> 0) then begin
          Pen.PenWidth := GridLineWidth;
          if UseOnColor then
            Pen.Color := OnColor
          else
            Pen.Color := OffColor;
          MoveTo(0,0); LineTo(0,0);
{          if Pen.Width > 1 then
          begin
            LogBrush.lbStyle := BS_Solid;
            LogBrush.lbColor := Pen.Color;
            LogBrush.lbHatch := 0;
            Pen.Handle := ExtCreatePen(FlatPenStyle, Pen.Width, LogBrush, 0, nil);
          end;}
          Points := PointsList;
          Line := CellBounds[MajorIndex] + EffectiveLineWidth shr 1 + GetExtent(Cell);
          //!!! ??? Line needs to be incremented for RightToLeftAlignment ???
//          if UseRightToLeftAlignment and (MajorIndex = 0) then Inc(Line);
          StartMinor := CellBounds[MajorIndex xor 1];
          StopMinor := CellBounds[2 + (MajorIndex xor 1)];
          StopMajor := CellBounds[2 + MajorIndex] + EffectiveLineWidth;
          StopIndex := MaxStroke * 4;
          Index := 0;
          repeat
            Points^[Index + MajorIndex] := Line;         { MoveTo }
            Points^[Index + (MajorIndex xor 1)] := StartMinor;
            Inc(Index, 2);
            Points^[Index + MajorIndex] := Line;         { LineTo }
            Points^[Index + (MajorIndex xor 1)] := StopMinor;
            Inc(Index, 2);
            // Skip hidden columns/rows.  We don't have stroke slots for them
            // A column/row with an extent of -EffectiveLineWidth is hidden
            repeat
              Inc(Cell);
              LineIncr := GetExtent(Cell) + EffectiveLineWidth;
            until (LineIncr > 0) or (Cell > LastFullVisibleCell);
            Inc(Line, LineIncr);
          until (Line > StopMajor) or (Cell > LastFullVisibleCell) or (Index > StopIndex);
           { 2 integers per point, 2 points per line -> Index div 4 }
          PolyPolyLine(Handle, Points^, StrokeList^, Index shr 2);
        end;
      end;
    end;

  begin
    if (CellBounds[0] = CellBounds[2]) or (CellBounds[1] = CellBounds[3]) then Exit;
    if not DoHorz then begin
      DrawAxisLines(DrawInfo.Vert, Row, 1, DoHorz);
      DrawAxisLines(DrawInfo.Horz, Col, 0, DoVert);
    end else begin
      DrawAxisLines(DrawInfo.Horz, Col, 0, DoVert);
      DrawAxisLines(DrawInfo.Vert, Row, 1, DoHorz);
    end;
  end;

  procedure DrawCells(ACol, ARow: Longint; StartX, StartY, StopX, StopY: Integer; Color: TColor; IncludeDrawState: TGridDrawState);
  var
    CurCol, CurRow: Longint;
    {AWhere,} Where, TempRect: TRect;
    DrawState: TGridDrawState;
    Focused: Boolean;
    s: string;
  begin
    CurRow := ARow;
    Where.Top := StartY;
    while (Where.Top < StopY) and (CurRow < d.fRowCount) do begin
      CurCol := ACol;
      Where.Left := StartX;
      Where.Bottom := Where.Top + RowHeights[CurRow];
      while (Where.Left < StopX) and (CurCol < ColCount) do begin
        Where.Right := Where.Left + ColWidths[CurCol];
        if (Where.Right > Where.Left) and RectVisible(c.Handle, Where) then begin
          DrawState := IncludeDrawState;
          Focused := IsActiveControl;
          if Focused and (CurRow = Row) and (CurCol = Col) then
            Include(DrawState, gdFocused);
          if PointInGridRect(CurCol, CurRow, Sel) then
            Include(DrawState, gdSelected);
//          if not (gdFocused in DrawState) or not (goEditing in Options) {or not FEditorMode} then begin
            if d.fDefaultDrawing then with c^ do begin
              Font.Assign(Self.Font);
              if (gdSelected in DrawState) and
                (not (gdFocused in DrawState) or
                ([goDrawFocusSelected, goRowSelect] * d.fOptions <> [])) then
              begin
                Brush.Color := clHighlight;
                Font.Color := clHighlightText;
              end else
                Brush.Color := Color;
              FillRect(Where);

              TempRect := Where;
              InflateRect(TempRect,-2,-2);
              s := Cells[CurCol,CurRow];
              if (s <> '') and (TempRect.Right-TempRect.Left > 4) and (TempRect.Bottom-TempRect.Top > 4) then begin
                SelectObject(c.Handle,Font.Handle);
                Windows.DrawText(c.Handle,pChar(s),length(s),TempRect,dt_SingleLine);
              end;
//              TempRect := Where;
//              InflateRect(TempRect,-2,-2);
//              if () and () then
//                TextRect(TempRect,TempRect.Left,TempRect.Top,Cells[CurCol,CurRow]);
            end else
              DrawCell(c, CurCol, CurRow, Where, DrawState);
            if d.fDefaultDrawing and (gdFixed in DrawState) and d.fCtl3D and
              ((FrameFlags1 or FrameFlags2) <> 0) then
            begin
              TempRect := Where;
              if (FrameFlags1 and BF_RIGHT) = 0
                then Inc(TempRect.Right, DrawInfo.Horz.EffectiveLineWidth)
                else if (FrameFlags1 and BF_BOTTOM) = 0
                  then Inc(TempRect.Bottom, DrawInfo.Vert.EffectiveLineWidth);
              DrawEdge(c.Handle, TempRect, BDR_RAISEDINNER, FrameFlags2);
              DrawEdge(c.Handle, TempRect, BDR_RAISEDINNER, FrameFlags1);
            end;

            if d.fDefaultDrawing and
              (gdFocused in DrawState)// and
//              ([goEditing, goAlwaysShowEditor] * d.fOptions <>
//              [goEditing, goAlwaysShowEditor])
              and not (goRowSelect in d.fOptions) then
              c.DrawFocusRect(Where);// DrawFocusRect(c.Handle, Where)
//          end;
        end;
        Where.Left := Where.Right + DrawInfo.Horz.EffectiveLineWidth;
        Inc(CurCol);
      end;
      Where.Top := Where.Bottom + DrawInfo.Vert.EffectiveLineWidth;
      Inc(CurRow);
    end;
  end;


begin
  {GetClientRect(Handle,r); //}//r := MakeRect(0,0,ClientWidth,ClientHeight);
  UpdateRect := Canvas.ClipRect;

  tmDC := CreateCompatibleDC(DC);
  tmBmp := CreateCompatibleBitmap(DC,UpdateRect.Right,UpdateRect.Bottom);
  tmObj := SelectObject(tmDC,tmBmp);
  c := NewCanvas(tmDC);

//  if UseRightToLeftAlignment then ChangeGridOrientation(True);

  D := Pointer(CustomObj);
  CalcDrawInfo(DrawInfo);
  with DrawInfo do begin
    if (Horz.EffectiveLineWidth > 0) or (Vert.EffectiveLineWidth > 0) then begin
      LineColor := clSilver;
      MaxStroke := Max(Horz.LastFullVisibleCell - d.fTopLeft.X + d.fFixedCols,
                        Vert.LastFullVisibleCell - d.fTopLeft.Y + d.fFixedRows) + 3;
      PointsList := StackAlloc(MaxStroke * sizeof(TPoint) * 2);
      StrokeList := StackAlloc(MaxStroke * sizeof(Integer));
      FillDWord(StrokeList^, MaxStroke, 2);

      if Color2RGB(Color) = clSilver then LineColor := clGray;
      DrawLines(goFixedHorzLine in d.fOptions, goFixedVertLine in d.fOptions,
        0, 0, [0, 0, Horz.FixedBoundary, Vert.FixedBoundary], clBlack, clBtnFace);
      DrawLines(goFixedHorzLine in d.fOptions, goFixedVertLine in d.fOptions,
        d.fTopLeft.X, 0, [Horz.FixedBoundary, 0, Horz.GridBoundary,
        Vert.FixedBoundary], clBlack, clBtnFace);
      DrawLines(goFixedHorzLine in d.fOptions, goFixedVertLine in d.fOptions,
        0, d.fTopLeft.Y, [0, Vert.FixedBoundary, Horz.FixedBoundary,
        Vert.GridBoundary], clBlack, clBtnFace);
      DrawLines(goHorzLine in d.fOptions, goVertLine in d.fOptions,
        d.fTopLeft.X, d.fTopLeft.Y, [Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridBoundary,
        Vert.GridBoundary], LineColor, clWindow);

      StackFree(StrokeList);
      StackFree(PointsList);
    end;                                     {FixedColor = clBtnFace}
                                              {Color = clWindow}
    { Draw the cells in the four areas }
    Sel := Selection;
    FrameFlags1 := 0;
    FrameFlags2 := 0;
    if goFixedVertLine in d.fOptions then begin
      FrameFlags1 := BF_RIGHT;
      FrameFlags2 := BF_LEFT;
    end;
    if goFixedHorzLine in d.fOptions then begin
      FrameFlags1 := FrameFlags1 or BF_BOTTOM;
      FrameFlags2 := FrameFlags2 or BF_TOP;
    end;
    DrawCells(0, 0, 0, 0, Horz.FixedBoundary, Vert.FixedBoundary, clBtnFace{FixedColor},
      [gdFixed]);
    DrawCells(d.fTopLeft.X, 0, Horz.FixedBoundary - d.fColOffset, 0, Horz.GridBoundary,  //!! clip
      Vert.FixedBoundary, clBtnFace{FixedColor}, [gdFixed]);
    DrawCells(0, d.fTopLeft.Y, 0, Vert.FixedBoundary, Horz.FixedBoundary,
      Vert.GridBoundary, clBtnFace{FixedColor}, [gdFixed]);
    DrawCells(d.fTopLeft.X, d.fTopLeft.Y, Horz.FixedBoundary - d.fColOffset,                   //!! clip
      Vert.FixedBoundary, Horz.GridBoundary, Vert.GridBoundary, clWindow{Color}, []);

    if //not (csDesigning in ComponentState) and
      (goRowSelect in d.fOptions) and d.fDefaultDrawing and Focused then begin
      GridRectToScreenRect(GetSelection, FocRect, False);
      c.DrawFocusRect(FocRect);
    end;
    if Horz.GridBoundary < Horz.GridExtent then begin
      c.Brush.Color := Color;
      c.FillRect(MakeRect(Horz.GridBoundary, 0, Horz.GridExtent, Vert.GridBoundary));
    end;
    if Vert.GridBoundary < Vert.GridExtent then begin
      c.Brush.Color := Color;
      c.FillRect(MakeRect(0, Vert.GridBoundary, Horz.GridExtent, Vert.GridExtent));
    end;
  end;

//  BitBlt(Canvas.Handle,0,0,r.Right,r.Bottom,c.Handle,0,0,SrcCopy);
  BitBlt(Canvas.Handle,UpdateRect.Left,UpdateRect.Top,UpdateRect.Right,UpdateRect.Bottom,c.Handle,UpdateRect.Left,UpdateRect.Top,SrcCopy);
//  Canvas.CopyRect(r,c,r);
  SelectObject(tmDC,tmObj);
  DeleteObject(tmBmp);
//  DeleteDC(tmDC);
  c.Free;
end;

procedure TStGrd.ScrollData(DX, DY: Integer);
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  ScrollDataInfo(DX, DY, DrawInfo);
end;

procedure TStGrd.ScrollDataInfo(DX, DY: Integer; var DrawInfo: TGridDrawInfo);
var
  ScrollArea: TRect;
  ScrollFlags: Integer;
begin
  with DrawInfo do
  begin
    ScrollFlags := SW_INVALIDATE;
    if not DefaultDrawing then ScrollFlags := ScrollFlags or SW_ERASE;
    { Scroll the area }
    if DY = 0 then begin
      { Scroll both the column titles and data area at the same time }
//      if not UseRightToLeftAlignment then
        ScrollArea := MakeRect(Horz.FixedBoundary, 0, Horz.GridExtent, Vert.GridExtent);
{      else
      begin
        ScrollArea := Rect(ClientWidth - Horz.GridExtent, 0, ClientWidth - Horz.FixedBoundary, Vert.GridExtent);
        DX := -DX;
      end;}
      ScrollWindowEx(Handle, DX, 0, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end else if DX = 0 then begin
      ScrollArea := MakeRect(0, Vert.FixedBoundary, Horz.GridExtent, Vert.GridExtent);
      ScrollWindowEx(Handle, 0, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end else begin
      ScrollArea := MakeRect(Horz.FixedBoundary, 0, Horz.GridExtent, Vert.FixedBoundary);
      ScrollWindowEx(Handle, DX, 0, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
      ScrollArea := MakeRect(0, Vert.FixedBoundary, Horz.FixedBoundary, Vert.GridExtent);
      ScrollWindowEx(Handle, 0, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
      { Data area }
      ScrollArea := MakeRect(Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridExtent,
        Vert.GridExtent);
      ScrollWindowEx(Handle, DX, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end;
  end;
  if goRowSelect in Options then
    InvalidateRect(Selection);
end;

function TStGrd.SelectCell(ACol, ARow: Integer): Boolean;
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  Result := True;
  if Assigned(d.fOnSelectCell) then d.fOnSelectCell(@Self, ACol, ARow, Result);
end;

procedure TStGrd.SelectionMoved(const OldSel: TGridRect);
var
  OldRect, NewRect: TRect;
  AXorRects: TXorRects;
  I: Integer;
begin
  GridRectToScreenRect(OldSel, OldRect, True);
  GridRectToScreenRect(Selection, NewRect, True);
  XorRects(OldRect, NewRect, AXorRects);
  for I := Low(AXorRects) to High(AXorRects) do
    Windows.InvalidateRect(Handle, @AXorRects[I], False);
end;

procedure TStGrd.SetCells(ACol, ARow: Integer; const Value: string);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if (ACol < 0) or (ARow < 0) or (ACol > D.fColCount-1) or (ARow > D.fRowCount - 1) then exit;
  PStrListArray(D.fCells)^[ACol].Items[ARow] := Value;
  InvalidateCell(ACol,ARow);
end;

procedure TStGrd.SetCol(const Value: Longint);
begin
  FocusCell(Value, Row, True);
end;

procedure TStGrd.SetColCount(Value: Longint);
var D: PStGrdData;
    i,j,old: Longint;
begin
  D := Pointer(CustomObj);
  if d.fColCount <> Value then begin
    if Value < 1 then Value := 1;
    if Value <= d.fFixedCols then d.fFixedCols := Value - 1;
    old := d.fColCount;
    ChangeSize(Value, d.fRowCount);
    if goRowSelect in d.fOptions then begin
      d.fAnchor.X := d.fColCount - 1;
      Invalidate;
    end;
    if old > D.fColCount
      then for i := old - 1 downto D.fColCount do PStrListArray(D.fCells)^[i].Free
    else begin
      SetLength(PStrListArray(D.fCells)^,D.fColCount);
      for i := old to D.fColCount - 1 do begin
        PStrListArray(D.fCells)^[i] := NewStrList;
        for j := 0 to D.fRowCount - 1 do
          PStrListArray(D.fCells)^[i].Add('');
      end;
    end;
  end;
end;

procedure TStGrd.SetColWidths(Index: Integer; const Value: Integer);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if d.fColWidths = nil then
    UpdateExtents(d.fColWidths, d.fColCount, d.fDefaultColWidth);
  if Index >= d.fColCount then exit;//InvalidOp(SIndexOutOfRange);
  if Value <> PIntArray(d.fColWidths)^[Index + 1] then
  begin
    invalidate;//ResizeCol(Index, PIntArray(d.fColWidths)^[Index + 1], Value);
    PIntArray(d.fColWidths)^[Index + 1] := Value;
    UpdateScrollRange;//ColWidthsChanged;
  end;
end;

procedure TStGrd.SetDefaultColWidth(const Value: Integer);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if D.fColWidths <> nil then UpdateExtents(D.fColWidths, 0, 0);
  D.fDefaultColWidth := Value;
  UpdateScrollRange;//ColWidthsChanged;
  Invalidate//Grid;
end;

procedure TStGrd.SetDefaultDrawing(const Value: Boolean);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  D.fDefaultDrawing := Value;
end;

procedure TStGrd.SetDefaultRowHeight(const Value: Integer);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if D.fRowHeights <> nil then UpdateExtents(D.fRowHeights, 0, 0);
  D.fDefaultRowHeight := Value;
  UpdateScrollRange;//RowHeightsChanged;
  Invalidate//Grid;
end;

procedure TStGrd.SetFixedCols(const Value: Integer);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if Value < 0 then exit;//InvalidOp(SIndexOutOfRange);
  if Value >= D.fColCount then exit;//InvalidOp(SFixedColTooBig);
  D.fFixedCols := Value;
//  Initialize;
  D.fTopLeft.X := D.fFixedCols;
  D.fTopLeft.Y := D.fFixedRows;
  D.fCurrent := D.fTopLeft;
  D.fAnchor := D.fCurrent;
  if goRowSelect in D.fOptions then D.fAnchor.X := D.fColCount - 1;
//
  Invalidate//Grid;
end;

procedure TStGrd.SetFixedRows(const Value: Integer);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if Value < 0 then exit;//InvalidOp(SIndexOutOfRange);
  if Value >= D.fRowCount then exit;//InvalidOp(SFixedRowTooBig);
  D.fFixedRows := Value;
//  Initialize;
  D.fTopLeft.X := D.fFixedCols;
  D.fTopLeft.Y := D.fFixedRows;
  D.fCurrent := D.fTopLeft;
  D.fAnchor := D.fCurrent;
  if goRowSelect in D.fOptions then D.fAnchor.X := D.fColCount - 1;
//
  Invalidate//Grid;
end;

procedure TStGrd.SetLeftCol(const Value: Longint);
begin
  MoveTopLeft(Value, TopRow);
end;

procedure TStGrd.SetOnDrawCell(const Value: TDrawCellEvent);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  D.fOnDrawCell := Value;
end;

procedure TStGrd.SetOnSelectCell(const Value: TSelectCellEvent);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  D.fOnSelectCell := Value;
end;

procedure TStGrd.SetOptions(Value: TGridOptions);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if goRowSelect in Value then
    Exclude(Value, goAlwaysShowEditor);
  D.fOptions := Value;
//  if not FEditorMode then
//    if goAlwaysShowEditor in Value then
//      ShowEditor else
//      HideEditor;
  if goRowSelect in Value then MoveCurrent(Col, Row,  True, False);
  Invalidate//Grid;
end;

procedure TStGrd.SetRow(const Value: Longint);
begin
  FocusCell(Col, Value, True);
end;

procedure TStGrd.SetRowCount(Value: Longint);
var D: PStGrdData;
    i,j,old: Longint;
begin
  D := Pointer(CustomObj);
  if Value < 1 then Value := 1;
  if Value <= D.fFixedRows then D.fFixedRows := Value - 1;
  old := D.fRowCount;
  ChangeSize(D.fColCount, Value);
  if old > D.fRowCount
    then for i := 0 to D.fColCount - 1 do
      for j := old - 1 downto D.fRowCount do
        PStrListArray(D.fCells)^[i].Delete(j)
    else for i := 0 to D.fColCount - 1 do
      for j := old to D.fRowCount - 1 do
        PStrListArray(D.fCells)^[i].Add('');
end;

procedure TStGrd.SetRowHeights(Index: Integer; const Value: Integer);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if D.fRowHeights = nil then
    UpdateExtents(d.fRowHeights, d.fRowCount, d.fDefaultRowHeight);
  if Index >= d.fRowCount then exit;//InvalidOp(SIndexOutOfRange);
  if Value <> PIntArray(d.fRowHeights)^[Index + 1] then begin
    invalidate;//ResizeRow(Index, PIntArray(D.fRowHeights)^[Index + 1], Value);
    PIntArray(d.fRowHeights)^[Index + 1] := Value;
    UpdateScrollRange;//RowHeightsChanged;
  end;
end;

procedure TStGrd.SetRows(Index: Integer; const Value: pStrList);
var D: PStGrdData;
    i: Longint;
begin
  D := Pointer(CustomObj);
  if (Index < 0) or (Index > D.fRowCount - 1) then exit;
  for i := 0 to Value.Count-1 do
    PStrListArray(D.fCells)^[i].Items[Index] := Value.Items[i];
end;

procedure TStGrd.SetScrollBars(const Value: TScrollStyle);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if D.fScrollBars <> Value then begin
    D.fScrollBars := Value;
    ShowScrollBar(Handle,sb_Vert,Value in [ssVertical,ssBoth]);
    ShowScrollBar(Handle,sb_Horz,Value in [ssHorizontal,ssBoth]);
  end;
end;

procedure TStGrd.SetSelection(const Value: TGridRect);
var
  OldSel: TGridRect;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  OldSel := Selection;
  D.fAnchor := Value.TopLeft;
  D.fCurrent := Value.BottomRight;
  SelectionMoved(OldSel);
end;
{
procedure TStGrd.SetTabStops(Index: Integer; const Value: Boolean);
var D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if D.fTabStops = nil then
    UpdateExtents(D.fTabStops, D.fColCount, Integer(True));
  if Index >= D.fColCount then exit;//InvalidOp(SIndexOutOfRange);
  PIntArray(D.fTabStops)^[Index + 1] := Integer(Value);
end;
}
procedure TStGrd.SetTopRow(const Value: Longint);
begin
  MoveTopLeft(LeftCol, Value);
end;

procedure TStGrd.TimedScroll(Direction: TGridScrollDirection);
var
  MaxAnchor, NewAnchor: TGridCoord;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  NewAnchor := D.fAnchor;
  MaxAnchor.X := D.fColCount - 1;
  MaxAnchor.Y := D.fRowCount - 1;
  if (sdLeft in Direction) and (D.fAnchor.X > D.fFixedCols) then Dec(NewAnchor.X);
  if (sdRight in Direction) and (D.fAnchor.X < MaxAnchor.X) then Inc(NewAnchor.X);
  if (sdUp in Direction) and (D.fAnchor.Y > D.fFixedRows) then Dec(NewAnchor.Y);
  if (sdDown in Direction) and (D.fAnchor.Y < MaxAnchor.Y) then Inc(NewAnchor.Y);
  if (D.fAnchor.X <> NewAnchor.X) or (D.fAnchor.Y <> NewAnchor.Y) then
    MoveAnchor(NewAnchor);
end;

procedure TStGrd.TopLeftMoved(const OldTopLeft: TGridCoord);

  function CalcScroll(const AxisInfo: TGridAxisDrawInfo;
    OldPos, CurrentPos: Integer; var Amount: Longint): Boolean;
  var
    Start, Stop: Longint;
    I: Longint;
  begin
    Result := False;
    with AxisInfo do begin
      if OldPos < CurrentPos then begin
        Start := OldPos;
        Stop := CurrentPos;
      end else begin
        Start := CurrentPos;
        Stop := OldPos;
      end;
      Amount := 0;
      for I := Start to Stop - 1 do begin
        Inc(Amount, GetExtent(I) + EffectiveLineWidth);
        if Amount > (GridBoundary - FixedBoundary) then begin
          { Scroll amount too big, redraw the whole thing }
          Invalidate;//Grid;
          Exit;
        end;
      end;
      if OldPos < CurrentPos then Amount := -Amount;
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
  Delta: TGridCoord;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  UpdateScrollPos;
  CalcDrawInfo(DrawInfo);
  if CalcScroll(DrawInfo.Horz, OldTopLeft.X, D.fTopLeft.X, Delta.X) and
    CalcScroll(DrawInfo.Vert, OldTopLeft.Y, D.fTopLeft.Y, Delta.Y) then
    ScrollDataInfo(Delta.X, Delta.Y, DrawInfo);
//  TopLeftChanged;
end;

procedure TStGrd.UpdateScrollPos;
var
  DrawInfo: TGridDrawInfo;
  MaxTopLeft: TGridCoord;
  GridSpace, ColWidth: Integer;
  D: PStGrdData;

  procedure SetScroll(Code: Word; Value: Integer);
  begin
{    if UseRightToLeftAlignment and (Code = SB_HORZ) then
      if ColCount <> 1 then Value := MaxShortInt - Value
      else                  Value := (ColWidth - GridSpace) - Value;}
    if GetScrollPos(Handle, Code) <> Value then
      SetScrollPos(Handle, Code, Value, True);
  end;

begin
  D := Pointer(CustomObj);
  if (ScrollBars = ssNone) then Exit;
  CalcDrawInfo(DrawInfo);
  MaxTopLeft.X := ColCount - 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  if ScrollBars in [ssHorizontal, ssBoth] then
    if ColCount = 1 then
    begin
      ColWidth := ColWidths[DrawInfo.Horz.FirstGridCell];
      GridSpace := ClientWidth - DrawInfo.Horz.FixedBoundary;
      if (D.fColOffset > 0) and (GridSpace > (ColWidth - D.fColOffset)) then
        ModifyScrollbar(SB_HORZ, SB_THUMBPOSITION, ColWidth - GridSpace, True)
      else
        SetScroll(SB_HORZ, D.fColOffset)
    end
    else
      SetScroll(SB_HORZ, LongMulDiv(D.fTopLeft.X - D.fFixedCols, MaxShortInt,
        MaxTopLeft.X - D.fFixedCols));
  if ScrollBars in [ssVertical, ssBoth] then
    SetScroll(SB_VERT, LongMulDiv(D.fTopLeft.Y - D.fFixedRows, MaxShortInt,
      MaxTopLeft.Y - D.fFixedRows));
end;

procedure TStGrd.UpdateScrollRange;
var
  MaxTopLeft, OldTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  OldScrollBars: TScrollStyle;
  Updated: Boolean;
  D: PStGrdData;

  procedure DoUpdate;
  begin
    if not Updated then
    begin
      Update;
      Updated := True;
    end;
  end;

  function ScrollBarVisible(Code: Word): Boolean;
  var
    Min, Max: Integer;
  begin
    Result := False;
    if (ScrollBars = ssBoth) or
      ((Code = SB_HORZ) and (ScrollBars = ssHorizontal)) or
      ((Code = SB_VERT) and (ScrollBars = ssVertical)) then
    begin
      GetScrollRange(Handle, Code, Min, Max);
      Result := Min <> Max;
    end;
  end;

  procedure CalcSizeInfo;
  begin
    CalcDrawInfoXY(DrawInfo, DrawInfo.Horz.GridExtent, DrawInfo.Vert.GridExtent);
    MaxTopLeft.X := ColCount - 1;
    MaxTopLeft.Y := RowCount - 1;
    MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  end;

  procedure SetAxisRange(var Max, Old, Current: Longint; Code: Word;
    Fixeds: Integer);
  begin
    CalcSizeInfo;
    if Fixeds < Max then
      SetScrollRange(Handle, Code, 0, MaxShortInt, True)
    else
      SetScrollRange(Handle, Code, 0, 0, True);
    if Old > Max then
    begin
      DoUpdate;
      Current := Max;
    end;
  end;

  procedure SetHorzRange;
  var
    Range: Integer;
  begin
    if OldScrollBars in [ssHorizontal, ssBoth] then
      if ColCount = 1 then
      begin
        Range := ColWidths[0] - ClientWidth;
        if Range < 0 then Range := 0;
        SetScrollRange(Handle, SB_HORZ, 0, Range, True);
      end
      else
        SetAxisRange(MaxTopLeft.X, OldTopLeft.X, D.fTopLeft.X, SB_HORZ, D.fFixedCols);
  end;

  procedure SetVertRange;
  begin
    if OldScrollBars in [ssVertical, ssBoth] then
      SetAxisRange(MaxTopLeft.Y, OldTopLeft.Y, D.fTopLeft.Y, SB_VERT, D.fFixedRows);
  end;

begin
  if (ScrollBars = ssNone) {or not Showing} then Exit;
  D := Pointer(CustomObj);
  with DrawInfo do
  begin
    Horz.GridExtent := ClientWidth;
    Vert.GridExtent := ClientHeight;
    { Ignore scroll bars for initial calculation }
    if ScrollBarVisible(SB_HORZ) then
      Inc(Vert.GridExtent, GetSystemMetrics(SM_CYHSCROLL));
    if ScrollBarVisible(SB_VERT) then
      Inc(Horz.GridExtent, GetSystemMetrics(SM_CXVSCROLL));
  end;
  OldTopLeft := D.fTopLeft;
  { Temporarily mark us as not having scroll bars to avoid recursion }
  OldScrollBars := D.fScrollBars;
  D.fScrollBars := ssNone;
  Updated := False;
  try
    { Update scrollbars }
    SetHorzRange;
    DrawInfo.Vert.GridExtent := ClientHeight;
    SetVertRange;
    if DrawInfo.Horz.GridExtent <> ClientWidth then
    begin
      DrawInfo.Horz.GridExtent := ClientWidth;
      SetHorzRange;
    end;
  finally
    D.fScrollBars := OldScrollBars;
  end;
  UpdateScrollPos;
  if (D.fTopLeft.X <> OldTopLeft.X) or (D.fTopLeft.Y <> OldTopLeft.Y) then
    TopLeftMoved(OldTopLeft);
end;

procedure TStGrd.WheelDown{(Shift: TShiftState; MousePos: TPoint): Boolean};
begin
//  Result := inherited DoMouseWheelDown(Shift, MousePos);
//  if not Result then
  begin
    if Row < RowCount - 1 then Row := Row + 1;
//    Result := True;
  end;
end;

procedure TStGrd.WheelUp{(Shift: TShiftState; MousePos: TPoint): Boolean};
begin
//  Result := inherited DoMouseWheelUp(Shift, MousePos);
//  if not Result then
  begin
    if Row > FixedRows then Row := Row - 1;
//    Result := True;
  end;
end;

procedure TStGrd.WMSetCursor(_HitTest: Word);
var
  DrawInfo: TGridDrawInfo;
  State: TGridState;
  Index: Longint;
  Pos, Ofs: Integer;
  Cur: HCURSOR;
  D: PStGrdData;
begin
  if _HitTest = HTCLIENT then begin
    D := Pointer(CustomObj);
    if D.fGridState = gsNormal then begin
      CalcDrawInfo(DrawInfo);
      CalcSizingState(D.fHitTest.X, D.fHitTest.Y, State, Index, Pos, Ofs, DrawInfo);
    end else State := D.fGridState;
    case State of
      gsRowSizing: Cur := LoadCursor(hInstance,IDC_VSPLIT); //LoadCursor(0,IDC_SIZENS);
      gsColSizing: Cur := LoadCursor(hInstance,IDC_HSPLIT); //LoadCursor(0,IDC_SIZEWE);
    else
      Cur := LoadCursor(0,IDC_ARROW);
    end;
{    if State = gsRowSizing
      then Cur := LoadCursor(0,IDC_SIZENS) //Screen.Cursors[crVSplit]
      else if State = gsColSizing
        then Cur := LoadCursor(0,IDC_SIZEWE); //Screen.Cursors[crHSplit]}
  DestroyCursor(Cursor);
  SetCursor(Cur);
  Cursor := Cur;
  end;
  {if Cur <> 0 then }
end;

procedure TStGrd.WMTimer;
var
  Point: TPoint;
  DrawInfo: TGridDrawInfo;
  ScrollDirection: TGridScrollDirection;
  CellHit: TGridCoord;
//  LeftSide: Integer;
//  RightSide: Integer;
  D: PStGrdData;
begin
  D := Pointer(CustomObj);
  if not (D.fGridState in [gsSelecting, gsRowMoving, gsColMoving]) then Exit;
  GetCursorPos(Point);
  Point := Screen2Client(Point);
  CalcDrawInfo(DrawInfo);
  ScrollDirection := [];
  with DrawInfo do
  begin
    CellHit := CalcCoordFromPoint(Point.X, Point.Y, DrawInfo);
    case D.fGridState of
      gsColMoving:
        MoveAndScroll(Point.X, CellHit.X, DrawInfo, Horz, SB_HORZ, Point);
      gsRowMoving:
        MoveAndScroll(Point.Y, CellHit.Y, DrawInfo, Vert, SB_VERT, Point);
      gsSelecting:
      begin
//        if not UseRightToLeftAlignment then
        begin
          if Point.X < Horz.FixedBoundary then Include(ScrollDirection, sdLeft)
          else if Point.X > Horz.FullVisBoundary then Include(ScrollDirection, sdRight);
        end
{        else
        begin
          LeftSide := ClientWidth - Horz.FullVisBoundary;
          RightSide := ClientWidth - Horz.FixedBoundary;
          if Point.X < LeftSide then Include(ScrollDirection, sdRight)
          else if Point.X > RightSide then Include(ScrollDirection, sdLeft);
        end};
        if Point.Y < Vert.FixedBoundary then Include(ScrollDirection, sdUp)
        else if Point.Y > Vert.FullVisBoundary then Include(ScrollDirection, sdDown);
        if ScrollDirection <> [] then  TimedScroll(ScrollDirection);
      end;
    end;
  end;
end;

end.
