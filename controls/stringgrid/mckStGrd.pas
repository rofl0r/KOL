unit mckStGrd;

interface

uses
  Windows, Forms, Classes, Controls, mirror, mckCtrls, KOL, KOLStGrd;

type

  TKOLStGrd = class(TKOLControl)
  private
    // fNotAvailable: Boolean;
    fColCount: Longint;
    fDefaultColWidth: Integer;
    fDefaultRowHeight: Integer;
    fFixedCols: Integer;
    fFixedRows: Integer;
    fOptions: TGridOptions;
    fRowCount: Longint;
    fScrollBars: TScrollStyle;
    fDefaultDrawing: Boolean;
    fOnDrawCell: TDrawCellEvent;

    fStr: string;
//    fEdgeStyle: tEdgeStyle;
    fBorderStyle: tBorderStyle;
    fCtl3D: Boolean;
    fOnSelectCell: TSelectCellEvent;
//    fHasBorder: Boolean;
    // fOnMyEvent: TOnMyEvent;
    // procedure SetOnMyEvent(Value: TOnMyEvent);

    function GetColWidths(Index: Integer): Integer;
    function GetRowHeights(Index: Integer): Integer;
    function GetSelection: TGridRect;
    function GetTabStops(Index: Integer): Boolean; virtual; abstract;
    function GetVisibleColCount: Integer; virtual; abstract;
    function GetVisibleRowCount: Integer; virtual; abstract;
    procedure SetCol(const Value: Longint); virtual; abstract;
    procedure SetColWidths(Index: Integer; const Value: Integer); virtual; abstract;
    procedure SetLeftCol(const Value: Longint); virtual; abstract;
    procedure SetRow(const Value: Longint); virtual; abstract;
    procedure SetRows(Index: Longint; const Value: PStrList); virtual; abstract;
    procedure SetRowHeights(Index: Integer; const Value: Integer); virtual; abstract;
    procedure SetSelection(const Value: TGridRect); virtual; abstract;
    procedure SetTabStops(Index: Integer; const Value: Boolean); virtual; abstract;
    procedure SetTopRow(const Value: Longint); virtual; abstract;
    function GetCol: Longint;
    function GetLeftCol: Longint;
    function GetRow: Longint;
    function GetRows(Index: Longint): PStrList; virtual; abstract;
    function GetTopRow: Longint;
    procedure SetColCount(const Value: Longint);
    procedure SetDefaultColWidth(const Value: Integer);
    procedure SetDefaultDrawing(const Value: Boolean);
    procedure SetDefaultRowHeight(const Value: Integer);
    procedure SetFixedCols(const Value: Integer);
    procedure SetFixedRows(const Value: Integer);
    procedure SetOptions(const Value: TGridOptions);
    procedure SetRowCount(const Value: Longint);
    procedure SetOnDrawCell(const Value: TDrawCellEvent);
    procedure SetScrollBars(const Value: TScrollStyle);
//    procedure SetEdgeStyle(const Value: tEdgeStyle);
    procedure SetBorderStyle(const Value: tBorderStyle);

    procedure CalcFixedInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcDrawInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcDrawInfoXY(var DrawInfo: TGridDrawInfo; UseWidth, UseHeight: Integer);
    procedure SetCtl3D(const Value: Boolean);
    procedure SetOnSelectCell(const Value: TSelectCellEvent);
  protected
    procedure FirstCreate; override;
    function TypeName: String; override;
    function AdditionalUnits: String; override;
    function SetupParams(const AName, AParent: String): String; override;
    procedure AssignEvents(SL: TStringList; const AName: String); override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetupConstruct(SL: TStringList; const AName, AParent, Prefix: String); override;

    procedure CreateParams(var Params: controls.TCreateParams); override;
