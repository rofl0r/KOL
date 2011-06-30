unit KolDragImageList;

interface
{$I KOLDEF.INC}
{$IFDEF _D7orHigher}
  {$WARN UNSAFE_TYPE OFF} // Too many such warnings in Delphi7
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}
uses Windows, Kol;

type
  PDragImageList = ^TDragImageList;
  TDragImageList = object(TObj)
  private
    FDragCursor: HCursor;
    FDragging: Boolean;
    FDragHandle: HWND;
    FDragHotspot: TPoint;
    FDragIndex: Integer;
    FImageList: PImageList;
    procedure CombineDragCursor;
    procedure SetDragCursor(Value: HCursor);
  protected
  public
    destructor Destroy; virtual;
    function BeginDrag(Window: HWND; X, Y: Integer): Boolean;
    function DragLock(Window: HWND; XPos, YPos: Integer): Boolean;
    function DragMove(X, Y: Integer): Boolean;
    procedure DragUnlock;
    function EndDrag: Boolean;
    function GetHotSpot: TPoint;
    procedure HideDragImage;
    function SetDragImage(Index, HotSpotX, HotSpotY: Integer): Boolean;
    procedure ShowDragImage;
    property DragCursor: HCursor read FDragCursor write SetDragCursor;
    property Dragging: Boolean read FDragging;
    property ImageList: PImageList read FImageList;
  end;

  function NewDragImageList(AOwner: PControl): PDragImageList;

implementation

{ TDragImageList }

function NewDragImageList(AOwner: PControl): PDragImageList;
begin
    New(Result, Create);
    Result.FImageList:= NewImageList(AOwner);
    Result.DragCursor:= 0;
end;

function ClientToWindow(Handle: HWND; X, Y: Integer): TPoint;
var Rect: TRect;
    Point: TPoint;
begin
  Point.X := X; Point.Y := Y;
  ClientToScreen(Handle, Point);
  GetWindowRect(Handle, Rect);
  Result.X := Point.X - Rect.Left;
  Result.Y := Point.Y - Rect.Top;
end;

function TDragImageList.BeginDrag(Window: HWND; X, Y: Integer): Boolean;
begin
  Result := False;
  if FImageList.Handle<>0 then begin
    if not Dragging then SetDragImage(FDragIndex, FDragHotspot.x, FDragHotspot.y);
    CombineDragCursor;
    Result := DragLock(Window, X, Y);
    if Result then ShowCursor(False);
  end;
end;

procedure TDragImageList.CombineDragCursor;
var
  TempList: HImageList;
  Point: TPoint;
begin
  if DragCursor <> 0 then
  begin
    TempList := ImageList_Create(GetSystemMetrics(SM_CXCURSOR),
      GetSystemMetrics(SM_CYCURSOR), ILC_MASK, 1, 1);
    try
      ImageList_AddIcon(TempList, DragCursor);
      ImageList_AddIcon(TempList, DragCursor);
      ImageList_SetDragCursorImage(TempList, 0, 0, 0);
      ImageList_GetDragImage(nil, @Point);
      ImageList_SetDragCursorImage(TempList, 1, Point.X, Point.Y);
    finally
      ImageList_Destroy(TempList);
    end;
  end;
end;

destructor TDragImageList.Destroy;
begin
    FImageList.Free;
    inherited;
end;

function TDragImageList.DragLock(Window: HWND; XPos,
  YPos: Integer): Boolean;
begin
  Result := False;
  if (FImageList.Handle<>0) and (Window <> FDragHandle) then begin
    DragUnlock;
    FDragHandle := Window;
    with ClientToWindow(FDragHandle, XPos, YPos) do
      Result := ImageList_DragEnter(FDragHandle, X, Y);
  end;
end;

function TDragImageList.DragMove(X, Y: Integer): Boolean;
begin
  if FImageList.Handle<>0 then
    with ClientToWindow(FDragHandle, X, Y) do
      Result := ImageList_DragMove(X, Y)
  else
    Result := False;
end;

procedure TDragImageList.DragUnlock;
begin
  if (FImageList.Handle<>0) and (FDragHandle <> 0) then
  begin
    ImageList_DragLeave(FDragHandle);
    FDragHandle := 0;
  end;
end;

function TDragImageList.EndDrag: Boolean;
begin
  if (FImageList.Handle<>0) and Dragging then begin
    DragUnlock;
    Result := ImageList_EndDrag;
    FDragging := False;
    DragCursor := 0;
    ShowCursor(True);
  end
  else Result := False;
end;

function TDragImageList.GetHotSpot: TPoint;
begin
  Result := MakePoint(0, 0);
  if (FImageList.Handle<>0) and Dragging then
    ImageList_GetDragImage(nil, @Result);
end;

procedure TDragImageList.HideDragImage;
begin
  if FImageList.Handle<>0 then ImageList_DragShowNoLock(False);
end;

procedure TDragImageList.SetDragCursor(Value: HCursor);
begin
  if Value <> DragCursor then
  begin
    FDragCursor := Value;
    if Dragging then CombineDragCursor;
  end;
end;

function TDragImageList.SetDragImage(Index, HotSpotX, HotSpotY: Integer): Boolean;
begin
  if FImageList.Handle<>0 then begin
    FDragIndex := Index;
    FDragHotspot.x := HotSpotX;
    FDragHotspot.y := HotSpotY;
    ImageList_BeginDrag(ImageList.Handle, Index, HotSpotX, HotSpotY);
    Result := True;
    FDragging := Result;
  end
  else Result := False;
end;

procedure TDragImageList.ShowDragImage;
begin
  if FImageList.Handle<>0 then ImageList_DragShowNoLock(True);
end;

end.