//    procedure SetHasBorder(const Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;

    property Col: Longint read GetCol write SetCol;
    property ColWidths[Index: Longint]: Integer read GetColWidths write SetColWidths;
    property RowHeights[Index: Longint]: Integer read GetRowHeights write SetRowHeights;
    property LeftCol: Longint read GetLeftCol write SetLeftCol;
    property Row: Longint read GetRow write SetRow;
    property Rows[Index: Longint]: pStrList read GetRows write SetRows;
    property Selection: TGridRect read GetSelection write SetSelection;
    property TabStops[Index: Longint]: Boolean read GetTabStops write SetTabStops;
    property TopRow: Longint read GetTopRow write SetTopRow;
    property VisibleColCount: Integer read GetVisibleColCount;
    property VisibleRowCount: Integer read GetVisibleRowCount;

    property Cells: string read fStr write fStr;

  published
    // property OnMyEvent: TOnMyEvent read fOnMyEvent write SetOnMyEvent;
    { — –€“»≈ —¬Œ…—“¬ ¬ <»Õ—œ≈ “Œ–≈ Œ¡⁄≈ “Œ¬> }
    // property Options: Boolean read fNotAvailable;
    property BorderStyle: tBorderStyle read fBorderStyle write SetBorderStyle;
    property ColCount: Longint read fColCount write SetColCount;
    property DefaultColWidth: Integer read fDefaultColWidth write SetDefaultColWidth;
    property DefaultDrawing: Boolean read fDefaultDrawing write SetDefaultDrawing;
    property DefaultRowHeight: Integer read fDefaultRowHeight write SetDefaultRowHeight;
    property FixedCols: Integer read fFixedCols write SetFixedCols;
    property FixedRows: Integer read fFixedRows write SetFixedRows;
    property Options: TGridOptions read fOptions write SetOptions;
    property RowCount: Longint read fRowCount write SetRowCount;
    property ScrollBars: TScrollStyle read fScrollBars write SetScrollBars;

    property OnDrawCell: TDrawCellEvent read fOnDrawCell write SetOnDrawCell;
    property OnSelectCell: TSelectCellEvent read fOnSelectCell write SetOnSelectCell;
    
    property OnChar;
    property OnKeyDown;
    property OnKeyUp;

    property Ctl3D: Boolean read fCtl3D write SetCtl3D;
  end;

procedure Register;

{$R *.dcr}

implementation

procedure Register;
begin
RegisterComponents('KOL Probes', [TKOLStGrd]);
end;

{ ƒŒ¡¿¬À≈Õ»≈ ÃŒƒ”Àﬂ }
function TKOLStGrd.AdditionalUnits;
begin
  Result := ', kolStGrd';
end;

function TKOLStGrd.TypeName: String;
begin
Result := 'TKOLStGrd';
end;
////////////////////////////////////////////////////////////////////////////////

{------------------}
{ œŒƒÃ≈Õ¿ «Õ¿◊≈Õ»… }
{------------------}
procedure TKOLStGrd.FirstCreate;
begin
// ÕÂ ÒÓÁ‰‡‚‡ÈÚÂ Ò‚ÓÈÒÚ‚Ó ‚ MCK, ÂÒÎË ıÓÚËÚÂ, ˜ÚÓ·
// Û ÌÂ„Ó ·˚ÎÓ ÔÓÒÚÓˇÌÌÓÂ ÁÌ‡˜ÂÌËÂ, Á‡‰‡ÌÌÓÂ ¬‡ÏË.
// CurIndex := -1;
end;

{----------------}
{ –Œƒ»“≈À‹ ‘Œ–Ã¿ }
{----------------}
function TKOLStGrd.SetupParams;
const
  c = ', ';
  Bool: array [Boolean] of String = ('False', 'True');
  opts: array[1..15] of string = (', goFixedVertLine',', goFixedHorzLine',', goVertLine',
    ', goHorzLine',', goRangeSelect',', goDrawFocusSelected',', goRowSizing',', goColSizing',
    ', goRowMoving',', goColMoving',', goEditing',', goTabs',', goRowSelect',', goAlwaysShowEditor',
    ', goThumbTracking');
  sStyle: array[tScrollStyle] of string = ('ssNone','ssHorizontal','ssVertical','ssBoth');
var
  i: Byte;
  s: string;
begin
  s := '';
  for i := 1 to 15 do
    if (TGridOption(i-1) in fOptions)
      then s := s + opts[i];
  if s[1] = ',' then Delete(s,1,2);
  Result := AParent+c+Int2Str(fColCount)+c+Int2Str(fRowCount)+c+Int2Str(fFixedCols)+c+
    Int2Str(fFixedRows)+c+Int2Str(fDefaultColWidth)+c+Int2Str(fDefaultRowHeight)+c+
    '['+s+']'+c+Bool[fDefaultDrawing]+c+Bool[fCtl3D]+c+Bool[fBorderStyle=bsSingle]+c+sStyle[fScrollBars];
end;

{--------------------------}
{ –≈√»—“–¿÷»ﬂ Œ¡–¿¡Œ“◊» Œ¬ }
{--------------------------}
procedure TKOLStGrd.AssignEvents;
begin
inherited;
  DoAssignEvents(SL, AName, ['OnDrawCell'], [@OnDrawCell]);
  DoAssignEvents(SL, AName, ['OnSelectCell'], [@OnSelectCell]);
  DoAssignEvents(SL, AName, ['OnChar'], [@OnChar]);
  DoAssignEvents(SL, AName, ['OnKeyDown'], [@OnKeyDown]);
  DoAssignEvents(SL, AName, ['OnKeyUp'], [@OnKeyUp]);
// DoAssignEvents(SL, AName, ['OnMyEvent'], [@OnMyEvent]);
// DoAssignEvents(SL, AName, ['OnEvent1', 'OnEvent2'], [@OnEvent1, @OnEvent2]);
end;

{------------------------------------}
{ —Œ«ƒ¿Õ»≈ KOL Œ¡⁄≈ “¿ ¬ unitX_X.inc }
{------------------------------------}
procedure TKOLStGrd.SetupConstruct;
const
 spc = ', ';
 Boolean2Str: array [Boolean] of String = ('FALSE', 'TRUE');
var
 S: String;
begin
  S := GenerateTransparentInits;
  SL.Add(Prefix + AName + ' := NewStGrd(' + SetupParams(AName, AParent) +');');
  if S <> '' then SL.Add(Prefix + AName + S + ';');
end;

{--------------------------}
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
{--------------------------}
procedure TKOLStGrd.SetupFirst;
begin
 inherited;

// SL.Add(Prefix + AName + '.myStr := ''' + myStr + ''';');
end;

{--------------------------}
{ ƒŒ¡¿¬À≈Õ»≈ ¬ unitX_X.inc }
{--------------------------}
procedure TKOLStGrd.SetupLast;
begin
 inherited;

// SL.Add(Prefix + AName + '.myInt := ' + Int2Str(myInt) + ';');
end;
////////////////////////////////////////////////////////////////////////////////

{-------------}
{  ŒÕ—“–” “Œ– }
{-------------}
constructor TKOLStGrd.Create;
begin
  inherited Create(AOwner);
  fDefaultColWidth := 64;
  fDefaultRowHeight := 24;
  fDefaultDrawing := True;
  fColCount := 5;
  fRowCount := 5;
  fFixedCols := 1;
  fFixedRows := 1;
  fOptions := [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goDrawFocusSelected];
  fScrollBars := ssBoth;
  fTabStop := True;
  fHasBorder := true;
// fmyInt := 10;
end;

procedure TKOLStGrd.SetColCount(const Value: Longint);
begin
  fColCount := Value;
  RecreateWnd;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetDefaultColWidth(const Value: Integer);
begin
  fDefaultColWidth := Value;
  RecreateWnd;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetDefaultDrawing(const Value: Boolean);
begin
  fDefaultDrawing := Value;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetDefaultRowHeight(const Value: Integer);
begin
  fDefaultRowHeight := Value;
  RecreateWnd;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetFixedCols(const Value: Integer);
begin
  fFixedCols := Value;
  RecreateWnd;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetFixedRows(const Value: Integer);
begin
  fFixedRows := Value;
  RecreateWnd;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetOptions(const Value: TGridOptions);
begin
  fOptions := Value;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetRowCount(const Value: Longint);
begin
  fRowCount := Value;
  RecreateWnd;
  invalidate;
  Change;
end;

procedure TKOLStGrd.SetOnDrawCell(const Value: TDrawCellEvent);
begin
  fOnDrawCell := Value;
  invalidate;
  Change;
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

procedure TKOLStGrd.CalcFixedInfo(var DrawInfo: TGridDrawInfo);

  procedure CalcFixedAxis(var Axis: TGridAxisDrawInfo; LineOptions: TGridOptions; FixedCount, FirstCell, CellCount: Integer; GetExtentFunc: TGetExtentsFunc);
  var I: Integer;
  begin
    with Axis do begin
      if LineOptions * fOptions = []
        then EffectiveLineWidth := 0
        else EffectiveLineWidth := GridLineWidth;
      FixedBoundary := 0;
        for I := 0 to FixedCount - 1 do Inc(FixedBoundary, GetExtentFunc(I) + EffectiveLineWidth);
      FixedCellCount := FixedCount;
      FirstGridCell := FirstCell;
      GridCellCount := CellCount;
      GetExtent := GetExtentFunc;
    end;
  end;

begin
  CalcFixedAxis(DrawInfo.Horz, [goFixedVertLine, goVertLine], fFixedCols, 1, fColCount, GetColWidths);
  CalcFixedAxis(DrawInfo.Vert, [goFixedHorzLine, goHorzLine], fFixedRows, 1, fRowCount, GetRowHeights);
end;

procedure TKOLStGrd.CalcDrawInfoXY(var DrawInfo: TGridDrawInfo; UseWidth, UseHeight: Integer);

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

procedure TKOLStGrd.CalcDrawInfo(var DrawInfo: TGridDrawInfo);
begin
  CalcDrawInfoXY(DrawInfo, ClientWidth, ClientHeight);
end;

procedure TKOLStGrd.Paint;
var
  LineColor: TColor;
  DrawInfo: TGridDrawInfo;
  Sel: TGridRect;
  PointsList: PIntArray;
  StrokeList: PIntArray;
  MaxStroke: Integer;
  FrameFlags1, FrameFlags2: DWORD;

procedure GridRectToScreenRect(GridRect: TGridRect; var ScreenRect: TRect; IncludeLine: Boolean);

  function LinePos(const AxisInfo: TGridAxisDrawInfo; Line: Integer): Integer;
  var
    Start, I: Longint;
  begin
    with AxisInfo do
    begin
      Result := 0;
      if Line < FixedCellCount then
        Start := 0
      else
      begin
        if Line >= FirstGridCell then
          Result := FixedBoundary;
        Start := FirstGridCell;
      end;
      for I := Start to Line - 1 do
      begin
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
        if Result > GridExtent then
        begin
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
    with AxisInfo do
    begin
      if (GridRectMin >= FixedCellCount) and (GridRectMin < FirstGridCell) then
        if GridRectMax < FirstGridCell then
        begin
          FillChar(ScreenRect, SizeOf(ScreenRect), 0); { erase partial results }
          Exit;
        end
        else
          GridRectMin := FirstGridCell;
      if GridRectMax > LastFullVisibleCell then
      begin
        GridRectMax := LastFullVisibleCell;
        if GridRectMax < GridCellCount - 1 then Inc(GridRectMax);
        if LinePos(AxisInfo, GridRectMax) = 0 then
          Dec(GridRectMax);
      end;

      ScreenRectMin := LinePos(AxisInfo, GridRectMin);
      ScreenRectMax := LinePos(AxisInfo, GridRectMax);
      if ScreenRectMax = 0 then
        ScreenRectMax := ScreenRectMin + GetExtent(GridRectMin)
      else
        Inc(ScreenRectMax, GetExtent(GridRectMax));
      if ScreenRectMax > GridExtent then
        ScreenRectMax := GridExtent;
      if IncludeLine then Inc(ScreenRectMax, EffectiveLineWidth);
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
begin
  FillChar(ScreenRect, SizeOf(ScreenRect), 0);
  if (GridRect.Left > GridRect.Right) or (GridRect.Top > GridRect.Bottom) then
    Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do begin
    if GridRect.Left > Horz.LastFullVisibleCell + 1 then Exit;
    if GridRect.Top > Vert.LastFullVisibleCell + 1 then Exit;

    if CalcAxis(Horz, GridRect.Left, GridRect.Right, ScreenRect.Left, ScreenRect.Right) then begin
      CalcAxis(Vert, GridRect.Top, GridRect.Bottom, ScreenRect.Top, ScreenRect.Bottom);
    end;
  end;
end;

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
      with Canvas, AxisInfo do begin
        if (EffectiveLineWidth <> 0) then begin
          Pen.Width := GridLineWidth;
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
    Where, TempRect: TRect;
    DrawState: TGridDrawState;
  begin
    CurRow := ARow;
    Where.Top := StartY;
    while (Where.Top < StopY) and (CurRow < RowCount) do begin
      CurCol := ACol;
      Where.Left := StartX;
      Where.Bottom := Where.Top + RowHeights[CurRow];
      while (Where.Left < StopX) and (CurCol < ColCount) do begin
        Where.Right := Where.Left + ColWidths[CurCol];
        if (Where.Right > Where.Left) and RectVisible(Canvas.Handle, Where) then begin
          DrawState := IncludeDrawState;
          if PointInGridRect(CurCol, CurRow, Sel) then
            Include(DrawState, gdSelected);
          if not (gdFocused in DrawState) or not (goEditing in Options) then begin
            if DefaultDrawing then with Canvas do begin
              if (gdSelected in DrawState) and
                (not (gdFocused in DrawState) or
                ([goDrawFocusSelected, goRowSelect]*Options <> [])) then
              begin
                Brush.Color := clHighlight;
              end else
                Brush.Color := Color;
              FillRect(Where);
            end;
            if DefaultDrawing and (gdFixed in DrawState) and fCtl3D and
              ((FrameFlags1 or FrameFlags2) <> 0) then
            begin
              TempRect := Where;
              if (FrameFlags1 and BF_RIGHT) = 0
                then Inc(TempRect.Right, DrawInfo.Horz.EffectiveLineWidth)
                else if (FrameFlags1 and BF_BOTTOM) = 0
                  then Inc(TempRect.Bottom, DrawInfo.Vert.EffectiveLineWidth);
              DrawEdge(Canvas.Handle, TempRect, BDR_RAISEDINNER, FrameFlags2);
              DrawEdge(Canvas.Handle, TempRect, BDR_RAISEDINNER, FrameFlags1);
            end;
            if DefaultDrawing and
              (gdFocused in DrawState) and
              ([goEditing, goAlwaysShowEditor] * Options <>
              [goEditing, goAlwaysShowEditor])
              and not (goRowSelect in Options) then
              DrawFocusRect(Canvas.Handle, Where)
          end;
        end;
        Where.Left := Where.Right + DrawInfo.Horz.EffectiveLineWidth;
        Inc(CurCol);
      end;
      Where.Top := Where.Bottom + DrawInfo.Vert.EffectiveLineWidth;
      Inc(CurRow);
    end;
  end;

begin
  CalcDrawInfo(DrawInfo);
  with DrawInfo do begin
    if (Horz.EffectiveLineWidth > 0) or (Vert.EffectiveLineWidth > 0) then begin
      LineColor := clSilver;
      MaxStroke := Max(Horz.LastFullVisibleCell - FixedCols,
                        Vert.LastFullVisibleCell - FixedRows) + 3;
      PointsList := StackAlloc(MaxStroke * sizeof(TPoint) * 2);
      StrokeList := StackAlloc(MaxStroke * sizeof(Integer));
      FillDWord(StrokeList^, MaxStroke, 2);

      if Color2RGB(Color) = clSilver then LineColor := clGray;
      DrawLines(goFixedHorzLine in Options, goFixedVertLine in Options,
        0, 0, [0, 0, Horz.FixedBoundary, Vert.FixedBoundary], clBlack, clBtnFace{FixedColor});
      DrawLines(goFixedHorzLine in Options, goFixedVertLine in Options,
        1, 0, [Horz.FixedBoundary, 0, Horz.GridBoundary,
        Vert.FixedBoundary], clBlack, clBtnFace{FixedColor});
      DrawLines(goFixedHorzLine in Options, goFixedVertLine in Options,
        0, 1, [0, Vert.FixedBoundary, Horz.FixedBoundary,
        Vert.GridBoundary], clBlack, clBtnFace{FixedColor});
      DrawLines(goHorzLine in Options, goVertLine in Options,
        1, 1, [Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridBoundary,
        Vert.GridBoundary], LineColor, clWindow{Color});

      StackFree(StrokeList);
      StackFree(PointsList);
    end;

    { Draw the cells in the four areas }
    Sel := Selection;
    FrameFlags1 := 0;
    FrameFlags2 := 0;
    if goFixedVertLine in Options then begin
      FrameFlags1 := BF_RIGHT;
      FrameFlags2 := BF_LEFT;
    end;
    if goFixedHorzLine in Options then begin
      FrameFlags1 := FrameFlags1 or BF_BOTTOM;
      FrameFlags2 := FrameFlags2 or BF_TOP;
    end;
    DrawCells(0, 0, 0, 0, Horz.FixedBoundary, Vert.FixedBoundary, clBtnFace{FixedColor},
      [gdFixed]);
    DrawCells(1, 0, Horz.FixedBoundary, 0, Horz.GridBoundary,  //!! clip
      Vert.FixedBoundary, clBtnFace{FixedColor}, [gdFixed]);
    DrawCells(0, 1, 0, Vert.FixedBoundary, Horz.FixedBoundary,
      Vert.GridBoundary, clBtnFace{FixedColor}, [gdFixed]);
    DrawCells(1, 1, Horz.FixedBoundary,                   //!! clip
      Vert.FixedBoundary, Horz.GridBoundary, Vert.GridBoundary, clWindow{Color}, []);

    if Horz.GridBoundary < Horz.GridExtent then begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(MakeRect(Horz.GridBoundary, 0, Horz.GridExtent, Vert.GridBoundary));
    end;
    if Vert.GridBoundary < Vert.GridExtent then begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(MakeRect(0, Vert.GridBoundary, Horz.GridExtent, Vert.GridExtent));
    end;
  end;
end;

function TKOLStGrd.GetCol: Longint;
begin
  Result := 1;
end;

function TKOLStGrd.GetColWidths(Index: Integer): Integer;
begin
  Result := fDefaultColWidth;
end;

function TKOLStGrd.GetLeftCol: Longint;
begin
  Result := 1;
end;

function TKOLStGrd.GetRow: Longint;
begin
  Result := 1;
end;

function TKOLStGrd.GetRowHeights(Index: Integer): Integer;
begin
  Result := fDefaultRowHeight;
end;

function TKOLStGrd.GetSelection: TGridRect;
begin
  Result.Left := 1;
  Result.Top := 1;
  if (goRowSelect in Options)
    then Result.Right := ColCount-1
    else Result.Right := 1;
  Result.Bottom := 1;
end;

function TKOLStGrd.GetTopRow: Longint;
begin
  Result := 1;
end;

procedure TKOLStGrd.SetScrollBars(const Value: TScrollStyle);
var i: Longint;
    DrawInfo: tGridDrawInfo;
begin
  fScrollBars := Value;
  CalcDrawInfo(DrawInfo);
  i := GetWindowLong(Handle,gwl_Style);
  if (Value in [ssVertical,ssBoth]) and (DrawInfo.Horz.LastFullVisibleCell <= fRowCount)
    then i := i or ws_vScroll
    else i := i and not ws_vScroll;
  if (Value in [ssHorizontal,ssBoth]) and (DrawInfo.Vert.LastFullVisibleCell <= fColCount)
    then i := i or ws_hScroll
    else i := i and not ws_hScroll;
  ShowScrollBar(Handle,sb_Vert,(Value in [ssVertical,ssBoth]) and (DrawInfo.Horz.LastFullVisibleCell <= fRowCount));
  ShowScrollBar(Handle,sb_Horz,(Value in [ssHorizontal,ssBoth]) and (DrawInfo.Vert.LastFullVisibleCell <= fColCount));
  SetWindowLong(Handle,gwl_Style,i);
  Change;
end;
{
procedure TKOLStGrd.SetHasBorder(const Value: Boolean);
var i: Longint;
begin
  fHasBorder := Value;
  i := GetWindowLong(Handle,gwl_ExStyle);
  if Value then i := (i or ws_ex_ClientEdge) else i := (i and not ws_ex_ClientEdge);
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
  SetWindowLong(Handle,gwl_ExStyle,i);
  Repaint;
  Change;
end;
}
procedure TKOLStGrd.SetBorderStyle(const Value: tBorderStyle);
//var i: Longint;
begin
  fBorderStyle := Value;
{  i := GetWindowLong(Handle,gwl_ExStyle);
  if (Value = bsSingle)
    then i := (i or ws_ex_ClientEdge)
    else i := (i and not ws_ex_ClientEdge);
  SetWindowLong(Handle,gwl_ExStyle,i);}
  RecreateWnd;
  Change;
end;

procedure TKOLStGrd.CreateParams(var Params: Controls.TCreateParams);
//var DrawInfo: tGridDrawInfo;
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := Style or WS_TABSTOP;
//    CalcDrawInfo(DrawInfo);
    if (fScrollBars in [ssVertical, ssBoth]) then Style := Style or WS_VSCROLL;
    if (fScrollBars in [ssHorizontal, ssBoth]) then Style := Style or WS_HSCROLL;
    WindowClass.style := CS_DBLCLKS;
    if fBorderStyle = bsSingle then begin
      if fCtl3D then begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end else begin
        Style := Style or WS_BORDER;
        ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
      end;
    end;
  end;
end;

procedure TKOLStGrd.SetCtl3D(const Value: Boolean);
//var i: Longint;
begin
  fCtl3D := Value;
{  i := GetWindowLong(Handle,gwl_Style);
  if Value then i := (i or ws_Border)
           else i := (i and not ws_Border);
  SetWindowLong(Handle,gwl_Style,i);}
  RecreateWnd;
  Change;
end;

procedure TKOLStGrd.SetOnSelectCell(const Value: TSelectCellEvent);
begin
  fOnSelectCell := Value;
  Change;
end;

end.
